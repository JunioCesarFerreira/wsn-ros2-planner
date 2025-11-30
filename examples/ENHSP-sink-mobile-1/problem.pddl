(define (problem wsn-instance-debug-discrete-01)
  (:domain wsn-sink-mobility-buffering-discrete)

  (:objects
    l0 l1 l2 - location
    n1 n2 n3 - sensor
  )

  (:init
    ;; relógio inicial
    (= (time) 0)

    ;; base e sink
    (at-sink l0)
    (is-base l0)

    ;; grafo de movimento
    (adjacent l0 l1)
    (adjacent l1 l0)
    (adjacent l1 l2)
    (adjacent l2 l1)

    ;; custos de movimento
    (= (movement-energy-cost l0 l1) 3.0)
    (= (movement-energy-cost l1 l0) 3.0)
    (= (movement-energy-cost l1 l2) 4.0)
    (= (movement-energy-cost l2 l1) 4.0)

    (= (movement-time-cost l0 l1) 3.0)
    (= (movement-time-cost l1 l0) 3.0)
    (= (movement-time-cost l1 l2) 4.0)
    (= (movement-time-cost l2 l1) 4.0)

    ;; alcance
    (reachable l1 n1)
    (reachable l2 n2)
    (reachable l2 n3)

    ;; links (não muito usados aqui)
    (link n1 n2)
    (link n2 n1)

    ;; energia sensores
    (= (energy n1) 10.0)
    (= (energy n2) 10.0)
    (= (energy n3) 10.0)

    ;; buffers
    (= (buffer n1) 3)
    (= (buffer n2) 3)
    (= (buffer n3) 3)
    (= (buffer-capacity) 5)

    ;; custos sensor-sensor (irrelevantes aqui)
    (= (tx-cost n1 n2) 1.0)
    (= (rx-cost n1 n2) 0.5)
    (= (tx-cost n2 n1) 1.0)
    (= (rx-cost n2 n1) 0.5)

    ;; custos sensor-sink
    (= (tx-cost-sink l1 n1) 1.0)
    (= (rx-cost-sink l1 n1) 1.0)
    (= (tx-cost-sink l2 n2) 1.0)
    (= (rx-cost-sink l2 n2) 1.0)
    (= (tx-cost-sink l2 n3) 1.0)
    (= (rx-cost-sink l2 n3) 1.0)

    ;; Energia do sink
    (= (sink-max-energy) 50.0)
    (= (sink-energy) 50.0)

    ;; Capacidade do sink
    (= (sink-capacity) 5)
    (= (sink-collected) 0)
    (= (sink-delivered) 0)
  )

  (:goal
    (and
      (>= (sink-delivered) 9)
      (at-sink l0)
    )
  )

  (:metric minimize (time))
)
