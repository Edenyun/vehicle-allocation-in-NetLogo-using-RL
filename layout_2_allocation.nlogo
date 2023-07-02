globals[
  entran-x  ;; cor x of entrance
  entran-y  ;; cor y of entrance
  x1 x2 x3 x4 x5 x6 x7 x8
  y1 y2 y3 y4 y5 y6 y7 y8
  ;; corner-point  ;; cars can only turn left at these point
  t-point-1 t-point-2 t-point-3 t-point-4 t-point-5 t-point-6 t-point-7 t-point-8;; cars can go straight or make a turn
  v-max
  l-headway
  acceleration
  deceleration
  l-vehicle
  strategy
  total-travel-time
  red_values

]
turtles-own
[
  speed   ;; the current speed of the car
  speed-limit
  park-possibility    ;; the possiblity that the driver will choose the nearest available park space
  park?  ;; true if the car is in the process of parking
  parked?    ;; true if the car is parked
  possibility-turn  ;; the possibility that the driver change directions at the cross
  congestions?
  waiting-time
  change-lane?
  route

]
patches-own
[
  category
  availability
  wait?
  cate-route-1
  cate-route-2
  cate-route
  order
]
to set-globals
  set x1 2 set x2 3 set x3 10 set x4 11 set x5 14 set x6 16 set x7 18 set x8 19
  set y1 11 set y2 10 set y3 7 set y4 6 set y5 4 set y6 3 set y7 2 set y8 1
  set entran-x (x8 + 1)
  set entran-y y6
  ;;set corner-point (patch-set patch x1 y4 patch x3 y4 patch x1 y1);;exclude the entrance
  set total-travel-time 0
  set t-point-1
  (patch-set patch x1 y2 patch x1 y4 patch x1 y7
    patch x3 y2 patch x3 y4
    patch x5 y7
    patch x6 y4
    patch x7 y2 patch x7 y4

  )

  set t-point-2
  (patch-set patch x2 y2 patch x2 y4
    patch x4 y2 patch x4 y4
    patch x7 y7 patch x7 y8 patch x4 y7

  )
  set t-point-3
  (patch-set
   patches with [pxcor = x2 and (pycor = y2 - 1  or pycor = y2 - 2 or pycor = y5 + 1 or pycor = y5)]
   patches with [pxcor = x4 and (pycor = y2 - 1  or pycor = y2 - 2 or pycor = y5 + 1 or pycor = y5)]
   patch (x3 - 3) y8

    patches with [pxcor = x8 and (pycor <= y2 and pycor >= y8 and pycor != y3 and pycor != y6)])

  set t-point-4 (patch-set
    patches with [(pxcor >= x2 and pxcor <= x8 and pxcor != x3 and pxcor != x7) and pycor = y1]
    patches with [(pxcor >= x2 + 1 and pxcor <= x6 + 1 and pxcor != x3 and pxcor != x4) and pycor = y3]
    patches with [(pxcor >= x6 - 1 and pxcor <= x7 - 1) and pycor = y5]
    patches with [(pxcor >= x2 + 1 and pxcor <= x6 and pxcor != x3 and pxcor != x4) and pycor = y6]
    patch x7 y6
  )

  set t-point-5 (patch-set
    patches with [pxcor = x1 and (pycor <= y1 and pycor >= y6 and pycor != y2 and pycor != y4)]
    patches with [(pxcor = x3 or pxcor = x7) and (pycor <= y2 - 1 and pycor >= y5 and pycor != y3 and pycor != y4)]
     patch x5 y5
  )
  set t-point-6 (patch-set
    patches with [(pxcor >= x2 + 1 and pxcor <= x7 - 1 and pxcor != x3 and pxcor != x4) and pycor = y2]
    patches with [(pxcor >= x2 + 1 and pxcor <= x7 - 1 and pxcor != x3 and pxcor != x4 and pxcor != x6) and pycor = y4]

    patches with [(pxcor >= x2 and pxcor <= x6 + 1 and pxcor != x5 and pxcor != x4) and pycor = y7]
    patches with [(pxcor >= x1 and pxcor <= x2 + 3) or (pxcor >= x5 and pxcor <= x6 + 1) and pycor = y8]
    patches with [(pxcor = x6 and pycor = y4 - 1) or (pxcor = x6 + 1 and pycor = y4 - 1) ]
  )
  set t-point-7 (patch-set
   patch x2 y3 patch x2 y6 patch x4 y3 patch (x6 + 1) y6 patch x8 y6 patch x8 y3 patch x4 y6
  )
  set t-point-8 (
    patch-set patch x3 y1 patch x3 y3 patch x7 y1 patch x7 y3 patch x3 y6
  )
  set v-max v-max_input / space-size * t-step
  set acceleration acceleration_input / space-size * t-step
  set deceleration deceleration_input / space-size * t-step
  set l-vehicle l-vehicle_input / space-size
  set strategy 1
  set red_values []

