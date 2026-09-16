
## Tasks

[?] Add new command to the platform capability.
    * ??? Correction from Trevor. This should go into the sensorPlatform capability
[?] Add this new command to automated queuing from C&B. 
[?] Update PlatformSim to report that it received the command.

[?] Have SensorPlatform validate that the information in the message are valid before passing it on to the interface
    * valid LLA and heading (-360 to 360)


## Plan

## Architecture Understanding

ATR needs to make a detection for the landing pad
 -> kick off the "precision landing" command via a Condition & Behavior
 -> somehow send that to the autopilot

The class `PlatformCapCmds` is a container of optional virtual functions which sensors can implement.
`PlatformCapCmds` is inherited by `SensorPlatform.hpp`, `PlatformSimIfc.hpp`, Mavlink BS, etc.


## Implementation

1. Add new `PrecisionLandPlatformCmd` class to `sigma-icd/capabilities/CmdPlatform.hpp`
2. (SUSPECT) Add virtual `doPrecisionLanding` function to `sigma-icd/capabilities/PlatformCap.hpp`
  1. ? Maybe add virtual `doPrecisionLanding` function to `SensorPlatform.hpp` instead?
    * Tried this, `PlatformSimIfc` gets a build error as it can't find the function to override.
  2. Maybe instead have SensorPlatform fulfill the virtual function.
3. Fulfill virtual `doPrecisionLanding` in `Interfaces/platformSim/PlatformSimIfc.hpp`
  1. Add `PrecisionLandPlatformCmd` listener to `PlatformSimIfc.cpp`
4. Add a new "action" to the sigma-icd, `PrecisionLanding.hpp`
5. Add `PrecisionLandPlatformCmd` call back to `SensorPlatform::init()` 

## TODO
Figure out how to add precitionLand validation to `SensorPlatform`
* Maybe add a validation function between call back an virtual function


