//hellolaunch
CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").

//First, we'll clear the terminal screen to make it look nice
CLEARSCREEN.


//Next, we'll lock our throttle to 100%.
LOCK THROTTLE TO 0.05.   // 1.0 is the max, 0.0 is idle.




SET ORBITHEIGHT TO ((Kerbin:ROTATIONPERIOD/(2*constant:pi))^2*(constant:G * Kerbin:Mass))^(1/3).
PRINT "Orbit: " + ORBITHEIGHT.
SET PLANE TO 90. //East
SET deg TO 90.
SET STEER TO HEADING(PLANE,deg).
LOCK STEERING TO STEER.
SET eng to ship:partstagged("en")[0].
//This is our countdown loop, which cycles from 10 to 0
PRINT "Counting down:".
FROM {local countdown is 5.} UNTIL countdown = 0 STEP {SET countdown to countdown - 1.} DO {
    PRINT "..." + countdown.
    WAIT 0.5. // pauses the script here for 1 second.
}

//This is a trigger that constantly checks to see if our thrust is zero.
//If it is, it will attempt to stage and then return to where the script
//left off. The PRESERVE keyword keeps the trigger active even after it
//has been triggered.
WHEN MAXTHRUST = 0 THEN {
    PRINT "Staging".
    STAGE.
    PRESERVE.
}.

WHEN SHIP:solidfuel = 0 THEN {
    PRINT "Staging".
    STAGE.
    LOCK THROTTLE TO 1.0.
}.

print "Launch".
wait until ship:ALTITUDE >= 7500.
SET curAP to ship:APOAPSIS.

print "Slope".
PRINT "====================" AT (0,18).
until ship:APOAPSIS >= ORBITHEIGHT {
  set deg to round(80*(1-(ship:APOAPSIS-curAP)/(ORBITHEIGHT-curAP)))+10.
  print "Pitch: " + deg AT(0,15).
  PRINT ROUND(SHIP:APOAPSIS,0) AT (0,16).
  PRINT ORBITHEIGHT AT (0,17).

  PRINT "Apoapsis:     "+SHIP:ORBIT:APOAPSIS AT (0,19).
  PRINT "Periapsis:    "+SHIP:ORBIT:PERIAPSIS AT (0,20).
  PRINT "Eccentrocity: "+SHIP:ORBIT:ECCENTRICITY AT (0,21).
  PRINT "Semi-major A: "+SHIP:ORBIT:SEMIMAJORAXIS AT (0,22).
  PRINT "Semi-minor A: "+SHIP:ORBIT:SEMIMINORAXIS AT (0,23).
  PRINT "Solid:        "+SHIP:solidfuel AT (0,24).
  //PRINT "ETA Apoapsis: "+SHIP:ORBIT:ETA:APOAPSIS AT (0,24).

  SET STEER to HEADING(PLANE,deg).
  wait 0.
}.
set fuelchange to eng:fuelflow*5.
set maxpwr to eng:MAXTHRUST.
LOCK THROTTLE TO 0.0.

print "Waiting for circle burn".
LOCK vel to ship:orbit:velocity:orbit.
LOCK STEER to Ship:prograde.
set targetVEL to sqrt((constant:G * Kerbin:Mass)/(ORBITHEIGHT+Kerbin:RADIUS)).
set TVC to targetVEL - sqrt(((constant:G * Kerbin:Mass)*(1-SHIP:ORBIT:ECCENTRICITY))/(SHIP:ORBIT:SEMIMAJORAXIS*(1+SHIP:ORBIT:ECCENTRICITY))).
set state to false.

//----------

set alti to ORBITHEIGHT.

local mu is body:mu.
local br is body:radius.

// present orbit properties
local vom is velocity:orbit:mag.               // actual velocity
local r is br + altitude.                      // actual distance to body
local ra is br + apoapsis.                     // radius at burn apsis
local v1 is sqrt( vom^2 + 2*mu*(1/ra - 1/r) ). // velocity at burn apsis
// true story: if you name this "a" and call it from circ_alt, its value is 100,000 less than it should be!
local sma1 is SHIP:ORBIT:SEMIMAJORAXIS. // semi major axis present orbit
// future orbit properties
local r2 is br + apoapsis.               // distance after burn at apoapsis
local sma2 is (alti + 2*br + apoapsis)/2. // semi major axis target orbit
local v2 is sqrt( vom^2 + (mu * (2/r2 - 2/r + 1/sma1 - 1/sma2 ) ) ).

// create node
local deltav is v2 - v1.
local nd is node(time:seconds + eta:apoapsis, 0, 0, deltav).
add nd.

run node.

//----------

//until state = true {
//  if ship:APOAPSIS < ORBITHEIGHT {
//    LOCK THROTTLE TO 0.01.
//  }else{
//    LOCK THROTTLE TO 0.
//  }

  set shipmass to ship:mass*1000.
  set burntime to (constant:e ^ (fuelchange*TVC/(maxpwr*1000))*shipmass-shipmass)/fuelchange.

  if ETA:apoapsis - burntime/2 <= 0 {
    set state to true.
  }

  PRINT "Apoapsis:     "+SHIP:ORBIT:APOAPSIS AT (0,19).
  PRINT "Periapsis:    "+SHIP:ORBIT:PERIAPSIS AT (0,20).
  PRINT "TVC:          "+TVC AT (0,21).
  PRINT "Semi-major A: "+SHIP:ORBIT:SEMIMAJORAXIS AT (0,22).
  PRINT "fuelchange:   "+fuelchange AT (0,23).
  PRINT "Target Vel:   "+targetVEL AT (0,24).
  PRINT "Current Vel:  "+vel:mag AT (0,25).
  PRINT "Burn Time:    "+burntime AT (0,26).
  PRINT "ETA to APO:   "+ETA:apoapsis AT (0,27).
  PRINT "maxpwr:       "+maxpwr AT (0,28).
  PRINT "shipmass:     "+shipmass AT (0,29).
//  wait 0.
//}.

//LOCK STEER to HEADING(PLANE,0).//; - ship:prograde.

//print "Circle burn".
//LOCK THROTTLE TO 1.0.


//until vel:mag >= targetVEL {
  PRINT "Apoapsis:     "+SHIP:ORBIT:APOAPSIS AT (0,19).
  PRINT "Periapsis:    "+SHIP:ORBIT:PERIAPSIS AT (0,20).
  PRINT "TVC:          "+TVC AT (0,21).
  PRINT "Semi-major A: "+SHIP:ORBIT:SEMIMAJORAXIS AT (0,22).
  PRINT "fuelchange:   "+fuelchange AT (0,23).
  PRINT "Target Vel:   "+targetVEL AT (0,24).
  PRINT "Current Vel:  "+vel:mag AT (0,25).
  PRINT "Burn Time:    "+burntime AT (0,26).
  PRINT "ETA to APO:   "+ETA:apoapsis AT (0,27).
  PRINT "maxpwr:       "+maxpwr AT (0,28).
  PRINT "shipmass:     "+shipmass AT (0,29).
//  wait 0.
//}.



//This will be our main control loop for the ascent. It will
//cycle through continuously until our apoapsis is greater
//than 100km. Each cycle, it will check each of the IF
//statements inside and perform them if their conditions
//are met

 // from now on we'll be able to change steering by just assigning a new value to MYSTEER


PRINT "100km apoapsis reached, cutting throttle".

//At this point, our apoapsis is above 100km and our main loop has ended. Next
//we'll make sure our throttle is zero and that we're pointed prograde
LOCK THROTTLE TO 0.

//This sets the user's throttle setting to zero to prevent the throttle
//from returning to the position it was at before the script was run.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