end
to set-patches
  ask t-point-1 [set category 1]
  ask t-point-2 [set category 2]
  ask t-point-3 [set category 3]
  ask t-point-4 [set category 4]
  ask t-point-5 [set category 5]
  ask t-point-6 [set category 6]
  ask t-point-7 [set category 7]
  ask t-point-8 [set category 8]

end

to set-route
  if strategy = 0
  [if member? who [plabel] of patches with [cate-route = 1]
      [set route 1]
      if member? who [plabel] of patches with [cate-route = 2]
      [set route 2]
      if member? who [plabel] of patches with [cate-route = 3]
      [set route 3]
      if member? who [plabel] of patches with [cate-route = 4]
      [set route 4]
      if member? who [plabel] of patches with [cate-route = 5]
      [set route 5]
      if member? who [plabel] of patches with [cate-route = 6]
      [set route 6]
      if member? who [plabel] of patches with [cate-route = 7]
      [set route 7]
      if member? who [plabel] of patches with [cate-route = 8]
      [set route 8]
      if member? who [plabel] of patches with [cate-route = 9]
      [set route 9]
  ]
end
to draw-parkinglot
  ask patches
  [
    set pcolor black
    set plabel 0
  ]
  ask patches with[pxcor >= x1 and pxcor <= x8 and pycor <= y1 + 1 and pycor >= y8]
  [set pcolor grey]
  ask patches with [pxcor >= x1 - 1 and pxcor <= x8 and pycor <= y1 and pycor >= y7]
  [set pcolor grey]

  ask patches with[category <= 8 and category >= 1]
  [set pcolor cyan]
  ask patch entran-x entran-y [set pcolor green]
  ask patches with[pcolor = grey]
  [
    set availability 1
    set plabel 1
  ]
end
to setup
  clear-all
  reset-ticks
  set-globals

  set-patches
  draw-parkinglot
  set-default-shape turtles "car"
end


to go
  generate-car
  ask turtles[
    drive
    set-route
  ]

  calculate-time
  if all? turtles [parked? = true]
  [
    ask patches [set plabel ""]
    stop]
  tick

end




