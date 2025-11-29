(define (problem wsn-instance-01)
  (:domain wsn-sink-mobility-buffering-temporal)

  (:objects
    l0 l1 l2 l3 - location
    n1 n2 n3 n4 n5 n6 - sensor
  )

  (:init
    (at-sink l0)

    (adjacent l0 l1)
    (adjacent l1 l0)
    (adjacent l0 l2)
    (adjacent l2 l0)
    (adjacent l0 l3)
    (adjacent l3 l0)

    (reachable n1 l1)
    (reachable n2 l1)
    (reachable n3 l1)
    (reachable n4 l2)
    (reachable n5 l2)
    (reachable n5 l3)
    (reachable n6 l3)

    (link n1 n2 l1)
    (link n2 n1 l1)
    (link n3 n1 l1)
    (link n3 n2 l1)
    (link n4 n5 l2)
    (link n5 n4 l2)
    (link n5 n6 l3)
    (link n6 n5 l3)

    ;; energia inicial
    (= (energy n1) 100.0)
    (= (energy n2) 100.0)
    (= (energy n3) 100.0)
    (= (energy n4) 100.0)
    (= (energy n5) 100.0)
    (= (energy n6) 100.0)

    ;; buffers atuais
    (= (buffer n1) 5)
    (= (buffer n2) 5)
    (= (buffer n3) 5)
    (= (buffer n4) 5)
    (= (buffer n5) 5)
    (= (buffer n6) 5)

    ;; capacidade máxima de buffer
    (= (buffer-capacity n1) 10)
    (= (buffer-capacity n2) 10)
    (= (buffer-capacity n3) 10)
    (= (buffer-capacity n4) 10)
    (= (buffer-capacity n5) 10)
    (= (buffer-capacity n6) 10)

    ;; custos energéticos
    (= (tx-cost n1 n2) 1.0)
    (= (rx-cost n1 n2) 0.5)
    (= (tx-cost n2 n1) 1.0)
    (= (rx-cost n2 n1) 0.5)
    (= (tx-cost n3 n1) 1.0)
    (= (rx-cost n1 n3) 0.5)
    (= (tx-cost n3 n2) 1.0)
    (= (rx-cost n2 n1) 0.5)
    (= (tx-cost n5 n4) 1.0)
    (= (rx-cost n4 n5) 0.5)
    (= (tx-cost n5 n6) 1.0)
    (= (rx-cost n6 n5) 0.5)

    (= (tx-cost-sink n1) 1.0)
    (= (tx-cost-sink n2) 1.0)
    (= (tx-cost-sink n3) 1.0)
    (= (tx-cost-sink n4) 1.0)
    (= (tx-cost-sink n5) 1.0)
    (= (tx-cost-sink n6) 1.0)

    ;; nada coletado inicialmente
    (= (sink-collected) 0)
  )

  (:goal
    (and
      (>= (sink-collected) 21)
    )
  )

  (:metric minimize (total-time))
)
