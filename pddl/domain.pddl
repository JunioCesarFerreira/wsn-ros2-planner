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
    (reachable ?i - sensor ?l - location)
    (link ?i - sensor ?j - sensor)
    (broadcast-done ?l - location)
  )

  ;; ------------------------------------
  ;; Fluentes numéricos
  ;; ------------------------------------
  (:functions
    (energy ?i - sensor) ; energia do sensor i
    (buffer ?i - sensor) ; buffer do sensor i
    (buffer-capacity) ; capacidade de buffer dos sensores 
    (movement-cost ?l1 ?l2 - location) ; custo de movimento entre localidades
    (sink-energy) ; energia do sink
    (sink-collected) ; quantidade de dados coletados
    (sink-capacity) ; capacidade do buffer do sink
    (tx-cost ?i - sensor ?j - sensor)
    (rx-cost ?i - sensor ?j - sensor)
    (tx-cost-sink ?i - sensor)
  )

  (:durative-action move_sink
    :parameters (?from ?to - location)
    :duration (= ?duration 1)
    :condition (and
      (at start (at-sink ?from))
      (at start (adjacent ?from ?to))
      (at start (>= (movement-cost ?from ?to) (sink-energy)))
    )
    :effect (and
      (at start (not (at-sink ?from)))
      (at end   (at-sink ?to))
      (at end (decrease (sink-energy) (movement-cost ?from ?to)))
    )
  )

  (:durative-action broadcast_sink
    :parameters (?l - location)
    :duration (= ?duration 1)
    :condition (and
      (at start (at-sink ?l))
      (over all (at-sink ?l))
      (at start (not (broadcast-done ?l)))
    )
    :effect (and
      (at end (broadcast-done ?l))
    )
  )

  (:durative-action send_sensor_sensor
    :parameters (?i ?j - sensor ?l - location)
    :duration (= ?duration 1)
    :condition (and
      (at start (at-sink ?l))
      (at start (link ?i ?j))
      (at start (broadcast-done ?l))

      ;; precisa ter dado e ocupação no buffer de i
      (at start (>= (buffer ?i) 1))

      ;; garantir espaço para receber +1 em j
      (at start (>= (buffer-capacity) (+ (buffer ?j) 1)))

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

  (:durative-action send_sensor_sink
    :parameters (?i - sensor ?l - location)
    :duration (= ?duration 1)
    :condition (and
      (at start (at-sink ?l))
      (at start (reachable ?i ?l))
      (at start (broadcast-done ?l))

      ;; precisa ter dado no buffer
      (at start (>= (buffer ?i) 1))

      ;; energia suficiente para TX até o sink
      (at start (>= (energy ?i) (tx-cost-sink ?i)))
    )
    :effect (and
      (at end (decrease (buffer ?i) 1))
      (at end (increase (sink-collected) 1))
      (at end (decrease (energy ?i) (tx-cost-sink ?i)))
    )
  )
)