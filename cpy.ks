switch to 0.
COMPILE c.ks to c.ksm.
COMPILE node.ks to node.ksm.
COMPILE lib_ui.ks to lib_ui.ksm.
COMPILE warp.ks to warp.ksm.
COMPILE circle.ks to circle.ksm.
switch to 1.
CD("1:/").
COPYPATH("0:/c.ksm", "").
COPYPATH("0:/node.ksm", "").
COPYPATH("0:/lib_ui.ksm", "").
COPYPATH("0:/warp.ksm", "").
COPYPATH("0:/circle.ksm", "").

CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
SET TERMINAL:WIDTH TO 33.
SET TERMINAL:HEIGHT TO 45.
CLEARSCREEN.
run c.
