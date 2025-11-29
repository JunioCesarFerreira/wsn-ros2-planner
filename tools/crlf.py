#!/usr/bin/env python3
import os
import sys

def convert_file_line_endings(path: str, verbose: bool = False) -> None:
    """Converte finais de linha CRLF → LF em um arquivo, se necessário."""
    try:
        with open(path, 'rb') as f:
            data = f.read()
    except Exception as e:
        if verbose:
            print(f"[ERRO] Falha ao ler {path}: {e}")
        return

    # substituir b'\r\n' por b'\n'
    new_data = data.replace(b'\r\n', b'\n')

    if new_data != data:
        if verbose:
            print(f"[INFO] Convertendo {path}")
        try:
            with open(path, 'wb') as f:
                f.write(new_data)
        except Exception as e:
            print(f"[ERRO] Falha ao gravar {path}: {e}")

def convert_directory(root_dir: str, 
                      extensions: tuple | None = None, 
                      ignore_dirs: tuple = ('.git', 'build', 'install'), 
                      verbose: bool = False) -> None:
    """
    Percorre o diretório recursivamente e para cada arquivo com extensão em `extensions`
    realiza a conversão de finais de linha CRLF → LF.
    
    :param root_dir: diretório raiz a partir do qual percorrer.
    :param extensions: tupla de extensões (ex: ('.py', '.sh')). Se None, converte todos os arquivos.
    :param ignore_dirs: tupla de nomes de diretórios a ignorar completamente.
    :param verbose: se True imprime cada conversão ou erro.
    """
    for dirpath, dirnames, filenames in os.walk(root_dir):
        # remover (mutar) os subdiretórios a serem ignorados para não descer neles
        # (modifica dirnames in-place para evitar descer em ignorados)
        dirnames[:] = [d for d in dirnames if d not in ignore_dirs]
        
        for filename in filenames:
            if extensions is None or filename.lower().endswith(extensions):
                full_path = os.path.join(dirpath, filename)
                convert_file_line_endings(full_path, verbose=verbose)

def main():
    if len(sys.argv) < 2:
        print(f"Uso: {sys.argv[0]} <diretório-raiz> [extensão1 extensão2 ...]")
        sys.exit(1)

    root_dir = sys.argv[1]
    if not os.path.isdir(root_dir):
        print(f"Erro: {root_dir!r} não é um diretório válido.")
        sys.exit(1)

    if len(sys.argv) > 2:
        # construir tupla de extensões, garantindo precedência do ponto ‘.’
        exts = tuple(ext if ext.startswith('.') else f'.{ext}' for ext in sys.argv[2:])
    else:
        exts = None  # converter todas as extensões

    print(f"Iniciando conversão em: {root_dir}")
    if exts:
        print(f"Apenas arquivos com extensões: {exts}")
    convert_directory(root_dir, extensions=exts, verbose=True)
    print("Conversão concluída.")

if __name__ == "__main__":
    main()
