#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
add_action_node.py (versão corrigida)

REPO/
├── action_planner/
│   ├── launch/launch.py            # (edita nodes_to_add = [...])
│   ├── scripts/
│   │   ├── lifecycle_manager.py    # (edita nodes = [...])
│   │   └── <novo_node>.py          # (cria)
│   ├── CMakeLists.txt              # (edita install(PROGRAMS ...))
│   └── package.xml
└── tools/add_action_node.py

Uso:
  python add_action_node.py --name pegar --class PegarAction
  python add_action_node.py --name entregar --class EntregarAction --depends "pegar,outro"
  python add_action_node.py --name inspecionar --dry-run
"""

import argparse
import re
import shutil
import sys
from pathlib import Path
from typing import List, Optional, Tuple

REPO_ROOT   = Path(__file__).resolve().parent / ".."
PKG_DIR     = REPO_ROOT / "action_planner"
SCRIPTS_DIR = PKG_DIR / "scripts"
LAUNCH_FILE = PKG_DIR / "launch" / "launch.py"
LIFECYCLE_FILE = SCRIPTS_DIR / "lifecycle_manager.py"
CMAKELISTS = PKG_DIR / "CMakeLists.txt"

TEMPLATE_SCRIPT = """#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import rclpy
from rclpy.node import Node

class {class_name}(Node):
    def __init__(self):
        super().__init__("{node_name}")
        # TODO: inicialize publishers/subscribers/clients/servers de ação aqui
        # self.get_logger().info("Node '{node_name}' iniciado.")

    def new_goal(self, *args, **kwargs):
        \"\"\"Atualize os argumentos para corresponder ao domain.pddl.\"\"\"
        pass


def main():
    rclpy.init()
    node = {class_name}()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        node.destroy_node()
        rclpy.shutdown()

if __name__ == "__main__":
    main()