to generate-car
  ;;when there are still available spots and no car occupy the entrance, and keep distance
  ;; generate a car at the entrance
  if ((count turtles < car-total-number ) and
    (not any? turtles-on patch entran-x entran-y)
  and((not any? turtles-on patch (entran-x - 1) entran-y)))
  [
    create-turtles 1 [
    set color red
    setxy (entran-x + v-max) entran-y
    set size l-vehicle
    set heading 270 ;;move to left
    set speed v-max
    set park-possibility 0.5
    set possibility-turn 0.3
    set park? false
    set parked? false
    set congestions? false
    set waiting-time parking-time / t-step
    set label who
    set change-lane? false

    if strategy = 1 or strategy = 2 or strategy = 3 or strategy = 4 or strategy = 0
    [
      if member? who [plabel] of patches with [cate-route = 1]
      [set route 1]
      if member? who [plabel] of patches with [cate-route = 2]
      [set route 2]
      if member? who [plabel] of patches with [cate-route = 3]
      [set route 3]
      if member? who [plabel] of patches with [cate-route = 4]
      [set route 4]
      if member? who [plabel] of patches with [cate-route = 5]
      [set route 5]
      if member? who [plabel] of patches with [cate-route = 6]
      [set route 6]
      if member? who [plabel] of patches with [cate-route = 7]
      [set route 7]
      if member? who [plabel] of patches with [cate-route = 8]
      [set route 8]
      if member? who [plabel] of patches with [cate-route = 9]
      [set route 9]
    ]
      if who = 0
      [if strategy = 1
        [set route 1]
        if strategy = 2
        [set route 7]
        if strategy = 3
        [set route 1]
        if strategy = 4
        [set route 7]
        if strategy = 0
        [set route 7]

      ]

    ]

  ]
end


to drive ;;already ask turtles
  ready-to-park? ;; see whether the car is willing to park

  ifelse park?
  ;; if the car is willing to park
  [
;;if it has to park to the across parking space, move it first
    ifelse change-lane? = true
    [
      set speed 0
      car-change-lane
      set color black
    ]
    [
      if parked? = false and (waiting-time <= 0)
      [
        if color = black
        [set color blue]

        park-process

      ] ;; if it is not in the parking  space, then move it into it
    set waiting-time (waiting-time - 1)
    set speed 0

    ]

  ]
  ;;normal drive
  [
  choose-direction
  ;; if there are no blocking car, speed up
  ;;speed-up-car ; we tentatively speed up, but might have to slow down
  set congestions? false
  ;; let blocking-cars other turtles in-cone (1 + speed) 90 with [ d-distance <= l-headway ]
  let blocking-cars other turtles in-cone ((l-headway + size) * 10 / patch-size) 90 ;;with [ d-distance <= l-headway ]
  let blocking-car min-one-of blocking-cars [ distance myself ]
  ifelse blocking-car != nobody
    [
    ; match the speed of the car ahead of you and then slow
    ; down so you are driving a bit slower than that car.
    ;; set speed [ speed ] of blocking-car
    slow-down-car
    set congestions? true
    ]
    [
    ;; set speed v-max
    speed-up-car
    set congestions? false

    ]


;    if (([category] of (patch-ahead speed)) = 0)
;    [set speed speed / 2]
    if route = 8
    [set speed (speed - random 0.3)]

    if not any? (other turtles-on patch-ahead speed) with [parked? = false]
    [forward speed]
    set-car


  ]

end
to set-car
    ask patches with[pcolor = grey]
    [
    if (not any? turtles-on patch pxcor pycor)
    and (not any? (turtles-on patch-at 1 0)with [parked? = false])
    and (not any? (turtles-on patch-at 0 1)with [parked? = false])
    and (not any? (turtles-on patch-at -1 0)with [parked? = false])
    and (not any? (turtles-on patch-at 0 -1)with [parked? = false])
    and (not any? (turtles-on patch-at 2 0)with [parked? = false])
    and (not any? (turtles-on patch-at 0 2)with [parked? = false])
    and (not any? (turtles-on patch-at -2 0)with [parked? = false])
    and (not any? (turtles-on patch-at 0 -2)with [parked? = false])
      [
      set availability 1
      ;;set wait? 0
      ]
    ]

  ask turtles with[park? = true and parked? = false]
  [if ([availability] of patch-at-heading-and-distance 180 1 = 0)
    and ([availability] of patch-at-heading-and-distance 0 1 = 0)
    and ([availability] of patch-at-heading-and-distance 270 1 = 0)

    [
      set park? false
      set waiting-time (parking-time / t-step)
      set color red
    ]

  ]



