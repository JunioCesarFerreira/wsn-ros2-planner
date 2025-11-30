(define (problem wsn-instance-debug-01)
  (:domain wsn-sink-mobility-buffering-temporal)

  ;; ----------------------------
  ;; Objetos
  ;; ----------------------------
  (:objects
    l0 l1 l2 - location
    n1 n2 - sensor
  )

  (:init
    ;; ----------------------------
    ;; Base e posição inicial
    ;; ----------------------------
    (at-sink l0)
    (is-base l0)

    ;; ----------------------------
    ;; Grafo de movimento do sink
    ;; l0 -- l1 -- l2
    ;; ----------------------------
    (adjacent l0 l1)
    (adjacent l1 l0)
    (adjacent l1 l2)
    (adjacent l2 l1)

    ;; Custos de movimento simples
    (= (movement-energy-cost l0 l1) 3.0)
    (= (movement-energy-cost l1 l0) 3.0)
    (= (movement-energy-cost l1 l2) 4.0)
    (= (movement-energy-cost l2 l1) 4.0)

    (= (movement-time-cost l0 l1) 7.0)
    (= (movement-time-cost l1 l0) 7.0)
    (= (movement-time-cost l1 l2) 5.0)
    (= (movement-time-cost l2 l1) 5.0)

    ;; ----------------------------
    ;; Alcance do sink (reachable)
    ;; ----------------------------
    (reachable l1 n1)
    (reachable l2 n2)

    ;; Neste problema mínimo, vamos ignorar tráfego sensor-sensor:
    ;; você pode manter os links só para não mexer no domínio.
    (link n1 n2)
    (link n2 n1)

    ;; ----------------------------
    ;; Energia dos sensores
    ;; ----------------------------
    (= (energy n1) 10.0)
    (= (energy n2) 10.0)

    ;; ----------------------------
    ;; Buffers dos sensores
    ;; ----------------------------
    (= (buffer n1) 3)
    (= (buffer n2) 3)

    ;; Capacidade máxima de buffer (não vai saturar aqui)
    (= (buffer-capacity) 5)

    ;; ----------------------------
    ;; Custos TX/RX entre sensores (irrelevante aqui,
    ;; mas definidos para não deixar nada faltando)
    ;; ----------------------------
    (= (tx-cost n1 n2) 1.0)
    (= (rx-cost n1 n2) 0.5)
    (= (tx-cost n2 n1) 1.0)
    (= (rx-cost n2 n1) 0.5)

    ;; ----------------------------
    ;; Custos TX/RX para o sink (por local)
    ;; ----------------------------
    (= (tx-cost-sink l1 n1) 1.0)
    (= (rx-cost-sink l1 n1) 1.0)

    (= (tx-cost-sink l2 n2) 1.0)
    (= (rx-cost-sink l2 n2) 1.0)

    ;; ----------------------------
    ;; Energia e buffers do sink
    ;; ----------------------------
    (= (sink-max-energy) 50.0)
    (= (sink-energy) 50.0)

    ;; Capacidade pequena pra ficar explícito
    (= (sink-capacity) 3)

    ;; Nada coletado / entregue inicialmente
    (= (sink-collected) 0)
    (= (sink-delivered) 0)
  )

  ;; ----------------------------
  ;; Objetivo:
  ;;  - Entregar unidades na base
  ;;  - E terminar na base
  ;; ----------------------------
  (:goal
    (and
      (>= (sink-delivered) 6)
      (at-sink l0)
    )
  )

  ;; ----------------------------
  ;; Métrica: minimizar tempo total
  ;; ----------------------------
  (:metric minimize (total-time))
)
