globals [
  initial-susceptible
  transmission-rate
  recovery-rate ; number of days required to recover from the infection
  reproduction-rate ; ratio of effective contact rate to the recovery rate
  contact-rate
  reduced-reproduction-rate; reduced reproduction rate
  reduced-contact-rate;
]

turtles-own [
  state  ; Susceptible (S), Infected (I), Recovered (R)
]

to setup
  clear-all
  set initial-susceptible population-size
  set transmission-rate 0.4
  set contact-rate 6 / 15
  set recovery-rate 1 / 15
  set reduced-contact-rate contact-rate
  set reproduction-rate reduced-contact-rate / recovery-rate
  set reduced-reproduction-rate reproduction-rate
  setup-turtles
  add-a-carrier
  if lockdown-effect [compute-new-reproduction-rate]
  reset-ticks
end

to setup-turtles
  create-turtles population-size [
    set state "S"
    set shape "person"
    set size 1
    set color 65
    setxy random-xcor random-ycor
  ]
end

to go
  if not any? turtles with [state = "I"] [
    stop
  ]
  move
  ask turtles [
    if state = "S" [
      check-infection
    ]
    if state = "I" [
      check-recovery
    ]
  ]
  tick
end

to move
  ask turtles [
    right random 150
    left random 150
    forward 1
  ]
end

to add-a-carrier
  ask n-of initial-infections turtles [
    set state "I" ; infect a certain number of turtles at the beginning
    set color 15
  ]
end

to check-infection
  let infected-neighbors count turtles with [ state = "I" ]
  let probability-of-infection (transmission-rate * infected-neighbors * reduced-contact-rate) / population-size
  if lockdown-effect [
    set probability-of-infection (transmission-rate * infected-neighbors * reduced-contact-rate) / population-size
  ]
  if probability-of-infection > 1 [
    set probability-of-infection 1
  ]
  ifelse random-float 1 < probability-of-infection [
    set state "I"
    set color 15 ; susceptible becomes infected
  ] [
    set color 65 ; doesn't get infected
  ]
end


to check-recovery
  ifelse random-float 1 < recovery-rate [
    set state "R"
    set color 9.9 ; recovered
  ] []
end

to compute-new-reproduction-rate
  let reduction-factor 2.96125
  set reduced-reproduction-rate reproduction-rate / reduction-factor
  set reduced-contact-rate contact-rate / reduction-factor
end