end
to route-1
if ((category = 1) )
  [

      set heading 90
      set ycor pycor  ;; only restrain pycor

  ]
   if ((category = 2) )
  [

      set heading 90
      set ycor pycor
  ]

    if ((category = 7) )
  [
      set heading 270
      set ycor pycor ;; only restrain pxcor
  ]
   if ((category = 8) )
  [
      set heading 270
      set ycor pycor
  ]

end
to route-2
  if ((category = 1) )
  [

      set heading 90
      set ycor pycor  ;; only restrain pycor

  ]
   if ((category = 2) )
  [

      set heading 90
      set ycor pycor
  ]

    if ((category = 7) )
  [
    ifelse pxcor = x8
    [
      set heading 270
      set ycor pycor ;; only restrain pxcor
    ]
    [set heading 0
    set xcor pxcor
    ]
    ]
   if ((category = 8) )
  [
      set heading 270
      set ycor pycor
  ]

end
to route-3
  if ((category = 1) )
  [

      set heading 90
      set ycor pycor  ;; only restrain pycor

  ]
   if ((category = 2) )
  [

      set heading 90
      set ycor pycor
  ]

    if ((category = 7) )
  [
    ifelse pxcor = x4 and pycor = y6
    [
    set heading 0
    set xcor pxcor
    ]
    [
    set heading 270
    set ycor pycor ;; only restrain pxcor
    ]

  ]
   if ((category = 8) )
  [
      set heading 270
      set ycor pycor
  ]

end
to route-4
  if ((category = 1) )
  [

      set heading 90
      set ycor pycor  ;; only restrain pycor

  ]
   if ((category = 2) )
  [ ifelse pycor = y2
    [
    set heading 90
      set ycor pycor
    ]

    [
    set heading 0
    set xcor pxcor
    ]


  ]

   if ((category = 7) )
  [
    ifelse pxcor = x4
    [
    set heading 0
    set xcor pxcor
    ]
    [
    set heading 270
    set ycor pycor ;; only restrain pxcor
    ]

  ]

   if ((category = 8) )
  [
      set heading 270
      set ycor pycor
  ]

end
to route-5
  if ((category = 1) )
  [

      set heading 90
      set ycor pycor  ;; only restrain pycor

  ]
   if ((category = 2) )
  [

      set heading 90
      set ycor pycor
  ]

    if ((category = 7) )
  [
    ifelse pycor = y6
    [
    set heading 0
    set xcor pxcor
    ]
    [
    set heading 270
    set ycor pycor ;; only restrain pxcor
    ]

  ]
   if ((category = 8) )
  [
      set heading 270
      set ycor pycor
  ]

end
to route-6
  if ((category = 1) )
  [

      set heading 90
      set ycor pycor  ;; only restrain pycor

  ]
   if ((category = 2) )
  [

      set heading 90
      set ycor pycor
  ]

    if ((category = 7) )
  [
      set heading 0
      set xcor pxcor ;; only restrain pxcor
  ]
   if ((category = 8) )
  [
      set heading 270
      set ycor pycor
  ]

end
to route-7
  if ((category = 1) )
  [

      set heading 180
      set xcor pxcor  ;; only restrain pycor

  ]
   if ((category = 2) )
  [

      set heading 0
      set xcor pxcor
  ]

    if ((category = 7) )
  [
    ifelse pxcor = x2
    [
      set heading 0
      set xcor pxcor

    ]
    [
      set heading 270
      set ycor pycor ;; only restrain pxcor
    ]
  ]
   if ((category = 8) )
  [
      set heading 270
      set ycor pycor
  ]

end
to route-8
  if ((category = 1) )
  [

      set heading 90
      set xcor pxcor  ;; only restrain pycor

  ]
   if ((category = 2) )
  [

      set heading 90
      set ycor pycor
  ]

   if ((category = 7) )
  [
    ifelse pxcor = x2 and pycor = y6
    [
      set heading 0
      set xcor pxcor

    ]
    [
      set heading 270
      set ycor pycor ;; only restrain pxcor
    ]
  ]
   if ((category = 8) )
  [
      set heading 270
      set xcor pxcor
  ]

