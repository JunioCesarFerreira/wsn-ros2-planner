(define (problem wsn-instance-01)
  (:domain wsn-sink-mobility-buffering-temporal)

  ;; --------------------------------------------------
  ;; Objetos
  ;; --------------------------------------------------
  (:objects
    l0 l1 l2 l3 l4 l5 l6 l7 l8 - location
    n1 n2 n3 n4 n5 n6 n7
    n8 n9 n10 n11 n12 n13 n14 - sensor
  )

  (:init
    ;; ------------------------------------------------
    ;; Posição inicial do sink
    ;; ------------------------------------------------
    (at-sink l0)

    ;; ------------------------------------------------
    ;; Adjacências (grafo de movimento do sink)
    ;; Base l0 conecta uma entrada de cada região
    ;; Região 1: l1-l2-l3-l4
    ;; Região 2: l5-l6-l7-l8
    ;; ------------------------------------------------
    (adjacent l0 l1)
    (adjacent l1 l0)
    (adjacent l1 l2)
    (adjacent l2 l1)
    (adjacent l2 l3)
    (adjacent l3 l2)
    (adjacent l3 l4)
    (adjacent l4 l3)

    (adjacent l0 l5)
    (adjacent l5 l0)
    (adjacent l5 l6)
    (adjacent l6 l5)
    (adjacent l6 l7)
    (adjacent l7 l6)
    (adjacent l7 l8)
    (adjacent l8 l7)

    ;; ------------------------------------------------
    ;; Custos de movimento (simples: custo 1.0 por aresta)
    ;; ------------------------------------------------
    (= (movement-cost l0 l1) 1.0)
    (= (movement-cost l1 l0) 1.0)
    (= (movement-cost l1 l2) 1.0)
    (= (movement-cost l2 l1) 1.0)
    (= (movement-cost l2 l3) 1.0)
    (= (movement-cost l3 l2) 1.0)
    (= (movement-cost l3 l4) 1.0)
    (= (movement-cost l4 l3) 1.0)

    (= (movement-cost l0 l5) 1.0)
    (= (movement-cost l5 l0) 1.0)
    (= (movement-cost l5 l6) 1.0)
    (= (movement-cost l6 l5) 1.0)
    (= (movement-cost l6 l7) 1.0)
    (= (movement-cost l7 l6) 1.0)
    (= (movement-cost l7 l8) 1.0)
    (= (movement-cost l8 l7) 1.0)

    ;; ------------------------------------------------
    ;; Região 1 (l1..l4) – 7 sensores n1..n7
    ;; Estrutura em cadeia usando sensores "ponte"
    ;; ------------------------------------------------
    ;; l1: n1, n2, n3
    (reachable n1 l1)
    (reachable n2 l1)
    (reachable n3 l1)

    ;; l2: n3, n4, n5
    (reachable n3 l2)
    (reachable n4 l2)
    (reachable n5 l2)

    ;; l3: n5, n6
    (reachable n5 l3)
    (reachable n6 l3)

    ;; l4: n6, n7
    (reachable n6 l4)
    (reachable n7 l4)

    ;; Links locais em l1 (n1, n2, n3 totalmente conectados)
    (link n1 n2)
    (link n2 n1)
    (link n1 n3)
    (link n3 n1)
    (link n2 n3)
    (link n3 n2)

    ;; Links locais em l2 (n3, n4, n5 totalmente conectados)
    (link n3 n4)
    (link n4 n3)
    (link n3 n5)
    (link n5 n3)
    (link n4 n5)
    (link n5 n4)

    ;; Links em l3 (n5, n6)
    (link n5 n6)
    (link n6 n5)

    ;; Links em l4 (n6, n7)
    (link n6 n7)
    (link n7 n6)

    ;; ------------------------------------------------
    ;; Região 2 (l5..l8) – 7 sensores n8..n14
    ;; Estrutura similar em cadeia
    ;; ------------------------------------------------
    ;; l5: n8, n9, n10
    (reachable n8 l5)
    (reachable n9 l5)
    (reachable n10 l5)

    ;; l6: n10, n11
    (reachable n10 l6)
    (reachable n11 l6)

    ;; l7: n11, n12, n13
    (reachable n11 l7)
    (reachable n12 l7)
    (reachable n13 l7)

    ;; l8: n13, n14
    (reachable n13 l8)
    (reachable n14 l8)

    ;; Links em l5 (n8, n9, n10 totalmente conectados)
    (link n8 n9)
    (link n9 n8)
    (link n8 n10)
    (link n10 n8)
    (link n9 n10)
    (link n10 n9)

    ;; Links em l6 (n10, n11)
    (link n10 n11)
    (link n11 n10)

    ;; Links em l7 (n11, n12, n13 totalmente conectados)
    (link n11 n12)
    (link n12 n11)
    (link n11 n13)
    (link n13 n11)
    (link n12 n13)
    (link n13 n12)

    ;; Links em l8 (n13, n14)
    (link n13 n14)
    (link n14 n13)

    ;; ------------------------------------------------
    ;; Energia inicial dos sensores
    ;; ------------------------------------------------
    (= (energy n1) 100.0)
    (= (energy n2) 100.0)
    (= (energy n3) 100.0)
    (= (energy n4) 100.0)
    (= (energy n5) 100.0)
    (= (energy n6) 100.0)
    (= (energy n7) 100.0)

    (= (energy n8) 100.0)
    (= (energy n9) 100.0)
    (= (energy n10) 100.0)
    (= (energy n11) 100.0)
    (= (energy n12) 100.0)
    (= (energy n13) 100.0)
    (= (energy n14) 100.0)

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

    ;; ------------------------------------------------
    ;; Capacidade máxima de buffer por sensor
    ;; ------------------------------------------------
    (= (buffer-capacity) 10)

    ;; ------------------------------------------------
    ;; Custos energéticos TX/RX para todos os pares com link
    ;; (simples: TX = 1.0, RX = 0.5)
    ;; ------------------------------------------------

    ;; Região 1 – l1
    (= (tx-cost n1 n2) 1.0)
    (= (rx-cost n1 n2) 0.5)
    (= (tx-cost n2 n1) 1.0)
    (= (rx-cost n2 n1) 0.5)

    (= (tx-cost n1 n3) 1.0)
    (= (rx-cost n1 n3) 0.5)
    (= (tx-cost n3 n1) 1.0)
    (= (rx-cost n3 n1) 0.5)

    (= (tx-cost n2 n3) 1.0)
    (= (rx-cost n2 n3) 0.5)
    (= (tx-cost n3 n2) 1.0)
    (= (rx-cost n3 n2) 0.5)

    ;; Região 1 – l2
    (= (tx-cost n3 n4) 1.0)
    (= (rx-cost n3 n4) 0.5)
    (= (tx-cost n4 n3) 1.0)
    (= (rx-cost n4 n3) 0.5)

    (= (tx-cost n3 n5) 1.0)
    (= (rx-cost n3 n5) 0.5)
    (= (tx-cost n5 n3) 1.0)
    (= (rx-cost n5 n3) 0.5)

    (= (tx-cost n4 n5) 1.0)
    (= (rx-cost n4 n5) 0.5)
    (= (tx-cost n5 n4) 1.0)
    (= (rx-cost n5 n4) 0.5)

    ;; Região 1 – l3
    (= (tx-cost n5 n6) 1.0)
    (= (rx-cost n5 n6) 0.5)
    (= (tx-cost n6 n5) 1.0)
    (= (rx-cost n6 n5) 0.5)

    ;; Região 1 – l4
    (= (tx-cost n6 n7) 1.0)
    (= (rx-cost n6 n7) 0.5)
    (= (tx-cost n7 n6) 1.0)
    (= (rx-cost n7 n6) 0.5)

    ;; Região 2 – l5
    (= (tx-cost n8 n9) 1.0)
    (= (rx-cost n8 n9) 0.5)
    (= (tx-cost n9 n8) 1.0)
    (= (rx-cost n9 n8) 0.5)

    (= (tx-cost n8 n10) 1.0)
    (= (rx-cost n8 n10) 0.5)
    (= (tx-cost n10 n8) 1.0)
    (= (rx-cost n10 n8) 0.5)

    (= (tx-cost n9 n10) 1.0)
    (= (rx-cost n9 n10) 0.5)
    (= (tx-cost n10 n9) 1.0)
    (= (rx-cost n10 n9) 0.5)

    ;; Região 2 – l6
    (= (tx-cost n10 n11) 1.0)
    (= (rx-cost n10 n11) 0.5)
    (= (tx-cost n11 n10) 1.0)
    (= (rx-cost n11 n10) 0.5)

    ;; Região 2 – l7
    (= (tx-cost n11 n12) 1.0)
    (= (rx-cost n11 n12) 0.5)
    (= (tx-cost n12 n11) 1.0)
    (= (rx-cost n12 n11) 0.5)

    (= (tx-cost n11 n13) 1.0)
    (= (rx-cost n11 n13) 0.5)
    (= (tx-cost n13 n11) 1.0)
    (= (rx-cost n13 n11) 0.5)

    (= (tx-cost n12 n13) 1.0)
    (= (rx-cost n12 n13) 0.5)
    (= (tx-cost n13 n12) 1.0)
    (= (rx-cost n13 n12) 0.5)

    ;; Região 2 – l8
    (= (tx-cost n13 n14) 1.0)
    (= (rx-cost n13 n14) 0.5)
    (= (tx-cost n14 n13) 1.0)
    (= (rx-cost n14 n13) 0.5)

    ;; ------------------------------------------------
    ;; Custos de transmissão para o sink
    ;; (simples: todos 1.0)
    ;; ------------------------------------------------
    (= (tx-cost-sink n1) 1.0)
    (= (tx-cost-sink n2) 1.0)
    (= (tx-cost-sink n3) 1.0)
    (= (tx-cost-sink n4) 1.0)
    (= (tx-cost-sink n5) 1.0)
    (= (tx-cost-sink n6) 1.0)
    (= (tx-cost-sink n7) 1.0)

    (= (tx-cost-sink n8) 1.0)
    (= (tx-cost-sink n9) 1.0)
    (= (tx-cost-sink n10) 1.0)
    (= (tx-cost-sink n11) 1.0)
    (= (tx-cost-sink n12) 1.0)
    (= (tx-cost-sink n13) 1.0)
    (= (tx-cost-sink n14) 1.0)

    ;; ------------------------------------------------
    ;; Energia e buffer do sink
    ;; ------------------------------------------------
    (= (sink-energy) 100.0)   ;; energia total para se mover e operar
    (= (sink-capacity) 40)    ;; limite de dados que o sink pode armazenar
    (= (sink-collected) 0)    ;; nada coletado inicialmente
  )

  ;; ----------------------------------------------------
  ;; Objetivo: coletar pelo menos 21 unidades de dados
  ;; ----------------------------------------------------
  (:goal
    (>= (sink-collected) 21)
  )

  ;; ----------------------------------------------------
  ;; Métrica: minimizar tempo total de planejamento
  ;; ----------------------------------------------------
  (:metric minimize (total-time))
)
