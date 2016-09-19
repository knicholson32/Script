parameter alti.
RCS ON.
SET state TO false.
until state {

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
  wait 5.
  run node.

  local mu is body:mu.
  local br is body:radius.

  // present orbit properties
  local vom is ship:obt:velocity:orbit:mag.      // actual velocity
  local r is br + altitude.                      // actual distance to body
  local ra is br + periapsis.                    // radius at burn apsis
  local v1 is sqrt( vom^2 + 2*mu*(1/ra - 1/r) ). // velocity at burn apsis

  // true story: if you name this "a" and call it from circ_alt, its value is 100,000 less than it should be!
  local sma1 is SHIP:ORBIT:SEMIMAJORAXIS.

  // future orbit properties
  local r2 is br + periapsis.                    // distance after burn at periapsis
  local sma2 is (alti + 2*br + periapsis)/2. // semi major axis target orbit
  local v2 is sqrt( vom^2 + (mu * (2/r2 - 2/r + 1/sma1 - 1/sma2 ) ) ).

  // create node
  local deltav is v2 - v1.
  local nd is node(time:seconds + eta:periapsis, 0, 0, deltav).
  add nd.
  wait 5.
  run node.
  print SHIP:ORBIT:ECCENTRICITY.
  if abs(periapsis - alti) < 2500 AND abs(apoapsis - alti) < 2500  {
    SET state TO true.
  }

}