end
to route-9
  if ((category = 1) )
  [

      set heading 90
      set ycor pycor  ;; only restrain pycor

  ]
   if ((category = 2) )
  [
    ifelse pycor = y4
    [set heading 0
    set xcor pxcor
    ]
    [
      set heading 90
      set ycor pycor
    ]
  ]

    if ((category = 7) )
  [
    ifelse pxcor = x2
    [
      set heading 0
      set xcor pxcor

    ]
    [
      set heading 270
      set ycor pycor ;; only restrain pxcor
    ]
  ]
   if ((category = 8) )
  [
      set heading 270
      set ycor pycor
  ]

end
to choose-direction
  ;; let possibility-turn 0.3 ;; possibilit to make a turn
  ;;random-seed 30
  ;; if the car is at the corner, then it need to turn left
  ;; cars have some possibility for change directions
  if route = 1
  [route-1]
  if route = 2
  [route-2]
  if route = 3
  [route-3]
  if route = 4
  [route-4]
  if route = 5
  [route-5]
  if route = 6
  [route-6]
  if route = 7
  [route-7]
  if route = 8
  [route-8]
  if route = 9
  [route-9]


   if ((category = 3) )
  [

      set heading 0
      set xcor pxcor

  ]
   if ((category = 4) )
  [

      set heading 270
      set ycor pycor

  ]
  if ((category = 5) )
  [

      set heading 180
      set xcor pxcor

  ]
   if ((category = 6) )
  [

      set heading 90
      set ycor pycor

  ]

end

to speed-up-car ; turtle procedure
  set speed min (list v-max (speed + acceleration))
  ;; set speed (speed + acceleration)
  ;; if speed > speed-limit [ set speed speed-limit ]
end

to check-space-nearby
   if ([availability] of patch-at-heading-and-distance 180 1 = 1)
  [
      ;;ask (patch-at-heading-and-distance 180 1) [set wait? 1]
      if who = [plabel] of patch-at-heading-and-distance 180 1
          [set park? true]
  ]
   if ([availability] of patch-at-heading-and-distance 0 1 = 1)
  [
      ;;ask (patch-at-heading-and-distance 180 1) [set wait? 1]
      if who = [plabel] of patch-at-heading-and-distance 0 1
          [set park? true]
  ]
  if ([availability] of patch-at-heading-and-distance 270 1 = 1)
  [
      ;;ask (patch-at-heading-and-distance 180 1) [set wait? 1]
      if who = [plabel] of patch-at-heading-and-distance 270 1
          [set park? true]
  ]


end

to check-space-across
  if ([availability] of patch-at-heading-and-distance 180 2 = 1)
  [
      ;;ask (patch-at-heading-and-distance 180 1) [set wait? 1]
      if who = [plabel] of patch-at-heading-and-distance 180 2
          [set park? true
    set change-lane? true]
  ]
   if ([availability] of patch-at-heading-and-distance 0 2 = 1)
  [
      ;;ask (patch-at-heading-and-distance 180 1) [set wait? 1]
      if who = [plabel] of patch-at-heading-and-distance 0 2
          [set park? true
    set change-lane? true]
  ]
  if ([availability] of patch-at-heading-and-distance 270 2 = 1)
  [
      ;;ask (patch-at-heading-and-distance 180 1) [set wait? 1]
      if who = [plabel] of patch-at-heading-and-distance 270 2
          [set park? true
    set change-lane? true]
  ]

