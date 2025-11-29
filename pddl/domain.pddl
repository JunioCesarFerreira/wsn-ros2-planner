(define (domain wsn-sink-mobility-buffering-temporal)
  (:requirements
    :strips
    :typing
    :negative-preconditions
    :fluents
    :numeric-fluents
    :durative-actions
    :equality
  )

  (:types
    sensor
    location
  )

  ;; ------------------------------------
  ;; Predicados (qualitativos)
  ;; ------------------------------------
  (:predicates
    (at-sink ?l - location)
    (adjacent ?l1 ?l2 - location)
    (reachable ?i - sensor ?l - location)   ;; sensor i consegue "ver" o sink em l
    (link ?i - sensor ?j - sensor)          ;; enlace lógico entre sensores
    (broadcast-done ?l - location)          ;; broadcast concluído em l
  )

  ;; ------------------------------------
  ;; Fluentes numéricos
  ;; ------------------------------------
  (:functions
    (energy ?i - sensor)        ; energia do sensor i
    (buffer ?i - sensor)        ; dados no buffer do sensor i
    (buffer-capacity)           ; capacidade de buffer dos sensores (constante global)
    (movement-cost ?l1 ?l2 - location) ; custo de movimento entre localidades
    (sink-energy)               ; energia do sink
    (sink-collected)            ; quantidade de dados armazenados no sink
    (sink-capacity)             ; capacidade do buffer do sink (constante global)
    (tx-cost ?i - sensor ?j - sensor)
    (rx-cost ?i - sensor ?j - sensor)
    (tx-cost-sink ?i - sensor)
  )

  ;; ------------------------------------
  ;; DURATIVE-ACTION: mover o sink
  ;; ------------------------------------
  (:durative-action move_sink
    :parameters (?from ?to - location)
    :duration (= ?duration 1)
    :condition (and
      (at start (at-sink ?from))
      (at start (adjacent ?from ?to))
      ;; energia do sink suficiente para pagar o movimento
      (at start (>= (sink-energy) (movement-cost ?from ?to)))
    )
    :effect (and
      ;; o sink deixa o local de origem imediatamente
      (at start (not (at-sink ?from)))

      ;; ao final, o sink chega ao destino
      (at end   (at-sink ?to))

      ;; desconta energia pelo movimento
      (at end (decrease (sink-energy) (movement-cost ?from ?to)))

      ;; ao sair de um local, o "broadcast" daquele local deixa de valer
      (at end (not (broadcast-done ?from)))

      ;; garantir que no novo local o broadcast comece "desligado"
      (at end (not (broadcast-done ?to)))
    )
  )

  ;; ------------------------------------
  ;; DURATIVE-ACTION: broadcast do sink em um local
  ;; ------------------------------------
  (:durative-action broadcast_sink
    :parameters (?l - location)
    :duration (= ?duration 1)
    :condition (and
      ;; o sink precisa estar em l no início
      (at start (at-sink ?l))
      ;; e permanecer em l durante todo o broadcast
      (over all (at-sink ?l))
      ;; não repetir broadcast se já foi feito nesse local
      (at start (not (broadcast-done ?l)))
    )
    :effect (and
      ;; ao final, marcamos que o broadcast foi concluído em l
      (at end (broadcast-done ?l))
    )
  )

  ;; ------------------------------------
  ;; DURATIVE-ACTION: enviar 1 unidade de dado i -> j
  ;; (roteamento sensor-sensor)
  ;; ------------------------------------
  (:durative-action send_sensor_sensor
    :parameters (?i ?j - sensor ?l - location)
    :duration (= ?duration 1)
    :condition (and
      ;; o sink está em l e já fez broadcast em l
      (at start (at-sink ?l))
      (over all (at-sink ?l))
      (at start (broadcast-done ?l))

      ;; enlace lógico entre i e j
      (at start (link ?i ?j))

      ;; precisa ter dado no buffer de i
      (at start (>= (buffer ?i) 1))

      ;; garantir espaço no buffer de j (sem usar soma explícita)
      (at start (< (buffer ?j) (buffer-capacity)))

      ;; energia suficiente para TX e RX
      (at start (>= (energy ?i) (tx-cost ?i ?j)))
      (at start (>= (energy ?j) (rx-cost ?i ?j)))
    )
    :effect (and
      (at end (decrease (buffer ?i) 1))
      (at end (increase (buffer ?j) 1))
      (at end (decrease (energy ?i) (tx-cost ?i ?j)))
      (at end (decrease (energy ?j) (rx-cost ?i ?j)))
    )
  )

  ;; ------------------------------------
  ;; DURATIVE-ACTION: entrega 1 unidade de dado ao sink
  ;; ------------------------------------
  (:durative-action send_sensor_sink
    :parameters (?i - sensor ?l - location)
    :duration (= ?duration 1)
    :condition (and
      ;; sink presente em l durante todo o envio
      (at start (at-sink ?l))
      (over all (at-sink ?l))

      ;; sensor i consegue alcançar o sink em l
      (at start (reachable ?i ?l))

      ;; broadcast já foi feito em l
      (at start (broadcast-done ?l))

      ;; precisa ter dado no buffer do sensor
      (at start (>= (buffer ?i) 1))

      ;; energia suficiente para TX até o sink
      (at start (>= (energy ?i) (tx-cost-sink ?i)))

      ;; capacidade de buffer do sink: ainda há espaço
      (at start (< (sink-collected) (sink-capacity)))
    )
    :effect (and
      (at end (decrease (buffer ?i) 1))
      (at end (increase (sink-collected) 1))
      (at end (decrease (energy ?i) (tx-cost-sink ?i)))
    )
  )
)
