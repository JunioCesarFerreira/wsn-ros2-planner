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
    (visible ?i - sensor ?l - location)
    (link ?i - sensor ?j - sensor ?l - location)
  )

  ;; ------------------------------------
  ;; Fluentes numéricos
  ;; ------------------------------------
  (:functions
    (energy ?i - sensor)
    (buffer ?i - sensor)
    (buffer-cap ?i - sensor)

    (collected)

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
    )
    :effect (and
      (at start (not (at-sink ?from)))
      (at end   (at-sink ?to))
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
      (at start (at-sink ?l))
      (at start (link ?i ?j ?l))

      ;; precisa ter dado e ocupação no buffer de i
      (at start (>= (buffer ?i) 1))

      ;; garantir espaço para receber +1 em j
      (at start (>= (buffer-cap ?j) (+ (buffer ?j) 1)))

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
      (at start (at-sink ?l))
      (at start (visible ?i ?l))

      ;; precisa ter dado no buffer
      (at start (>= (buffer ?i) 1))

      ;; energia suficiente para TX até o sink
      (at start (>= (energy ?i) (tx-cost-sink ?i)))
    )
    :effect (and
      (at end (decrease (buffer ?i) 1))
      (at end (increase (collected) 1))
      (at end (decrease (energy ?i) (tx-cost-sink ?i)))
    )
  )
)