;  if ([category] of (patch-at-heading-and-distance 180 1) != 0)
;  and ([availability] of (patch-at-heading-and-distance 180 2) = 1)
;  and (who = [plabel] of patch-at-heading-and-distance 180 2)
;    [set park? true
;    set change-lane? true]
;
;  if ([category] of (patch-at-heading-and-distance 0 1) != 0)
;  and [availability] of (patch-at-heading-and-distance 0 2) = 1
;  and (who = [plabel] of patch-at-heading-and-distance 0 2)
;    [set park? true
;    set change-lane? true]
;
;  if ([category] of (patch-at-heading-and-distance 270 1) != 0)
;  and [availability] of (patch-at-heading-and-distance 270 2) = 1
;  and (who = [plabel] of patch-at-heading-and-distance 270 2)
;    [set park? true
;    set change-lane? true]


;   ask patch-at-heading-and-distance 180 1
;  [
;    if category != 0
;    [
;    ask patch-at-heading-and-distance 180 1
;      [
;      if (availability = 1 and wait? = 0) and (any? turtles-on patch pxcor (pycor + 2))
;        [
;
;          ask one-of turtles-on patch pxcor (pycor + 2)[
;
;           if random-float 1 < park-possibility[
;            ask patch pxcor (pycor - 2)[set wait? 1]
;            set park? true
;            set change-lane? true
;
;
;          ]
;          ]
;
;        ]
;      ]
;
;    ]
;
;  ]


end
to ready-to-park? ;;whether this car is willing to park

  if parked? = false[

;; if there are parking space next to it
;; if there are parking space across the road
;    ifelse (([availability] of patch-at-heading-and-distance 180 1 = 1 and [wait?] of patch-at-heading-and-distance 180 1 = 0)
;      or ([availability] of patch-at-heading-and-distance 90 1 = 1 and [wait?] of patch-at-heading-and-distance 90 1 = 0)
;      or ([availability] of patch-at-heading-and-distance 0 1 = 1 and [wait?] of patch-at-heading-and-distance 0 1 = 0)
;      or ([availability] of patch-at-heading-and-distance 270 1 = 1 and [wait?] of patch-at-heading-and-distance 270 1 = 0)
;    )
    if strategy = 1 or strategy = 2
    [check-space-nearby]
    if strategy = 3 or strategy = 4
    [check-space-across]
    if strategy = 0
    [
     ifelse member? who red_values
      [check-space-nearby]
      [check-space-across]

    ]




  ]



end
to car-change-lane
;;heading - 90
  if change-lane? = true
  [
    if not any? turtles-on patch-at-heading-and-distance (heading - 90) 1 and [plabel] of patch-at-heading-and-distance (heading - 90) 2 = who
    [
      setxy ([pxcor] of patch-at-heading-and-distance (heading - 90) 1)([pycor] of patch-at-heading-and-distance (heading - 90) 1)
      set change-lane? false
    ]

    if not any? turtles-on patch-at-heading-and-distance 270 1 and [plabel] of patch-at-heading-and-distance 270 2 = who and [pcolor] of patch-at-heading-and-distance 270 2 = grey
    [
    setxy ([pxcor] of patch-at-heading-and-distance 270 1)([pycor] of patch-at-heading-and-distance 270 1)
      set change-lane? false
    ]

    if not any? turtles-on patch-at-heading-and-distance 0 1 and [plabel] of patch-at-heading-and-distance 0 2 = who and [pcolor] of patch-at-heading-and-distance 0 2 = grey
    [
    setxy ([pxcor] of patch-at-heading-and-distance 0 1)([pycor] of patch-at-heading-and-distance 0 1)
      set change-lane? false
    ]


  ]


end

