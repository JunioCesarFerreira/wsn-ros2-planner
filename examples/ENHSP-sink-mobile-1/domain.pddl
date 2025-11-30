(define (domain wsn-sink-mobility-buffering-discrete)
  (:requirements
    :strips
    :typing
    :negative-preconditions
    :fluents
    :numeric-fluents
    :equality
  )

  (:types
    sensor
    location
  )

  (:predicates
    (at-sink ?l - location)
    (is-base ?l - location)
    (adjacent ?l1 ?l2 - location)
    (reachable ?l - location ?i - sensor)
    (link ?i - sensor ?j - sensor)
    (broadcast-done ?l - location)
  )

  (:functions
    (time)                     ;; nosso "relógio global"

    (energy ?i - sensor)
    (buffer ?i - sensor)
    (buffer-capacity)

    (movement-energy-cost ?l1 ?l2 - location)
    (movement-time-cost   ?l1 ?l2 - location)

    (sink-energy)
    (sink-max-energy)
    (sink-collected)
    (sink-delivered)
    (sink-capacity)

    (tx-cost ?i - sensor ?j - sensor)
    (rx-cost ?i - sensor ?j - sensor)
    (tx-cost-sink ?l - location ?i - sensor)
    (rx-cost-sink ?l - location ?i - sensor)
  )

  ;; -----------------------------
  ;; Movimento do sink
  ;; -----------------------------
  (:action move_sink
    :parameters (?from ?to - location)
    :precondition (and
      (at-sink ?from)
      (adjacent ?from ?to)
      (>= (sink-energy) (movement-energy-cost ?from ?to))
    )
    :effect (and
      (not (at-sink ?from))
      (at-sink ?to)
      (decrease (sink-energy) (movement-energy-cost ?from ?to))
      (increase (time) (movement-time-cost ?from ?to))
      (not (broadcast-done ?from))
      (not (broadcast-done ?to))
    )
  )

  ;; Se quiser diferenciar movimento "para base", pode ter uma variante,
  ;; mas em geral move_sink já é suficiente.

  ;; -----------------------------
  ;; Broadcast do sink
  ;; -----------------------------
  (:action broadcast_sink
    :parameters (?l - location)
    :precondition (and
      (at-sink ?l)
      (not (broadcast-done ?l))
    )
    :effect (and
      (broadcast-done ?l)
      (increase (time) 1)
    )
  )

  ;; -----------------------------
  ;; Envio sensor -> sensor
  ;; -----------------------------
  (:action send_sensor_sensor
    :parameters (?i ?j - sensor ?l - location)
    :precondition (and
      (at-sink ?l)
      (broadcast-done ?l)
      (link ?i ?j)
      (>= (buffer ?i) 1)
      (>= (buffer-capacity) (buffer ?j))
      (>= (energy ?i) (tx-cost ?i ?j))
      (>= (energy ?j) (rx-cost ?i ?j))
    )
    :effect (and
      (decrease (buffer ?i) 1)
      (increase (buffer ?j) 1)
      (decrease (energy ?i) (tx-cost ?i ?j))
      (decrease (energy ?j) (rx-cost ?i ?j))
      (increase (time) 1)
    )
  )

  ;; -----------------------------
  ;; Envio sensor -> sink
  ;; -----------------------------
  (:action send_sensor_sink
    :parameters (?i - sensor ?l - location)
    :precondition (and
      (at-sink ?l)
      (reachable ?l ?i)
      (broadcast-done ?l)
      (>= (buffer ?i) 1)
      (>= (energy ?i) (tx-cost-sink ?l ?i))
      (>= (sink-capacity) (sink-collected))
    )
    :effect (and
      (decrease (buffer ?i) 1)
      (increase (sink-collected) 1)
      (decrease (energy ?i) (tx-cost-sink ?l ?i))
      (decrease (sink-energy) (rx-cost-sink ?l ?i))
      (increase (time) 1)
    )
  )

  ;; -----------------------------
  ;; Offload na base
  ;; -----------------------------
  (:action offload
    :parameters (?b - location)
    :precondition (and
      (at-sink ?b)
      (is-base ?b)
      (> (sink-collected) 0)
    )
    :effect (and
      (increase (sink-delivered) 1)
      (decrease (sink-collected) 1)
      (increase (time) 1)
    )
  )

  ;; -----------------------------
  ;; Recarga na base
  ;; -----------------------------
  (:action recharge
    :parameters (?b - location)
    :precondition (and
      (at-sink ?b)
      (is-base ?b)
      (< (sink-energy) (sink-max-energy))
    )
    :effect (and
      (increase (sink-energy) 1)
      (increase (time) 1)
    )
  )
)
