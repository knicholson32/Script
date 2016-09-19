//Hohmann Transfer
parameter alti, inc is 0, lonAsc is 0, lim is 2500. //Altitude expected
RCS ON.
SET hohState TO false.
SET HOHTIME TO TIME:SECONDS.
SET HOHCOUNT TO 0.
run lib_ui.
uiConsole("HT","Initiate Hohmann Transfer:").
uiConsole("HT","Adjustment to "+round(alti)+"m").
uiConsole("HT","Start Time:   "+round(HOHTIME)).
uiConsole("HT","Limit Value:  "+round(lim)).

if eta:apoapsis < eta:periapsis {
  SET APSISTYPE to true.  // Apoapsis is first
  uiConsole("HT","Initial Pos:  Apoapsis").
} else {
  SET APSISTYPE to false. // Periapsis is first
  uiConsole("HT","Initial Pos:  Periapsis").
}

uiConsole("HT","=============================").
uiConsole("HT","=============================").


//Transfer Function
function transfer {
  SET HOHCOUNT TO HOHCOUNT+1.
  parameter apsis, timeval.
  uiConsole("HT","Node Creation for T"+round(timeval-TIME:SECONDS) + "s").
  local mu is body:mu.
  local br is body:radius.

  // present orbit properties
  local vom is velocity:orbit:mag.               // actual velocity
  local r is br + altitude.                      // actual distance to body
  local ra is br + apsis.                     // radius at burn apsis
  local v1 is sqrt( vom^2 + 2*mu*(1/ra - 1/r) ). // velocity at burn apsis
  local sma1 is SHIP:ORBIT:SEMIMAJORAXIS. // semi major axis present orbit
  // future orbit properties
  local r2 is br + apsis.               // distance after burn at apoapsis
  local sma2 is (alti + 2*br + apsis)/2. // semi major axis target orbit
  local v2 is sqrt( vom^2 + (mu * (2/r2 - 2/r + 1/sma1 - 1/sma2 ) ) ).

  // create node
  local deltav is v2 - v1.
  uiConsole("HT","DeltaV:       "+round(deltav,2)).
  local nd is node(time:seconds + timeval, 0, 0, deltav).
  add nd.
  wait 5.
  run node ("HT").
  uiConsole("HT"," ").
}

//Activate the transfer
until hohState {

  if APSISTYPE {
    transfer(apoapsis, eta:apoapsis).
    transfer(periapsis, eta:periapsis).
  }else{
    transfer(periapsis, eta:periapsis).
    transfer(apoapsis, eta:apoapsis).
  }

  //Check conditions
  if abs(periapsis - alti) < lim AND abs(apoapsis - alti) < lim  {
    SET hohState TO true.
    uiConsole("HT","Adequate profile. Transfer Complete").
  }
}
uiConsole("HT","Time:         "+round(TIME:SECONDS-HOHTIME) + "s").
uiConsole("HT","Transfers:    "+HOHCOUNT).
