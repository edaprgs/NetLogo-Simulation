globals [
  selected-style
  selected-activity
]

turtles-own [
  learning-style
  initial-knowledge
  learning-pace
  cumulative-knowledge-tailored
  cumulative-knowledge-not-tailored
]

to setup
  clear-all

  set selected-style learning-style-chooser
  set selected-activity learning-activities-chooser

  create-turtles num-students [
    set shape "person student"
    set size 2
    set learning-style selected-style
    set initial-knowledge random 100
    set learning-pace one-of ["slow" "fast"]
    set label initial-knowledge
    set color get-color-for-style learning-style ; assign turtle color for each learning style
    setxy random-xcor random-ycor
  ]

  create-turtles learning-activities [
    set shape get-activity-shape selected-activity
    set color white
    setxy random-xcor random-ycor
  ]
  reset-ticks
end

to go
  ask turtles with [shape = "person student"] [
    move
    check-collisions
  ]
  tick
end

to move
  fd 1
  ;wait 0.05
end

to check-collisions ; adaptive learning environment
  let collided-turtle one-of other turtles-here
  if collided-turtle != nobody [
    let learning-style-of-collided-turtle [learning-style] of collided-turtle
    let shape-of-collided-turtle [shape] of collided-turtle

    ifelse learning-style = "visual" and shape-of-collided-turtle = "house" [
      gain-knowledge 2 "tailored"
    ]
    [ ifelse learning-style = "auditory" and shape-of-collided-turtle = "music notes 1" [
        gain-knowledge 2 "tailored"
      ]
      [ ifelse learning-style = "kinesthetic" and shape-of-collided-turtle = "ball baseball" [
          gain-knowledge 2 "tailored"
        ]
        [ ifelse learning-style = "reading-writing" and shape-of-collided-turtle = "book" [
            gain-knowledge 2 "tailored"
          ]
          [
            gain-knowledge 1 "not-tailored"
          ]
        ]
      ]
    ]
  ]
end

to gain-knowledge [pace-multiplier matching-scenario]
  print (word "pace-multiplier: " pace-multiplier)
  print (word "learning-pace: " learning-pace)
  
  let gained-knowledge pace-multiplier * (ifelse-value (learning-pace = "slow") [1] [2])
  set initial-knowledge initial-knowledge + gained-knowledge ; adjust knowledge gain based on learning pace
  
  ifelse matching-scenario = "tailored" [
    set cumulative-knowledge-tailored cumulative-knowledge-tailored + gained-knowledge * 2
  ] [
    set cumulative-knowledge-not-tailored cumulative-knowledge-not-tailored + gained-knowledge
  ]
  
  set label initial-knowledge
end

to-report get-color-for-style [style]
  ifelse style = "all" [
    report one-of [red blue yellow pink]
  ] [
    if style = "visual" [report red]
    if style = "auditory" [report blue]
    if style = "kinesthetic" [report yellow]
    if style = "reading-writing" [report pink]
  ]
  report white ; Default color if no match found
end

to-report get-activity-shape [activity]
  ifelse activity = "all" [
    let activity-list ["house" "music notes 1" "ball baseball" "book"]
    report one-of activity-list
  ] [
    if activity = "house" [report "house"]
    if activity = "music notes 1" [report "music notes 1"]
    if activity = "ball baseball" [report "ball baseball"]
    if activity = "book" [report "book"]
  ]
  report "unknown"
end
