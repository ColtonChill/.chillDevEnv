Terminal One (sigma):
    Run sigma created by '/sigma/Utilities/jsonGen create -e test CameraGimbalTest,SimpleArbiter,ExternalPathPlanner,PlatformSim,SigmaManager,TrivialPathTracker > testSimpleArb.json' and ran with '/sigma/Utilities/interactor -j testSimpleArb.json'

Terminal Two (sigma):
    Run console reader with '/sigma/Utilities/ConsoleReader listen -s ExternalPathPlanner'

Terminal Three (sigma):
    Open listening port with 'nc -ul 127.0.0.1 26201'

Terminal Four (sigma):
    Initialize a mission planner with '/sigma/Utilities/sendplan /path/to/a/_mission_plan_config.json' This triggers the following message from terminal two:
        [time] <ExternalPathPlanner> GOT EXECUTION SET: the UUID

Terminal Five:

    Paste the UUID from terminal two into testPathJsonMsgPretty["Msg"]["PrimaryCollectUuids"]
    Send path with either python or 'cat testPathJsonMsgPretty.json | nc -u 127.0.0.1 26202'


 
The idea is to send a mission plan (the mission plan I was using is on the container I sent you) using the sendplan call above.  After you do this, the ExternalPathPlanner will output a Mission Plan on the 26201 port (you also see the 26201 a periodic msg with the behaviors.  The mission plan only comes once after the mission plan is sent using 'sendplan').  I copied the UUID from this mission plan->CR output into the testPathJsonMsgPretty.json file and sent that back to the external path planner using 'cat'.  I confirmed that this send a path to the platform.  I told them that their python script needs to connect to these same ports, parse out the Mission Plan msg with the CR, pull the correct UUID out, and send the msg based on the 'testPathJsonMsgPretty.json' back to the External Path Planner.  You shouldn't need to listen on port 26201 and cat back to 26202, their script SHOULD be doing that.

APPENDIX:

I'll also send my instructions to them as an appendix.  I don't think you need to parse through this, but if you get stuck, there MAY be something in my instructions to them that COULD help.  I thought their summary above was right and easier to read.

 
You get the SIGMA output from the external path planner by running
nc -ul 127.0.0.1 26201

When you hit sendplan, you will get an execution set out on that port.  You need to copy the CollectionRequest UUID into the 'PrimaryCollectUuids' section of the testPathJsonMsg.json.  Just replace the cr uuid that is there already.  WHen you send that testPathJsonMsg.json back via

cat testPathJsonMsgPretty.json | nc -u 127.0.0.1 26202

you should see the SIGMA output a new blue output message something along the lines of 'routing to LEADIN'.  That means you successfully got the SIGMA node routed to fly the path you sent.  The path message I sent you has 4 waypoints.  Node the 'Type' field in each waypoint.  The waypoint type to number conversion is in section 2.4.5 of the path planning ICD.  The first waypoint needs to be type 1, or a LEADIN type.  Waypoints between the LEADIN and the START are typically INTERMEDIATE points.  The START point is when the sensor should actually turn on.  Waypoints between START and STOP are typically INTERMEDIATE points.  The STOP waypoint is when the sensor should turn off.  Waypoints between STOP and LEADOUT are typically INTERMEDIATE.  The LEADOUT is the last waypoint.  We typically give some space between the LEADIN and START to give the platform some time in a straight line to get stable prior to turning on the sensor.  We also typically give some LEADOUT time so that as the sensor turns off the platform is still flying straight and stable and to give any detections time to get through the system.  We typically have this be a config item in the SIGMA Json that gets run.  For you, you could either hard code the LEADIN and LEADOUT, or have it be a command line setting when starting your python application.  Don't worry much about the LEADIN and LEADOUT for now, just know it is there.

## Colton's procedure
1. Inside sigma
   ./Utilities/interactor -j testCameraGimbalSimple.json
3. From the subtopic, listen for the execution set
  Get the ExecutionPlans.Collection.Uuid

7d46e11e-fb10-45e3-bd25-379c57592059