to park-process

  if ([availability] of (patch-at-heading-and-distance 180 1) = 1 and who = [plabel] of (patch-at-heading-and-distance 180 1))[


     ask (patch-at-heading-and-distance 180 1)
    [set availability 0]

    if park? = true[
         setxy [pxcor] of (patch-at-heading-and-distance 180 1) [pycor] of (patch-at-heading-and-distance 180 1)
        ;;set color black
        set parked? true
        set heading 0
        ]

 ]

  if ([availability] of (patch-at-heading-and-distance 0 1) = 1 and who = [plabel] of (patch-at-heading-and-distance 0 1))[

     ask (patch-at-heading-and-distance 0 1)
    [set availability 0
    ]

    if park? = true[
         setxy pxcor (pycor + 1)
      ;;set color green
        ;;set color black

        set parked? true
        set heading 0
        ]

 ]

  if ([availability] of (patch-at-heading-and-distance 270 1) = 1 and who = [plabel] of (patch-at-heading-and-distance 270 1))[


     ask (patch-at-heading-and-distance 270 1)
    [set availability 0]

    if park? = true[
         setxy [pxcor] of (patch-at-heading-and-distance 270 1) [pycor] of (patch-at-heading-and-distance 270 1)
        ;;set color black
        set parked? true
        set heading 270
        ]

 ]



end

to slow-down-car ; turtle procedure
  let blocking-cars other turtles in-cone (l-headway + size) 90 ;;with [ d-distance <= l-headway ]
  let blocking-car min-one-of blocking-cars [ distance myself ]
  if blocking-car != nobody[

    set speed max (list 0 (speed - deceleration))
    if speed > 0
    [set speed min (list speed ([speed] of blocking-car))
    ]

  ]

end


to-report d-distance
  report distance-nowrap patch xcor [ycor]  of myself
end

to calculate-time
  set total-travel-time (total-travel-time + (count turtles with [parked? = false]  * t-step))

end
@#$#@#$#@
GRAPHICS-WINDOW
18
35
511
344
-1
-1
23.13333333333334
1
10
1
1
1
0
1
1
1
0
20
0
12
0
0
1
ticks
30.0

TEXTBOX
37
452
187
470
Initialize\n
12
0.0
1

TEXTBOX
252
397
402
415
Parameter
12
0.0
1

TEXTBOX
443
392
593
410
Setting
12
0.0
1

BUTTON
28
511
108
544
go once
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
31
546
94
579
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
206
431
378
464
acceleration_input
acceleration_input
0
5
4.6
0.1
1
NIL
HORIZONTAL

SLIDER
214
487
386
520
deceleration_input
deceleration_input
0
2.5
2.4
0.1
1
NIL
HORIZONTAL

SLIDER
429
433
601
466
car-total-number
car-total-number
0
76
76.0
1
1
NIL
HORIZONTAL

SLIDER
432
489
604
522
l-headway_input
l-headway_input
0
4
4.0
0.05
1
NIL
HORIZONTAL

SLIDER
645
434
817
467
v-max_input
v-max_input
0
9
8.3
0.1
1
NIL
HORIZONTAL

SLIDER
440
552
612
585
t-step
t-step
0
5
0.4
0.1
1
NIL
HORIZONTAL

SLIDER
651
496
823
529
l-vehicle_input
l-vehicle_input
0
4
3.72
0.01
1
NIL
HORIZONTAL

SLIDER
673
555
845
588
space-size
space-size
0
5.5
5.5
0.1
1
NIL
HORIZONTAL

SLIDER
227
543
399
576
parking-time
parking-time
0
100
9.0
1
1
NIL
HORIZONTAL

PLOT
556
39
770
191
Total Travel Time (s)
time(s)
total travel time 
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plotxy (ticks * t-step) total-travel-time"

PLOT
556
220
756
370
Number of Vehicles Parked
time(s)
Number of Vehicle parked
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plotxy ticks * t-step count turtles with[parked? = true]"

BUTTON
34
472
97
505
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
true
0
Polygon -7500403 true true 135 -15 151 6 171 24 180 45 183 59 209 72 231 82 240 105 240 135 225 180 180 210 150 285 150 285 90 285 90 -15 135 -15
Circle -16777216 true false 30 30 90
Circle -16777216 true false 30 150 90
Polygon -16777216 true false 175 78 177 108 120 106 120 31 150 46 159 51 166 60
Circle -7500403 true true 47 165 58
Circle -7500403 true true 47 47 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
