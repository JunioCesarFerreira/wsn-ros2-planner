(define (problem wsn-instance-01)
  (:domain wsn-sink-mobility-buffering-temporal)

  ;; --------------------------------------------------
  ;; Objetos
  ;; --------------------------------------------------
  (:objects
    b l1 l2 l3 l4 l5 l6 l7 l8 l9 l10 l11 - location
    n1 n2 n3 n4 n5 n6 n7 n8 n9 n10 n11 n12 n13 n14 n15 n16 - sensor
  )

  (:init
    ;; ------------------------------------------------
    ;; Base e posição inicial do sink
    ;; ------------------------------------------------
    (is-base b)
    (at-sink b)

    ;; ------------------------------------------------
    ;; Adjacências (grafo de movimento do sink)
    ;; ------------------------------------------------
    (adjacent b l1)
    (adjacent l1 b)
    (adjacent b l2)
    (adjacent l2 b)

    (adjacent l1 l3)
    (adjacent l3 l1)
    (adjacent l1 l6)
    (adjacent l6 l1)
    (adjacent l1 l7)
    (adjacent l7 l1)
    (adjacent l1 l8)
    (adjacent l8 l1)

    (adjacent l2 l4)
    (adjacent l4 l2)

    (adjacent l3 l6)
    (adjacent l6 l3)

    (adjacent l4 l5)
    (adjacent l5 l4)

    (adjacent l5 l6)
    (adjacent l6 l5)

    (adjacent l6 l9)
    (adjacent l9 l6)
    (adjacent l6 l11)
    (adjacent l11 l6)

    (adjacent l7 l9)
    (adjacent l9 l7)

    (adjacent l8 l10)
    (adjacent l10 l8)

    (adjacent l9 l11)
    (adjacent l11 l9)
    
    (adjacent l10 l11)
    (adjacent l11 l10)

    ;; ------------------------------------------------
    ;; Custos energéticos de movimento
    ;; ------------------------------------------------
    (= (movement-energy-cost b l1) 10.0)
    (= (movement-energy-cost l1 b) 10.0)
    (= (movement-energy-cost b l2) 20.0)
    (= (movement-energy-cost l2 b) 20.0)

    (= (movement-energy-cost l1 l3) 12.0)
    (= (movement-energy-cost l3 l1) 12.0)
    (= (movement-energy-cost l1 l6) 15.0)
    (= (movement-energy-cost l6 l1) 15.0)
    (= (movement-energy-cost l1 l7) 13.0)
    (= (movement-energy-cost l7 l1) 13.0)
    (= (movement-energy-cost l1 l8) 23.0)
    (= (movement-energy-cost l8 l1) 23.0)

    (= (movement-energy-cost l2 l4) 7.0)
    (= (movement-energy-cost l4 l2) 7.0)

    (= (movement-energy-cost l3 l6) 8.0)
    (= (movement-energy-cost l6 l3) 8.0)

    (= (movement-energy-cost l4 l5) 11.0)
    (= (movement-energy-cost l5 l4) 11.0)

    (= (movement-energy-cost l5 l6) 9.0)
    (= (movement-energy-cost l6 l5) 9.0)

    (= (movement-energy-cost l6 l9) 14.0)
    (= (movement-energy-cost l9 l6) 14.0)
    (= (movement-energy-cost l6 l11) 16.0)
    (= (movement-energy-cost l11 l6) 16.0)

    (= (movement-energy-cost l7 l9) 5.0)
    (= (movement-energy-cost l9 l7) 5.0)

    (= (movement-energy-cost l8 l10) 7.0)
    (= (movement-energy-cost l10 l8) 7.0)

    (= (movement-energy-cost l9 l11) 9.0)
    (= (movement-energy-cost l11 l9) 9.0)
    
    (= (movement-energy-cost l10 l11) 10.0)
    (= (movement-energy-cost l11 l10) 10.0)

    (= (movement-time-cost b l1) 10.0)
    (= (movement-time-cost l1 b) 10.0)
    (= (movement-time-cost b l2) 20.0)
    (= (movement-time-cost l2 b) 20.0)

    ;; ------------------------------------------------
    ;; Custos temporais de movimento
    ;; ------------------------------------------------
    (= (movement-time-cost l1 l3) 12.0)
    (= (movement-time-cost l3 l1) 12.0)
    (= (movement-time-cost l1 l6) 15.0)
    (= (movement-time-cost l6 l1) 15.0)
    (= (movement-time-cost l1 l7) 13.0)
    (= (movement-time-cost l7 l1) 13.0)
    (= (movement-time-cost l1 l8) 23.0)
    (= (movement-time-cost l8 l1) 23.0)

    (= (movement-time-cost l2 l4) 7.0)
    (= (movement-time-cost l4 l2) 7.0)

    (= (movement-time-cost l3 l6) 8.0)
    (= (movement-time-cost l6 l3) 8.0)

    (= (movement-time-cost l4 l5) 11.0)
    (= (movement-time-cost l5 l4) 11.0)

    (= (movement-time-cost l5 l6) 9.0)
    (= (movement-time-cost l6 l5) 9.0)

    (= (movement-time-cost l6 l9) 14.0)
    (= (movement-time-cost l9 l6) 14.0)
    (= (movement-time-cost l6 l11) 16.0)
    (= (movement-time-cost l11 l6) 16.0)

    (= (movement-time-cost l7 l9) 5.0)
    (= (movement-time-cost l9 l7) 5.0)

    (= (movement-time-cost l8 l10) 7.0)
    (= (movement-time-cost l10 l8) 7.0)

    (= (movement-time-cost l9 l11) 9.0)
    (= (movement-time-cost l11 l9) 9.0)
    
    (= (movement-time-cost l10 l11) 10.0)
    (= (movement-time-cost l11 l10) 10.0)

    ;; ------------------------------------------------
    ;; Alcance nos locais de parada
    ;; ------------------------------------------------
    (reachable l2 n1)
    (reachable l2 n5)
    (reachable l3 n1)
    (reachable l3 n2)
    (reachable l4 n4)
    (reachable l4 n5)
    (reachable l4 n6)
    (reachable l5 n3)
    (reachable l5 n4)
    (reachable l5 n6)
    (reachable l5 n7)
    (reachable l6 n3)
    (reachable l6 n2)
    (reachable l7 n8)
    (reachable l7 n9)
    (reachable l7 n10)
    (reachable l8 n9)
    (reachable l8 n11)
    (reachable l9 n10)
    (reachable l9 n12)
    (reachable l10 n11)
    (reachable l10 n12)
    (reachable l10 n13)
    (reachable l11 n14)
    (reachable l11 n16)

    ;; ------------------------------------------------
    ;; Grafo de comunicação sensores
    ;; ------------------------------------------------
    (link n1 n2)
    (link n2 n1)
    (link n1 n4)
    (link n4 n1)
    (link n2 n3)
    (link n3 n2)
    (link n2 n4)
    (link n4 n2)
    (link n3 n4)
    (link n4 n3)
    (link n4 n5)
    (link n5 n4)
    (link n4 n6)
    (link n6 n4)
    (link n5 n6)
    (link n6 n5)
    (link n6 n7)
    (link n7 n6)

    (link n8 n9)
    (link n9 n8)
    (link n9 n10)
    (link n10 n9)
    (link n9 n11)
    (link n11 n9)
    (link n10 n11)
    (link n11 n10)
    (link n11 n12)
    (link n12 n11)
    (link n12 n13)
    (link n13 n12)
    (link n12 n14)
    (link n14 n12)
    (link n12 n15)
    (link n15 n12)
    (link n14 n15)
    (link n15 n14)
    (link n14 n16)
    (link n16 n14)
    (link n15 n16)
    (link n16 n15)

    ;; ------------------------------------------------
    ;; Energia inicial dos sensores
    ;; ------------------------------------------------
    (= (energy n1) 1000.0)
    (= (energy n2) 1000.0)
    (= (energy n3) 1000.0)
    (= (energy n4) 1000.0)
    (= (energy n5) 1000.0)
    (= (energy n6) 1000.0)
    (= (energy n7) 1000.0)
    (= (energy n8) 1000.0)
    (= (energy n9) 1000.0)
    (= (energy n10) 1000.0)
    (= (energy n11) 1000.0)
    (= (energy n12) 1000.0)
    (= (energy n13) 1000.0)
    (= (energy n14) 1000.0)
    (= (energy n15) 1000.0)
    (= (energy n16) 1000.0)

    ;; ------------------------------------------------
    ;; Buffers atuais dos sensores
    ;; ------------------------------------------------
    (= (buffer n1) 5)
    (= (buffer n2) 5)
    (= (buffer n3) 5)
    (= (buffer n4) 5)
    (= (buffer n5) 5)
    (= (buffer n6) 5)
    (= (buffer n7) 5)

    (= (buffer n8) 5)
    (= (buffer n9) 5)
    (= (buffer n10) 5)
    (= (buffer n11) 5)
    (= (buffer n12) 5)
    (= (buffer n13) 5)
    (= (buffer n14) 5)
    (= (buffer n15) 5)
    (= (buffer n16) 5)

    ;; ------------------------------------------------
    ;; Capacidade máxima de buffer por sensor
    ;; ------------------------------------------------
    (= (buffer-capacity) 10)

    ;; ------------------------------------------------
    ;; Custos energéticos TX/RX para todos os pares com link
    ;; ------------------------------------------------
    (= (tx-cost  n1 n2) 1.0)
    (= (tx-cost  n2 n1) 1.0)
    (= (tx-cost  n1 n4) 1.0)
    (= (tx-cost  n4 n1) 1.0)
    (= (tx-cost  n2 n3) 1.0)
    (= (tx-cost  n3 n2) 1.0)
    (= (tx-cost  n2 n4) 1.0)
    (= (tx-cost  n4 n2) 1.0)
    (= (tx-cost  n3 n4) 1.0)
    (= (tx-cost  n4 n3) 1.0)
    (= (tx-cost  n4 n5) 1.0)
    (= (tx-cost  n5 n4) 1.0)
    (= (tx-cost  n4 n6) 1.0)
    (= (tx-cost  n6 n4) 1.0)
    (= (tx-cost  n5 n6) 1.0)
    (= (tx-cost  n6 n5) 1.0)
    (= (tx-cost  n6 n7) 1.0)
    (= (tx-cost  n7 n6) 1.0)

    (= (tx-cost  n8 n9) 1.0)
    (= (tx-cost  n9 n8) 1.0)
    (= (tx-cost  n9 n10) 1.0)
    (= (tx-cost  n10 n9) 1.0)
    (= (tx-cost  n9 n11) 1.0)
    (= (tx-cost  n11 n9) 1.0)
    (= (tx-cost  n10 n11) 1.0)
    (= (tx-cost  n11 n10) 1.0)
    (= (tx-cost  n11 n12) 1.0)
    (= (tx-cost  n12 n11) 1.0)
    (= (tx-cost  n12 n13) 1.0)
    (= (tx-cost  n13 n12) 1.0)
    (= (tx-cost  n12 n14) 1.0)
    (= (tx-cost  n14 n12) 1.0)
    (= (tx-cost  n12 n15) 1.0)
    (= (tx-cost  n15 n12) 1.0)
    (= (tx-cost  n14 n15) 1.0)
    (= (tx-cost  n15 n14) 1.0)
    (= (tx-cost  n14 n16) 1.0)
    (= (tx-cost  n16 n14) 1.0)
    (= (tx-cost  n15 n16) 1.0)
    (= (tx-cost  n16 n15) 1.0)

    (= (rx-cost  n1 n2) 0.5)
    (= (rx-cost  n2 n1) 0.5)
    (= (rx-cost  n1 n4) 0.5)
    (= (rx-cost  n4 n1) 0.5)
    (= (rx-cost  n2 n3) 0.5)
    (= (rx-cost  n3 n2) 0.5)
    (= (rx-cost  n2 n4) 0.5)
    (= (rx-cost  n4 n2) 0.5)
    (= (rx-cost  n3 n4) 0.5)
    (= (rx-cost  n4 n3) 0.5)
    (= (rx-cost  n4 n5) 0.5)
    (= (rx-cost  n5 n4) 0.5)
    (= (rx-cost  n4 n6) 0.5)
    (= (rx-cost  n6 n4) 0.5)
    (= (rx-cost  n5 n6) 0.5)
    (= (rx-cost  n6 n5) 0.5)
    (= (rx-cost  n6 n7) 0.5)
    (= (rx-cost  n7 n6) 0.5)

    (= (rx-cost  n8 n9) 0.5)
    (= (rx-cost  n9 n8) 0.5)
    (= (rx-cost  n9 n10) 0.5)
    (= (rx-cost  n10 n9) 0.5)
    (= (rx-cost  n9 n11) 0.5)
    (= (rx-cost  n11 n9) 0.5)
    (= (rx-cost  n10 n11) 0.5)
    (= (rx-cost  n11 n10) 0.5)
    (= (rx-cost  n11 n12) 0.5)
    (= (rx-cost  n12 n11) 0.5)
    (= (rx-cost  n12 n13) 0.5)
    (= (rx-cost  n13 n12) 0.5)
    (= (rx-cost  n12 n14) 0.5)
    (= (rx-cost  n14 n12) 0.5)
    (= (rx-cost  n12 n15) 0.5)
    (= (rx-cost  n15 n12) 0.5)
    (= (rx-cost  n14 n15) 0.5)
    (= (rx-cost  n15 n14) 0.5)
    (= (rx-cost  n14 n16) 0.5)
    (= (rx-cost  n16 n14) 0.5)
    (= (rx-cost  n15 n16) 0.5)
    (= (rx-cost  n16 n15) 0.5)

    ;; ------------------------------------------------
    ;; Custos de transmissão para o sink
    ;; ------------------------------------------------
    (= (tx-cost-sink l2 n1) 1.0)
    (= (tx-cost-sink l2 n5) 1.0)
    (= (tx-cost-sink l3 n1) 1.0)
    (= (tx-cost-sink l3 n2) 1.0)
    (= (tx-cost-sink l4 n4) 2.0)
    (= (tx-cost-sink l4 n5) 1.0)
    (= (tx-cost-sink l4 n6) 1.0)
    (= (tx-cost-sink l5 n3) 1.0)
    (= (tx-cost-sink l5 n4) 2.0)
    (= (tx-cost-sink l5 n6) 2.0)
    (= (tx-cost-sink l5 n7) 1.0)
    (= (tx-cost-sink l6 n3) 1.0)
    (= (tx-cost-sink l6 n2) 3.0)
    (= (tx-cost-sink l7 n8) 1.0)
    (= (tx-cost-sink l7 n9) 1.0)
    (= (tx-cost-sink l7 n10) 1.0)
    (= (tx-cost-sink l8 n9) 1.0)
    (= (tx-cost-sink l8 n11) 1.0)
    (= (tx-cost-sink l9 n10) 1.0)
    (= (tx-cost-sink l9 n12) 1.0)
    (= (tx-cost-sink l10 n11) 1.0)
    (= (tx-cost-sink l10 n12) 1.0)
    (= (tx-cost-sink l10 n13) 1.0)
    (= (tx-cost-sink l11 n14) 1.0)
    (= (tx-cost-sink l11 n16) 1.0)

    (= (rx-cost-sink l2 n1) 1.0)
    (= (rx-cost-sink l2 n5) 1.0)
    (= (rx-cost-sink l3 n1) 1.0)
    (= (rx-cost-sink l3 n2) 1.0)
    (= (rx-cost-sink l4 n4) 2.0)
    (= (rx-cost-sink l4 n5) 1.0)
    (= (rx-cost-sink l4 n6) 1.0)
    (= (rx-cost-sink l5 n3) 1.0)
    (= (rx-cost-sink l5 n4) 2.0)
    (= (rx-cost-sink l5 n6) 2.0)
    (= (rx-cost-sink l5 n7) 1.0)
    (= (rx-cost-sink l6 n3) 1.0)
    (= (rx-cost-sink l6 n2) 3.0)
    (= (rx-cost-sink l7 n8) 1.0)
    (= (rx-cost-sink l7 n9) 1.0)
    (= (rx-cost-sink l7 n10) 1.0)
    (= (rx-cost-sink l8 n9) 1.0)
    (= (rx-cost-sink l8 n11) 1.0)
    (= (rx-cost-sink l9 n10) 1.0)
    (= (rx-cost-sink l9 n12) 1.0)
    (= (rx-cost-sink l10 n11) 1.0)
    (= (rx-cost-sink l10 n12) 1.0)
    (= (rx-cost-sink l10 n13) 1.0)
    (= (rx-cost-sink l11 n14) 1.0)
    (= (rx-cost-sink l11 n16) 1.0)

    ;; ------------------------------------------------
    ;; Energia e buffer do sink
    ;; ------------------------------------------------
    (= (sink-max-energy) 2000.0)
    (= (sink-energy) 2000.0)
    (= (sink-capacity) 64)
    (= (sink-collected) 0)
    (= (sink-delivered) 0)
  )

  ;; ----------------------------------------------------
  ;; Objetivo: entregar pelo menos 100 unidades de dados
  ;; e estar de volta na base
  ;; ----------------------------------------------------
  (:goal
    (and
      (>= (sink-delivered) 80)
      (at-sink b)
    )
  )

  ;; ----------------------------------------------------
  ;; Métrica: minimizar o tempo total
  ;; ----------------------------------------------------
  (:metric minimize (total-time))
)