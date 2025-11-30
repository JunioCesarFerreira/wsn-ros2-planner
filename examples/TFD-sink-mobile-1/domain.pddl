(define (domain wsn-sink-mobility-buffering-temporal)
  (:requirements
    :strips
    :typing
    :negative-preconditions
    :fluents
    :durative-actions
    :equality
  )

  ;; ------------------------------------
  ;; Tipos
  ;; ------------------------------------
  (:types
    sensor
    location
  )

  ;; ------------------------------------
  ;; Predicados
  ;; ------------------------------------
  (:predicates
    (at-sink ?l - location)      ;; posição atual do sink
    (is-base ?l - location)      ;; a base é um location marcado com is-base
    (adjacent ?l1 ?l2 - location)
    (reachable ?l - location ?i - sensor)
    (link ?i - sensor ?j - sensor)
    (broadcast-done ?l - location)
  )

  ;; ------------------------------------
  ;; Fluentes numéricos
  ;; ------------------------------------
  (:functions
    (energy ?i - sensor)
    (buffer ?i - sensor)
    (buffer-capacity)   ;; capacidade comum a todos os sensores

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

  ;; ------------------------------------
  ;; Movimento do sink (genérico)
  ;; ------------------------------------
  (:durative-action move_sink
    :parameters (?from ?to - location)
    :duration (= ?duration (movement-time-cost ?from ?to))
    :condition (and
      (at start (at-sink ?from))
      (at start (adjacent ?from ?to))
      (at start (>= (sink-energy) (movement-energy-cost ?from ?to)))
    )
    :effect (and
      (at start (not (at-sink ?from)))
      (at end   (at-sink ?to))
      (at end   (decrease (sink-energy) (movement-energy-cost ?from ?to)))
      (at end (not (broadcast-done ?from)))
      (at end (not (broadcast-done ?to)))
    )
  )

  ;; ------------------------------------
  ;; Movimento do sink especificamente até a base
  ;; (poderia ser só uma instância de move_sink com is-base no problema,
  ;; mas deixei como ação separada se quiser diferenciar).
  ;; ------------------------------------
  (:durative-action sink_go_to_base
    :parameters (?from ?to - location)
    :duration (= ?duration (movement-time-cost ?from ?to))
    :condition (and
      (at start (is-base ?to))
      (at start (at-sink ?from))
      (at start (adjacent ?from ?to))
      (at start (>= (sink-energy) (movement-energy-cost ?from ?to)))
    )
    :effect (and
      (at start (not (at-sink ?from)))
      (at end   (at-sink ?to))
      (at end   (decrease (sink-energy) (movement-energy-cost ?from ?to)))
      (at end   (not (broadcast-done ?from)))
      (at end   (not (broadcast-done ?to)))
    )
  )

  ;; ------------------------------------
  ;; Broadcast do sink em um location
  ;; ------------------------------------
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

  ;; ------------------------------------
  ;; Envio sensor-sensor
  ;; ------------------------------------
  (:durative-action send_sensor_sensor
    :parameters (?i ?j - sensor ?l - location)
    :duration (= ?duration 1)
    :condition (and
      (at start (at-sink ?l))
      (over all (at-sink ?l))
      (at start (broadcast-done ?l))
      (at start (link ?i ?j))
      (at start (>= (buffer ?i) 1))
      (at start (>= (buffer-capacity) (buffer ?j)))
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
  ;; Envio sensor -> sink
  ;; ------------------------------------
  (:durative-action send_sensor_sink
    :parameters (?i - sensor ?l - location)
    :duration (= ?duration 1)
    :condition (and
      (at start (at-sink ?l))
      (over all (at-sink ?l))
      (at start (reachable ?l ?i))
      (at start (broadcast-done ?l))
      (at start (>= (buffer ?i) 1))
      (at start (>= (energy ?i) (tx-cost-sink ?l ?i)))
      (at start (>= (sink-capacity) (sink-collected)))
    )
    :effect (and
      (at end (decrease (buffer ?i) 1))
      (at end (increase (sink-collected) 1))
      (at end (decrease (energy ?i) (tx-cost-sink ?l ?i)))
      (at end (decrease (sink-energy) (rx-cost-sink ?l ?i)))
    )
  )

  ;; ------------------------------------
  ;; Offload na base
  ;; ------------------------------------
  (:durative-action offload
    :parameters (?b - location)
    :duration (= ?duration 1)
    :condition (and
      (at start (at-sink ?b))
      (at start (is-base ?b))
      (at start (>= (sink-collected) 1))
    )
    :effect (and
      (at end (increase (sink-delivered) 1))
      (at end (decrease (sink-collected) 1))
    )
  )

  ;; ------------------------------------
  ;; Recarga na base
  ;; ------------------------------------
  (:durative-action recharge
    :parameters (?b - location)
    :duration (= ?duration 1)
    :condition (and
      (at start (at-sink ?b))
      (at start (is-base ?b))
      (at start (>= (sink-max-energy) (sink-energy)))
    )
    :effect (and
      (at end (increase (sink-energy) 1))
    )
  )
)