"""

def info(msg: str): print(f"[INFO] {msg}")
def warn(msg: str): print(f"[AVISO] {msg}")
def die(msg: str, code: int = 1):
    print(f"[ERRO] {msg}", file=sys.stderr); sys.exit(code)

def to_snake(s: str) -> str:
    s = s.strip()
    s = re.sub(r"[^0-9A-Za-z_]+", "_", s)
    s = re.sub(r"([a-z0-9])([A-Z])", r"\1_\2", s)
    return s.lower().strip("_")

def to_camel(s: str) -> str:
    parts = re.split(r"[_\-\s]+", s.strip())
    return "".join(p.capitalize() for p in parts if p)

def ensure_dir(p: Path):
    if not p.exists():
        p.mkdir(parents=True); info(f"Criado diretório: {p.relative_to(REPO_ROOT)}")

def backup_copy(path: Path) -> Optional[Path]:
    if not path.exists(): return None
    idx = 0
    while True:
        bak = path.with_suffix(path.suffix + (".bak" if idx == 0 else f".bak{idx}"))
        if not bak.exists(): break
        idx += 1
    shutil.copy2(path, bak)
    return bak

# ---------- Parser para achar a lista de topo var = [ ... ] ----------
def find_top_level_list(text: str, varname: str) -> Optional[Tuple[int, int, str]]:
    """
    Encontra a lista literal atribuída a `varname` no escopo de módulo.
    Retorna (start_idx, end_idx, indent), onde start_idx aponta para o '[' e end_idx
    é o índice do ']' correspondente + 1.
    """
    # âncora no início de linha: ^\s*varname\s*=\s*\[
    pat = re.compile(rf"(?m)^(\s*){re.escape(varname)}\s*=\s*\[")
    m = pat.search(text)
    if not m: return None
    indent = m.group(1)
    start = text.find('[', m.end() - 1)
    if start == -1: return None

    depth = 0
    i = start
    in_str = False
    str_char = ''
    escape = False
    while i < len(text):
        ch = text[i]
        if in_str:
            if escape:
                escape = False
            elif ch == '\\':
                escape = True
            elif ch == str_char:
                in_str = False
        else:
            if ch in ('"', "'"):
                in_str = True
                str_char = ch
            elif ch == '[':
                depth += 1
            elif ch == ']':
                depth -= 1
                if depth == 0:
                    return (start, i + 1, indent)
        i += 1
    return None

def insert_into_list_literal(text: str, varname: str, entry: str) -> Optional[str]:
    pos = find_top_level_list(text, varname)
    if not pos: return None
    start, end, indent = pos
    body = text[start:end]
    # inserir antes do ']' mantendo indentação e vírgula
    before = text[:start]
    inside = body[1:-1]  # conteúdo sem colchetes
    after = text[end:]

    # garantir quebra e indentação
    sep = "" if inside.endswith("\n") or inside.strip() == "" else "\n"
    entry_str = f"{sep}{indent}    {entry}\n"
    new_body = "[" + inside + entry_str + indent + "]"
    return before + new_body + after

# ---------------------------------------------------------------------
# 1) Criar scripts/<name>.py
# ---------------------------------------------------------------------
def create_action_script(name: str, class_name: str, dry_run: bool) -> Path:
    ensure_dir(SCRIPTS_DIR)
    target = SCRIPTS_DIR / f"{name}.py"
    if target.exists():
        info(f"Script já existe: {target.relative_to(REPO_ROOT)} (não será sobrescrito).")
        return target
    content = TEMPLATE_SCRIPT.format(class_name=class_name, node_name=name)
    if dry_run:
        info(f"[dry-run] Criaria arquivo: {target.relative_to(REPO_ROOT)}")
    else:
        target.write_text(content, encoding="utf-8"); target.chmod(0o755)
        info(f"Criado: {target.relative_to(REPO_ROOT)}")
    return target

# ---------------------------------------------------------------------
# 2) Atualizar action_planner/CMakeLists.txt
# ---------------------------------------------------------------------
def update_cmakelists(name: str, dry_run: bool):
    rel_script = f"scripts/{name}.py"
    if not CMAKELISTS.exists():
        warn(f"{CMAKELISTS.relative_to(REPO_ROOT)} não encontrado — criando com bloco install.")
        lines = [
            "cmake_minimum_required(VERSION 3.5)\n",
            "project(action_planner)\n",
            "find_package(ament_cmake REQUIRED)\n",
            "install(PROGRAMS\n",
            f"  {rel_script}\n",
            "  DESTINATION lib/${PROJECT_NAME})\n",
            "ament_package()\n",
        ]
        if dry_run:
            info("[dry-run] Criaria CMakeLists.txt com bloco install.")
        else:
            CMAKELISTS.write_text("".join(lines), encoding="utf-8")
            info(f"Criado: {CMAKELISTS.relative_to(REPO_ROOT)}")
        return

    text = CMAKELISTS.read_text(encoding="utf-8")
    if re.search(rf"\b{re.escape(rel_script)}\b", text):
        info("CMakeLists.txt já contém o script; nada a fazer.")
        return

    pattern = re.compile(
        r"(install\(\s*PROGRAMS\s*)(.*?)(\s*DESTINATION\s+lib/\$\{PROJECT_NAME\}\s*\))",
        flags=re.DOTALL | re.IGNORECASE
    )
    m = pattern.search(text)
    if m:
        before, middle, after = m.groups()
        insertion = f"\n  {rel_script}"
        new_text = text[:m.start()] + before + middle + insertion + after + text[m.end():]
        if dry_run:
            info("[dry-run] Atualizaria CMakeLists.txt (bloco install existente).")
        else:
            bak = backup_copy(CMAKELISTS)
            if bak:
                info(f"Backup: {bak.name}")
            CMAKELISTS.write_text(new_text, encoding="utf-8")
            info("CMakeLists.txt atualizado.")
    else:
        add = f"\ninstall(PROGRAMS\n  {rel_script}\n  DESTINATION lib/${{PROJECT_NAME}})\n"
        if dry_run:
            info("[dry-run] Anexaria novo bloco install(PROGRAMS) ao final do CMakeLists.txt.")
        else:
            bak = backup_copy(CMAKELISTS)
            if bak:
                info(f"Backup: {bak.name}")
            CMAKELISTS.write_text(text + add, encoding="utf-8")
            info("CMakeLists.txt atualizado com novo bloco install.")

# ---------------------------------------------------------------------
# 3) Adicionar o nó em scripts/lifecycle_manager.py -> nodes = [...]
# ---------------------------------------------------------------------
def update_lifecycle_nodes(name: str, depends: List[str], dry_run: bool):
    if not LIFECYCLE_FILE.exists():
        warn(f"{LIFECYCLE_FILE.relative_to(REPO_ROOT)} não encontrado — pulando etapa dos 'nodes'.")
        return
    txt = LIFECYCLE_FILE.read_text(encoding="utf-8")

    # já existe?
    if re.search(rf"['\"]node_name['\"]\s*:\s*['\"]{re.escape(name)}['\"]", txt):
        info(f"O nó '{name}' já consta em lifecycle_manager.py; nada a fazer.")
        return

    dep_list = ", ".join(f"'{d.strip()}'" for d in depends if d.strip())
    entry = (
        "{\n"
        f"        'node_name': '{name}',\n"
        f"        'depends_on': [{dep_list}]\n"
        "    },"
    )

    new_txt = insert_into_list_literal(txt, "nodes", entry)
    if new_txt is None:
        warn("Não encontrei a lista de topo 'nodes = [...]' em lifecycle_manager.py. (verifique o nome e o escopo)")
        return

    if dry_run:
        info("[dry-run] Inseriria entrada em lifecycle_manager.py -> nodes = [...].")
    else:
        bak = backup_copy(LIFECYCLE_FILE); info(f"Backup: {bak.name}" if bak else "")
        LIFECYCLE_FILE.write_text(new_txt, encoding="utf-8")
        info(f"Atualizado: {LIFECYCLE_FILE.relative_to(REPO_ROOT)}")

# ---------------------------------------------------------------------
# 4) Adicionar Node(...) em launch/launch.py -> nodes_to_add = [...]
# ---------------------------------------------------------------------
def update_launch_nodes_to_add(name: str, dry_run: bool):
    if not LAUNCH_FILE.exists():
        warn(f"{LAUNCH_FILE.relative_to(REPO_ROOT)} não encontrado — pulando etapa 'nodes_to_add'.")
        return
    txt = LAUNCH_FILE.read_text(encoding="utf-8")

    # já existe um Node com name='<name>'?
    if re.search(rf"name\s*=\s*['\"]{re.escape(name)}['\"]", txt):
        info(f"O Node '{name}' já consta em launch.py; nada a fazer.")
        return

    node_block = (
        "Node(\n"
        "            package='action_planner',\n"
        f"            executable='{name}.py',\n"
        f"            name='{name}',\n"
        "            output='screen',\n"
        "            parameters=[]\n"
        "        ),"
    )

    new_txt = insert_into_list_literal(txt, "nodes_to_add", node_block)
    if new_txt is None:
        warn("Não encontrei a lista de topo 'nodes_to_add = [...]' em launch.py. (verifique o nome e o escopo)")
        return

    if dry_run:
        info("[dry-run] Inseriria Node(...) em launch.py -> nodes_to_add = [...].")
    else:
        bak = backup_copy(LAUNCH_FILE); info(f"Backup: {bak.name}" if bak else "")
        LAUNCH_FILE.write_text(new_txt, encoding="utf-8")
        info(f"Atualizado: {LAUNCH_FILE.relative_to(REPO_ROOT)}")

# ---------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------
def main():
    ap = argparse.ArgumentParser(description="Cria e registra um novo action node (ROS2).")
    ap.add_argument("--name", required=True, help="nome do node (snake_case).")
    ap.add_argument("--class", dest="class_name", default=None, help="nome da classe (CamelCase).")
    ap.add_argument("--depends", default="", help="lista de dependências separada por vírgula.")
    ap.add_argument("--dry-run", action="store_true", help="simula sem escrever alterações.")
    args = ap.parse_args()

    node_name = to_snake(args.name)
    class_name = args.class_name or (to_camel(node_name) + "Action")
    depends = [d.strip() for d in args.depends.split(",")] if args.depends else []

    info(f"Repo raiz : {REPO_ROOT}")
    info(f"Pacote    : {PKG_DIR}")
    info(f"Node name : {node_name}")
    info(f"Class     : {class_name}")
    info(f"Depends   : {', '.join(depends) if depends else '(nenhuma)'}")

    # 1) script
    create_action_script(node_name, class_name, args.dry_run)

    # 2) src/CMakeLists.txt
    update_cmakelists(node_name, args.dry_run)

    # 3) scripts/lifecycle_manager.py -> nodes
    update_lifecycle_nodes(node_name, depends, args.dry_run)

    # 4) launch/launch.py -> nodes_to_add
    update_launch_nodes_to_add(node_name, args.dry_run)

    info("Concluído.")

if __name__ == "__main__":
    main()
