parameter inc is 0, lan is 0.

local curorbit is ship:orbit.

local curorbitvel is ship:orbit:velocity:orbit:NORMALIZED.
local curorbotrad is ship:orbit:body:POSITION.

local curorbitnorm is vcrs(curorbitvel,curorbotrad).


SET anArrow TO VECDRAW(
      V(0,0,0),
      curorbitnorm,
      RGB(1,0,0),
      "See the arrow?",
      1.0,
      TRUE,
      0.2
    ).


    print curorbitnorm.
    print curorbitvel.
    print curorbotrad.
