


LOCK THROTTLE TO 0.15.   // 1.0 is the max, 0.0 is idle.

SET STARTTIME TO TIME:SECONDS.

//10,324.621166284 for full


SET ORBITHEIGHT TO 1750000.//2500000.//((Kerbin:ROTATIONPERIOD/(2*constant:pi))^2*(constant:G * Kerbin:Mass))^(1/3).
PRINT "Orbit: " + ORBITHEIGHT.
PRINT "START: " + STARTTIME.
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


WHEN MAXTHRUST = 0 THEN {
    if stage:ready{
      PRINT "Staging".
      STAGE.
    }
    PRESERVE.
}.

WHEN SHIP:solidfuel = 0 THEN {
    PRINT "Staging".
    STAGE.
    if THROTTLE > 0.0 {
      LOCK THROTTLE TO 1.0.
    }
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
  print "Time:         "+TIME:SECONDS AT (0,25).
  print "OLDTime:      "+STARTTIME AT (0,26).
  //PRINT "ETA Apoapsis: "+SHIP:ORBIT:ETA:APOAPSIS AT (0,24).

  SET STEER to HEADING(PLANE,deg).
  wait 0.
}.
set fuelchange to eng:fuelflow*5.
set maxpwr to eng:MAXTHRUST.

LOCK THROTTLE TO 0.0.
wait 1.
stage.
wait 1.
LOCK THROTTLE TO 0.01.
wait 0.5.
LOCK THROTTLE TO 0.0.
ag1 on.
RCS ON.
print "Waiting for circle burn".



run hohmann(ORBITHEIGHT).


PRINT "100km apoapsis reached, cutting throttle".
print "Time:         "+TIME:SECONDS.
print "OLDTime:      "+STARTTIME.

LOCK THROTTLE TO 0.

SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
