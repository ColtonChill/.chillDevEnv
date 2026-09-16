I need your help to develop this new feature. The instructions I was given where a bit vague on the ticket, so I'm trying to piece things together.

```
Update the VtolMalink interface to add support for the Precision Landing command. The interface should make use of the desired location and approach heading to create a reasonable landing pattern. This landing pattern should be based off of, and act just like the landing paths that the pilots plan. This includes which waypoints require which actions as well as the distance between points and descending altitudes
```
As best as I can tell, I need to make a function that will take in the `PrecisionLandPlatformCmd` object, and let the autopilot via this preexistent interface to do the lead in to begin a "precision landing" whatever that means. I think they have already done that part somewhere else is the code. I just need to code up the algorithm for the banking flight path to set up the vtol for a "precision landing".

Talking with one of the pilots, he was able to give me a txt of waypoints they have used at the testing grounds to do this exact maneuver.
```
QGC WPL 110
0	1	0	16	0	0	0	0	41.7877670	-111.9812098	1350.998558	1
1	0	3	22	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	0.00000000	45.720000	1
2	0	3	16	0.00000000	0.00000000	0.00000000	0.00000000	41.78884890	-111.97709800	67.055999	1
3	0	3	16	0.00000000	0.00000000	0.00000000	0.00000000	41.79048880	-111.97607870	91.439999	1
4	0	3	17	0.00000000	0.00000000	0.00000000	0.00000000	41.79124870	-111.97878240	106.679999	1
5	0	3	16	0.00000000	0.00000000	0.00000000	0.00000000	41.79028080	-111.98342800	91.439999	1
6	0	3	16	0.00000000	0.00000000	0.00000000	0.00000000	41.78900090	-111.99067000	76.199999	1
7	0	3	16	0.00000000	0.00000000	0.00000000	0.00000000	41.78713700	-111.99254750	60.960000	1
8	0	3	16	0.00000000	0.00000000	0.00000000	0.00000000	41.78659300	-111.98844910	53.340000	1
9	0	3	16	0.00000000	0.00000000	0.00000000	0.00000000	41.78725300	-111.98406100	45.720000	1
10	0	3	21	0.00000000	0.00000000	0.00000000	0.00000000	41.78776500	-111.98121250	0.000000	1

```

I kind of think this text file is actually a looped flight plan they were having the drone execute rather then the landing profile. I was able to find this kmz which I think is more likely to be the actual landing profile I should emulate.

I've included some code like the existing interface code as well as the PrecisionLandPlatformCmd struct. Let me know if you think you need any more code.

```
class PrecisionLandPlatformCmd : public PlatformCmd
{
public:
  Lla m_landingSite;
  double m_approachAngle;
  MSGPACK_JSON_DEFINE(PrecisionLandPlatformCmd,
                      MSGPACK_BASE(PlatformCmd),
                      m_landingSite,
                      m_approachAngle)
};
```
What do you think I should do to fill in the precisionLand function?




------------------




I'm trying to develop a new interface for my works primary software.
I was given 2 tickets to do this job, the first being the MVP, the second building on it flushing it out. Here is the text of the tickets:

```
Create an interface that can ingest video and measurements from a single source and be able to output annotated video.

MPV: plot the fused track
```


```
Now make the interface that can ingest video/measurements from multiple sources. and measurement/track types

Colored by source (orange = track, red = radar measurements, yellow = ebs measurements, some other color (good contrast) for truth in post processing scenario)


MVP & Beyond!

    Ellipses (projection of covariance ellipsoid) - sized by uncertainty, colored by source type
    A priori state and measurements and uncertainties ellipses (projection of covariance ellipsoid)
    Being able to turn these different features on/off
```

My understanding of these tickets is that I need to make a new sub program (cpp and hpp) which will run along side some other sub programs, get the information it needs from them (such as video feeds and tracking feeds), and output a visualization where these data are projected upon.

I have the source code of some other sub-programs which I think are doing similar operations (as far a reading in video, subscribing to feeds, and output video). In particular, I think the videoATR sub program would be a good place to start stealing code from. Most of it I think we can ignore as it's a abstract class meant to mount inference models for real time object detection and classification. However, the video and feed parts I think are worth looking at. There are some bits like the lossyQueue I'm not sure are needed. And the DDS stuff I'll just take on faith works as  the less of that I have to monkey with, the better.

I've started coping over some parts for the video and dds stuff, but I'm not really sure what I'm doing. Can you give me a hand at getting this started?

```
VideoAnnotatorIfc::VideoAnnotatorIfc() {}

void VideoAnnotatorIfc::updateConfig()
{
  // TODO (chill) read in tracks and measurements from config
  // TODO (chill) read in video source from config
  // if in H.264 mode need to turn on Decoder
  m_useDdsInput = componentKeyVal("Input", "UseDds");
  if (!m_useDdsInput)
  {
    addCustomCapability(SensorCap::VIDEODEC);
  }
  // if not, get DDS parameters
  else
  {
    m_ddsSub = componentKeyVal("Input", "DdsFrameTopic");
    m_numSamples = componentKeyVal("Input", "NumSamples");
  }

  // determine which kind or meta cap to create
  m_metaFromVideo = !m_useDdsInput && componentKeyVal("Input", "MetaFromVideo");
  m_useInterpMeta = componentKeyVal("Input", "UseInterp");
  if (!m_metaFromVideo)
  {
    if (m_useInterpMeta)
    {
      addCustomCapability(SensorCap::VIDEOMETAINTERP);
      m_timeout = std::chrono::milliseconds(
        componentKeyVal("Input", "MetaTimeoutMillisecs"));
    }
    else
    {
      addCustomCapability(SensorCap::VIDEOMETANONINTERP);
    }
  }

  // Add encoding capability for editing video
  addCustomCapability(SensorCap::VIDEOENC);
}

void VideoAnnotatorIfc::mgrSetupCallback()
{
  // do the DDS sub here; need to ensure cap exists when
  // DDS message start to arrive
  if (m_useDdsInput)
  {
    auto frameFunc = [this](const V4l2Frame& frame)
    {
      SdlTime currTime;
      // only add frame if sufficient time has passed
      if (currTime - m_lastUpdate >= m_processingInterval)
      {
        try
        {
          // create a deep-copied frame
          std::shared_ptr<SDVIDEO::VideoFrame> pVFrame =
            DDS::helpers::DDSCopiedToVideoFrame(frame);

          // add to processing queue
          m_lossyQueue.addItem(std::pair(pVFrame, nullptr), 0);
          m_lastUpdate = currTime;
          m_pushedFrames++;
          return;
        }
        catch (std::exception& e)
        {
          throttleReport("Failed to enqueue frame",
                         std::chrono::seconds(2),
                         MsgLevel::ERR,
                         "Exception: Failed to enqueue frame: "
                           + std::string(e.what()));
        }
      }
      m_ignoredFrames++;
    };
    // Create DDS sub
    m_pDdsSub = std::make_unique<DDSSub<V4l2Frame, V4l2FramePubSubType>>(
      m_ddsSub, frameFunc, this->getComponent().m_name);
    // Apply QoS
    m_pDdsSub->useQos(DdsQosEnum::DATA_SHARING, m_numSamples, 1);
  }


  // set up a thread that will drain the lossy queue
  ame::ThreadSystem::getThreadSystem().executeAperiodic(
    [this]() { processVideo(); },
    std::chrono::seconds(0),
    "PROCESS_VID_" + this->getComponent().m_name);
}

```
