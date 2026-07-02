Hello Claude, this is my first time using you. 

I'm trying you out today because I've recently grown frustrated with chatGPT and Grok. I believe the models I have access to for my tier (free) have been severally downgraded, causing their outputs to become dramatically more incoherent and unhelpful. My hope is that you as a purpose build coding LLM, you will have better success helping my cut to the heart of the issue and get a better solution.

The problem I am having is with my companies wrapper/utilization of the TensorRT library from Nvida to run Yolo models for computer vision. Recently, my coworker rewrote this submodule to allow use to use both raw onnx models (via opencv) as well as serialized engine models with tensorrt. However, because of our crap regression testing, he seems to have broken the piping for several of our other models, specifically trt models. These models are yolo models which we have doctored with graph surgery to add an ENMS layer to the end. This layer runs NMS on the GPU as well as changes the outputs channels from "output0" to (num_dets, bboxes, scores, labels). For whatever reason, I'm getting erroneous outputs from these models with this new code.

Below is the snippet of code which is generating the error:

//YoloDetector.cpp
```cpp
std::vector<YoloDetector::OutputType> YoloDetector::postprocessEnms()
{
  auto outputBuffers = m_pFramework->getOutputBuffers();
  // For the detection framework we assume that binding 1 corresponds to the
  // number of detections
  const std::vector<float>& numDetectionsOutput =
    outputBuffers[1]->getBindingData(); // "num_dets"
  const std::vector<float>& detectionBoxes =
    outputBuffers[2]->getBindingData(); // "bboxes"
  const std::vector<float>& detectionScores =
    outputBuffers[3]->getBindingData(); // "scores"
  const std::vector<float>& labelIndices =
    outputBuffers[4]->getBindingData(); // "labels"

  if (numDetectionsOutput.empty())
  {
    throw std::runtime_error("num_detections is empty");
  }

  auto numDetections = static_cast<size_t>(numDetectionsOutput[0]);

  if (detectionBoxes.size() < numDetections * 4)
  {
    for (int i = 0; i < 4; i++)
    {
      const auto& raw = outputBuffers[i]->getBindingData();
      const int32_t* asInt = reinterpret_cast<const int32_t*>(raw.data());
      std::cout << "float view: " << raw[0] << "\n";
      std::cout << "int view:   " << asInt[0] << "\n";
    }

    throw std::runtime_error(
      "Number of detections (" + std::to_string(numDetections)
      + ") and number of detection boxes ("
      + std::to_string(detectionBoxes.size()) + ") are mismatched");
  }
```
```stdout
float view: 1.4013e-45
int view:   1
float view: 448.284
int view:   1138762838
float view: 0.906758
int view:   1063788867
float view: 0
int view:   0
Failure: Number of detections (448) and number of detection boxes (100) are mismatched
```

As you can see, these are some nonsensical values I'm getting from the model (if the backend is even reading them in right). Because of the befalling decisions of the original author of this repo made (such as the inability for output channels to be looked up by name, only by idx), the other LLMs recommended I rewrite a simplified version of the backend to get to the bottom of this bug. I tried to some other testing (such as trial casting to ints/floats), but the values I got are even more baffling, so I'm tempted to agree with the other LLMs. I'd like your read of the situation and ask what you would change.

Here is a quick overview of the layout the author made and some of the rational. The public most interface/object is a "task", which implements pre/post processing. A task has a "framework" which is responsible for executing the model as well as moving data in and out of the gpu. Binding buffers are (I think) the communication structs which are used to move data between all these layers.

Below is the original code of the author which I believe is responsible for my bug.

//Framework.hpp
```hpp
namespace sdl_tensorrt
{
  class Framework
  {
  public:
    /** @brief Ctor for Framework from a json
     *
     * @overload
     *
     * @param cfg json to be created from
     */
    explicit Framework(const nlohmann::json cfg);

    /** @brief Ctor for Framework from a file path
     *
     * @param modelPath file to be created from
     */
    explicit Framework(const std::string& modelPath);

    /** @brief Dtor for Framework */
    virtual ~Framework() = default;

    /** @brief Passes data from buffers through the model layers
     *
     * @note Virtual method meant to be overriden for each type of framework
     */
    virtual void forward();

    /** @brief Get all the Input buffers
     *
     * @returns list of input buffers
     */
    std::vector<std::shared_ptr<BindingBuffer>> getInputBuffers();

    /** @brief Get all the Output buffers
     *
     * @returns list of output buffers
     */
    std::vector<std::shared_ptr<BindingBuffer>> getOutputBuffers();

    /** @brief Moves data from a class to a framework buffer
     *
     * @note Virtual method meant to be overriden for each type of framework
     * buffer
     *
     * @param data data to load into a buffer
     * @param bindingBuffer buffer to load data into
     */
    virtual void copyToHostBuffer(const AnyInputType data,
                                  std::shared_ptr<BindingBuffer> bindingBuffer);

    // static void to_json(nlohmann::json& j, const std::shared_ptr<Framework>&
    // f)
    // {
    //   if (f)
    //   {
    //     j["ModelPath"] = f->m_modelPath;
    //     // nlohmann::json temp = *f;
    //     // j = std::move(temp);
    //   }
    //   else
    //   {
    //     j = nullptr; // explicit null in the output
    //   }
    // }

    virtual nlohmann::json getJson() const;

    friend void to_json(nlohmann::json& j, const Framework& f)
    {
      j["ModelPath"] = f.m_modelPath;
    }

    friend Framework from_json(const nlohmann::json& cfg)
    {
      return Framework(cfg);
    }

  protected:
    /** @brief Populates the list of buffers needed to run the model
     *
     * @note Virtual method meant to be overriden for each type of framework
     */
    virtual void allocateInferenceBuffers();

    /** @brief list of indices designating input buffers*/
    std::vector<int> m_inputBuffers;
    /** @brief list of indices designating output buffers*/
    std::vector<int> m_outputBuffers;
    /** @brief aliases/names buffers might be known as */
    std::map<std::string, int> m_idxAliases;
    /** @brief List of each binding in the network (shape, name, data, etc) */
    std::map<int, std::shared_ptr<BindingBuffer>> m_buffers;

    /** @brief  Local Path to the loaded model file*/
    std::string m_modelPath;
    /** @brief  Data the framework was originally built with */
    nlohmann::json m_specs;
  };

  namespace JsonSchemas
  {
    /** @brief Validation JSON schema to compare against when loading from a
     * config file
     */
    static const nlohmann::json FrameworkSchema = nlohmann::json::parse(R"(
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "/schemas/FrameworkSchema.json",
  "title": "Framework",
  "description": "The parameters for an Framework",
  "type": "object",
  "properties": {
    "Name": {
      "title": "Name",
      "description": "The name of the Framework",
      "type": "string",
      "enum": [
        "engine",
        "opencv"
      ]
    },
    "ModelPath": {
      "description": "The path to the model file",
      "type": "string"
    },
    "ConvertFrom": {
      "type": "string"
    },
    "LogSeverity": {
      "type": "integer",
      "minimum": 0,
      "maximum": 4,
      "default": 3
    }
  },
  "required": [
    "Name",
    "ModelPath"
  ]
}
  )");
  } // namespace JsonSchemas
} // namespace sdl_tensorrt
```

//Framework.cpp
```cpp
Framework::Framework(const nlohmann::json cfg)
  : Framework(cfg.value("ModelPath", ""))
{
}

Framework::Framework(const std::string& modelPath) : m_modelPath(modelPath)
{
  if (m_modelPath.empty())
  {
    std::string err("No model file was passed");
    throw std::runtime_error(err);
  }

  std::cout << "Setting up framework for: " << m_modelPath << std::endl;
  while (!std::filesystem::is_regular_file(m_modelPath))
  {
    std::cout << "Invalid model file: " << m_modelPath << std::endl;
    std::this_thread::sleep_for(std::chrono::seconds(1));
  }
}

std::vector<std::shared_ptr<BindingBuffer>> Framework::getInputBuffers()
{
  std::vector<std::shared_ptr<BindingBuffer>> inputBuffers;

  std::transform(m_inputBuffers.begin(),
                 m_inputBuffers.end(),
                 std::back_inserter(inputBuffers),
                 [&](int i) { return m_buffers[i]; });
  return inputBuffers;
}

void Framework::forward() {}

void Framework::allocateInferenceBuffers() {}

std::vector<std::shared_ptr<BindingBuffer>> Framework::getOutputBuffers()
{
  std::vector<std::shared_ptr<BindingBuffer>> outputBuffers;

  std::transform(m_outputBuffers.begin(),
                 m_outputBuffers.end(),
                 std::back_inserter(outputBuffers),
                 [&](int i) { return m_buffers[i]; });
  return outputBuffers;
}

void Framework::copyToHostBuffer(
  [[maybe_unused]] const AnyInputType data,
  [[maybe_unused]] std::shared_ptr<BindingBuffer> bindingBuffer)
{
}

nlohmann::json Framework::getJson() const
{
  nlohmann::json temp = *this;
  return temp;
}
```

//EngineFramework.hpp
```hpp
using json = nlohmann::json;

namespace sdl_tensorrt
{
  //////////////////////////////// EngineBuffer ////////////////////////////////

  /**
   * @brief: wrapper for Engine buffers with a more specific dimension member.
   * Derived from tensorRT sample code.
   */
  class EngineBuffer : public BindingBuffer
  {
  public:
    /** @brief Ctor for Engine Buffer
     *
     * @param id unique id number
     * @param name unique buffer name
     * @param IOMode type of buffer (input, output, etc.)
     * @param dims dimensions of the buffer
     */
    EngineBuffer(int id,
                 const std::string& name,
                 LayerType IOMode,
                 nvinfer1::Dims dims);

    /** @brief Buffer to do inference with on the GPU */
    DeviceBuffer deviceBuffer;
    /** @brief Buffer to do inference with on the host */
    HostBuffer hostBuffer;
  };

  //////////////////////////////// EngineModel ////////////////////////////////

  class EngineModel : public Framework
  {
  public:
    /** @brief Ctor for Engine Framework from a json
     *
     * @overload
     *
     * @param cfg json to be created from
     */
    explicit EngineModel(const nlohmann::json cfg);
    /** @brief Ctor for Engine Framework from a file path
     *
     * @overload
     *
     * @param modelPath file to be created from
     */
    explicit EngineModel(const std::string& modelPath);
    /** @brief Ctor for Engine Framework from a file path while specifying a
     * logger
     *
     * @param modelPath file to be created from
     * @param logger logger to write notifications out to
     */
    EngineModel(const std::string& modelPath, Logger& logger);

    /** @brief Passes data from buffers through the model layers */
    void forward() override;

    /** @brief Moves data from a class to a framework buffer
     *
     * @param data data to load into a buffer
     * @param bindingBuffer buffer to load data into
     */
    void copyToHostBuffer(
      const AnyInputType data,
      std::shared_ptr<BindingBuffer> bindingBuffer) override;

    static EngineModel from_json(const json& j)
    {
      return EngineModel(j);
    }

    // static std::shared_ptr<EngineModel> from_json(const json& j)
    // {
    //   return std::make_shared<EngineModel>(j);
    // }

    // friend void to_json(json& j, const EngineModel m)
    // {
    //   // Framework::to_json(j, m);
    // }

  private:
    // TODO: Remove?
    // nvinfer1::INetworkDefinition m_model;

    /** @brief TensorRT engine containing the "network" with metadata */
    std::shared_ptr<nvinfer1::ICudaEngine> pCudaEngine;
    /** @brief Execution context for running inference with the engine */
    std::shared_ptr<nvinfer1::IExecutionContext> pContext;
    /** @brief NVIDIA device to do inference with */
    int m_deviceIndex{0};
    /** @brief logger to write notifications out to */
    Logger m_logger;

    /** @brief Populates the list of buffers needed to run the model */
    void allocateInferenceBuffers() override;

    /** @brief Moves OpenCV data to a Engine buffer
     *
     * @param frame data to load into a buffer
     * @param bindingBuffer buffer to load data into
     */
    static void copyImageToHost(const cv::Mat& frame,
                                std::shared_ptr<EngineBuffer> bindingBuffer);
  };

} // namespace sdl_tensorrt
```
//EngineFramework.cpp
```cpp
using namespace sdl_tensorrt;

//////////////////////////////// EngineBuffer ////////////////////////////////

EngineBuffer::EngineBuffer(int id,
                           const std::string& name,
                           LayerType IOMode,
                           nvinfer1::Dims dims)
  : BindingBuffer(id, name, IOMode)
{
  hostBuffer.resize(dims);
  deviceBuffer.resize(dims);

  for (int32_t i = 0; i < dims.nbDims; i++)
  {
    m_dims.emplace_back(dims.d[i]);
  }
}

//////////////////////////////// EngineModel ////////////////////////////////
EngineModel::EngineModel(const nlohmann::json cfg)
  : EngineModel(std::string(cfg.value("ModelPath", "")))
{
}

EngineModel::EngineModel(const std::string& modelPath)
  : EngineModel(modelPath, *(new Logger()))
{
}

EngineModel::EngineModel(const std::string& modelPath, Logger& logger)
  : Framework(modelPath), m_logger(logger)
{
  if (m_specs.contains("LogSeverity"))
  {
    m_logger.setVerbosity(
      static_cast<Logger::Severity>(m_specs.at("LogSeverity")));
  }

  if (!initLibNvInferPlugins(&m_logger, ""))
  {
    throw std::runtime_error("Unable to initialize NvInfer plugins");
  }

  // Read the deserialized model from disk
  std::ifstream file(m_modelPath, std::ios::binary | std::ios::ate);
  std::streamsize size = file.tellg();
  file.seekg(0, std::ios::beg);

  std::vector<char> buffer(size);
  if (!file.read(buffer.data(), size))
  {
    throw std::runtime_error("Unable to read engine file");
  }

  std::unique_ptr<nvinfer1::IRuntime> runtime{
    nvinfer1::createInferRuntime(m_logger)};
  if (!runtime)
  {
    throw std::runtime_error("Unable to create inference runtime");
  }

  // Set the device index
  auto ret = cudaSetDevice(m_deviceIndex);
  if (ret != 0)
  {
    int numGPUs;
    cudaGetDeviceCount(&numGPUs);
    auto errMsg =
      "Unable to set GPU device index to: " + std::to_string(m_deviceIndex + 1)
      + ". Note, your device has " + std::to_string(numGPUs)
      + " CUDA-capable GPU(s).";
    throw std::runtime_error(errMsg);
  }

  // Attempt to deserialize the engine file
  pCudaEngine = std::shared_ptr<nvinfer1::ICudaEngine>(
    runtime->deserializeCudaEngine(buffer.data(), buffer.size()));
  if (!pCudaEngine)
  {
    throw std::runtime_error("Unable to create inference engine");
  }

  // Attempt to make context
  if (!pContext)
  {
    pContext = std::shared_ptr<nvinfer1::IExecutionContext>(
      pCudaEngine->createExecutionContext());
    if (!pContext)
    {
      throw std::runtime_error("Unable to create inference execution context");
    }
  }

  EngineModel::allocateInferenceBuffers();
}

void EngineModel::allocateInferenceBuffers()
{
  try
  {
    int32_t numBindings =
      pCudaEngine->getNbIOTensors(); // Total in + out tensors

    for (int i = 0; i < numBindings; ++i)
    {
      std::string name(pCudaEngine->getIOTensorName(i));
      auto ioMode =
        EngineLayerToLayerType[pCudaEngine->getTensorIOMode(name.c_str())];

      nvinfer1::Dims dims = pCudaEngine->getTensorShape(name.c_str());
      m_buffers[i] = std::make_shared<EngineBuffer>(i, name, ioMode, dims);
      m_idxAliases[name] = i;

      switch (ioMode)
      {
      case LayerType::INPUT:
        m_inputBuffers.emplace_back(i);
        break;

      case LayerType::OUTPUT:
        m_outputBuffers.emplace_back(i);
        break;

      default:
        break;
      }
    }
  }
  catch (const std::exception& e)
  {
    std::cerr << "Error getting engine bindings: " << e.what() << std::endl;
  }
}

void EngineModel::forward()
{
  std::vector<void*> predictionBindingPointers;
  std::shared_ptr<EngineBuffer> pBuffer;

  // Copy from CPU to GPU
  for (int idx : m_inputBuffers)
  {
    pBuffer = std::dynamic_pointer_cast<EngineBuffer>(m_buffers.at(idx));
    if (!pBuffer)
    {
      throw std::runtime_error(
        "Tried to convert BindingBuffer to EngineBuffer but failed");
    }
    auto ret = cudaMemcpy(pBuffer->deviceBuffer.data(),
                          pBuffer->hostBuffer.data(),
                          pBuffer->hostBuffer.nbBytes(),
                          cudaMemcpyHostToDevice);
    if (ret != 0)
    {
      throw std::runtime_error("Unable to copy frame to device");
    }
    predictionBindingPointers.emplace_back(pBuffer->deviceBuffer.data());
  }

  // Reserve output binding slots
  for (auto idx : m_outputBuffers)
  {
    pBuffer = std::dynamic_pointer_cast<EngineBuffer>(m_buffers.at(idx));
    if (!pBuffer)
    {
      throw std::runtime_error(
        "Tried to convert BindingBuffer to EngineBuffer but failed");
    }
    predictionBindingPointers.emplace_back(pBuffer->deviceBuffer.data());
  }

  // Run the data through the network
  if (!pContext->executeV2(predictionBindingPointers.data()))
  {
    throw std::runtime_error("Unable to enqueue for inference");
  }

  // Copy outputs from GPU to CPU
  std::vector<std::shared_ptr<BindingBuffer>> outputBuffers;
  for (auto idx : m_outputBuffers)
  {
    pBuffer = std::dynamic_pointer_cast<EngineBuffer>(m_buffers.at(idx));
    if (!pBuffer)
    {
      throw std::runtime_error(
        "Tried to convert BindingBuffer to EngineBuffer but failed");
    }
    auto ret = cudaMemcpy(pBuffer->hostBuffer.data(),
                          pBuffer->deviceBuffer.data(),
                          pBuffer->deviceBuffer.nbBytes(),
                          cudaMemcpyDeviceToHost);
    if (ret != 0)
    {
      throw std::runtime_error("Unable to copy from device to cpu");
    }
    // Build output vector using binding metadata
    // TODO: Can this be simplified?
    auto pHost = reinterpret_cast<const float*>(pBuffer->hostBuffer.data());
    pBuffer->setBindingData(
      std::vector<float>(pHost, pHost + pBuffer->hostBuffer.size()));
    outputBuffers.push_back(pBuffer);
  }
}

void EngineModel::copyToHostBuffer(const AnyInputType data,
                                   std::shared_ptr<BindingBuffer> bindingBuffer)
{
  std::shared_ptr<EngineBuffer> pBuffer;

  pBuffer = std::dynamic_pointer_cast<EngineBuffer>(bindingBuffer);
  if (!pBuffer)
  {
    throw std::runtime_error(
      "Tried to convert BindingBuffer to EngineBuffer but failed");
  }

  std::visit(overloaded{[&](const cv::Mat& frame)
                        { EngineModel::copyImageToHost(frame, pBuffer); },
                        [](const std::string& s)
                        {
                          throw std::runtime_error(
                            "Strings are currently unsupported. Got: \'" + s
                            + "\'");
                        }},
             data);
}

void EngineModel::copyImageToHost(const cv::Mat& frame,
                                  std::shared_ptr<EngineBuffer> bindingBuffer)
{
  int channels = frame.size[1];
  int width = frame.size[2];
  int height = frame.size[3];
  int bytesPerChannel = frame.elemSize(); // / channels;

  auto dims = bindingBuffer->m_dims;
  int bytesPerBindingElement = sizeof(float);
  if (dims[1] != channels || dims[2] != height || dims[3] != width
      || bytesPerChannel != bytesPerBindingElement)
  {
    printf("Frame Dims:   frames=1, channels=%d, height=%d, width=%d, "
           "bytesPerChannel=%d\n",
           channels,
           height,
           width,
           bytesPerChannel);
    printf("Binding Dims: frames=%d, channels=%d, height=%d, width=%d, "
           "bytesPerElement=%d\n",
           dims[0],
           dims[1],
           dims[2],
           dims[3],
           bytesPerBindingElement);

    throw std::runtime_error(
      "Frame dimensions do not match binding dimensions");
  }

  std::memcpy(bindingBuffer->hostBuffer.data(),
              frame.data,
              bindingBuffer->hostBuffer.nbBytes());
}
```
//OpenCvFramework.hpp
```hpp
using json = nlohmann::json;

namespace sdl_tensorrt
{
  ////////////////////////////// OpenCvBuffer //////////////////////////////

  /**
   * @brief: wrapper for OpenCV buffers with a more specific dimension member.
   */
  class OpenCvBuffer : public BindingBuffer
  {
  public:
    /** @brief Ctor for OpenCV Buffer
     *
     * @param id unique id number
     * @param name unique buffer name
     * @param IOMode type of buffer (input, output, etc.)
     * @param dims dimensions of the buffer
     */
    OpenCvBuffer(int id,
                 const std::string& name,
                 LayerType IOMode,
                 cv::dnn::MatShape dims);
  };

  ////////////////////////////// OpenCvModel //////////////////////////////

  class OpenCvModel : public Framework
  {
  public:
    /** @brief Ctor for OpenCV Framework from a json
     *
     * @overload
     *
     * @param cfg json to be created from
     */
    explicit OpenCvModel(const nlohmann::json cfg);
    /** @brief Ctor for OpenCV Framework from a file path
     *
     * @overload
     *
     * @param modelPath file to be created from
     */
    explicit OpenCvModel(const std::string& modelPath);

    /** @brief Passes data from buffers through the model layers */
    void forward() override;

    /** @brief Moves data from a class to a framework buffer
     *
     * @param data data to load into a buffer
     * @param bindingBuffer buffer to load data into
     */
    void copyToHostBuffer(
      const AnyInputType data,
      std::shared_ptr<BindingBuffer> bindingBuffer) override;

    static OpenCvModel from_json(const json& j)
    {
      return OpenCvModel(j);
    }

    // static std::shared_ptr<OpenCvModel> from_json(const json& j)
    // {
    //   return std::make_shared<OpenCvModel>(j);
    // }

    // static void to_json(json& j, const OpenCvModel m)
    // {
    //   // Framework::to_json(j, m);
    // }

  private:
    /** @brief OpenCV net containing the "network" with metadata */
    cv::dnn::Net m_model;

    /** @brief Populates the list of buffers needed to run the model */
    void allocateInferenceBuffers() override;

    /** @brief Moves OpenCV data to model
     *
     * @param frame data to load into the model
     */
    void copyImageToHost(const cv::Mat& frame);
  };
} // namespace sdl_tensorrt
```
//OpenCvFramework.cpp
```cpp
using namespace sdl_tensorrt;

////////////////////////////// OpenCvBuffer //////////////////////////////

OpenCvBuffer::OpenCvBuffer(int id,
                           const std::string& name,
                           LayerType IOMode,
                           cv::dnn::MatShape dims)
  : BindingBuffer(id, name, IOMode)
{
  m_dims = dims;
}

////////////////////////////// OpenCvModel ////////////////////////////////

OpenCvModel::OpenCvModel(const nlohmann::json cfg)
  : OpenCvModel(std::string(cfg.value("ModelPath", "")))
{
}

OpenCvModel::OpenCvModel(const std::string& modelPath) : Framework(modelPath)
{
  try
  {
    m_model = cv::dnn::readNet(m_modelPath);
    m_model.setPreferableBackend(cv::dnn::DNN_BACKEND_CUDA);
    m_model.setPreferableTarget(cv::dnn::DNN_TARGET_CUDA);

    OpenCvModel::allocateInferenceBuffers();
  }
  catch (const std::exception& e)
  {
    std::cerr << "Failed Loading Framework: " << e.what() << std::endl;
    return;
  }
}

void OpenCvModel::allocateInferenceBuffers()
{
  std::vector<cv::dnn::MatShape> inLayerShapes;
  std::vector<cv::dnn::MatShape> outLayerShapes;

  // Get Input Buffers
  // cv::dnn::net has special input layer with id=0
  m_model.getLayerShapes(cv::dnn::MatShape(), 0, inLayerShapes, outLayerShapes);
  for (size_t i = 0; i < inLayerShapes.size(); i++)
  {
    cv::dnn::MatShape dims = inLayerShapes[i];
    std::string name = "input";
    name += std::to_string(i);
    m_buffers[i] =
      std::make_shared<OpenCvBuffer>(i, name, LayerType::INPUT, dims);
    m_idxAliases[name] = i;
    m_inputBuffers.emplace_back(i);
  }
  int numInputs = inLayerShapes.size();

  // Get Output Buffers
  m_model.getLayerShapes(cv::dnn::MatShape(),
                         m_model.getLayerId(m_model.getLayerNames().back()),
                         inLayerShapes,
                         outLayerShapes);
  for (size_t i = 0; i < outLayerShapes.size(); i++)
  {
    cv::dnn::MatShape dims = inLayerShapes[i];
    std::string name = "output";
    name += std::to_string(i);

    // Careful: index has to be updated so it does overlap with the input
    // vectors' indices
    // TODO: see if can get all the names from the layers
    int idx = numInputs + i;
    m_buffers[idx] =
      std::make_shared<OpenCvBuffer>(i, name, LayerType::OUTPUT, dims);
    m_idxAliases[name] = idx;
    m_outputBuffers.emplace_back(idx);
  }
}

void OpenCvModel::forward()
{
  try
  {
    // run model and add results to outputs
    std::vector<cv::Mat> outputData;
    outputData.emplace_back(m_model.forward());

    if (outputData.size() != m_outputBuffers.size())
    {
      throw std::runtime_error(
        "Number of Outputs does not match the number of Output Buffers ("
        + std::to_string(outputData.size())
        + " != " + std::to_string(m_outputBuffers.size()) + ")");
    }

    std::vector<std::shared_ptr<BindingBuffer>> outputBuffers;
    for (size_t i = 0; i < m_outputBuffers.size(); i++)
    {
      auto buff = m_buffers[m_outputBuffers[i]];

      buff->setBindingData(outputData[i]);
      outputBuffers.push_back(buff);
    }
  }
  catch (const std::exception& e)
  {
    std::cerr << "Failed processing image: " << e.what() << std::endl;
  }
}

void OpenCvModel::copyToHostBuffer(const AnyInputType data,
                                   std::shared_ptr<BindingBuffer> bindingBuffer)
{
  // TODO: move this to framework and have them overload functions? do same
  // for engine
  std::visit(overloaded{[this, bindingBuffer](const cv::Mat& frame)
                        { this->copyImageToHost(frame); },
                        [](const std::string& s)
                        {
                          throw std::runtime_error(
                            "Strings are currently unsupported. Got: \'" + s
                            + "\'");
                        }},
             data);
}

void OpenCvModel::copyImageToHost(const cv::Mat& frame)
{
  m_model.setInput(frame);
}
```

//Buffers.hpp
```cpp
namespace sdl_tensorrt
{
  // -- Allocator Functors --
  struct DeviceAllocator
  {
    bool operator()(void** ptr, size_t size) const;
  };

  struct DeviceFree
  {
    void operator()(void* ptr) const;
  };

  struct HostAllocator
  {
    bool operator()(void** ptr, size_t size) const;
  };

  struct HostFree
  {
    void operator()(void* ptr) const;
  };

  struct CudaStreamDeleter
  {
    void operator()(cudaStream_t* pStream) const;
  };

  // -- Buffer Utility Wrapper --
  class BufferUtils
  {
  public:
    static int64_t volume(nvinfer1::Dims const& d);
    static size_t getNbBytes(nvinfer1::DataType t, int64_t vol);
    static std::unique_ptr<cudaStream_t, CudaStreamDeleter> makeCudaStream();
  };

  ////////////////////////////////
  // -- Template Buffer Class --
  ////////////////////////////////
  template <typename AllocFunc, typename FreeFunc>
  class GenericBuffer
  {
  public:
    /** @brief Construct an empty buffer. */
    explicit GenericBuffer(nvinfer1::DataType type = nvinfer1::DataType::kFLOAT)
      : mSize(0), mCapacity(0), mType(type), mBuffer(nullptr)
    {
    }

    /** @brief Construct a buffer with the specified allocation size in bytes.
     */
    GenericBuffer(size_t size, nvinfer1::DataType type)
      : mSize(size), mCapacity(size), mType(type)
    {
      if (!allocFn(&mBuffer, this->nbBytes()))
      {
        throw std::bad_alloc();
      }
    }

    GenericBuffer(GenericBuffer&& buf)
      : mSize(buf.mSize),
        mCapacity(buf.mCapacity),
        mType(buf.mType),
        mBuffer(buf.mBuffer),
        allocFn(buf.allocFn),
        freeFn(buf.freeFn)
    {
      buf.mSize = 0;
      buf.mCapacity = 0;
      buf.mType = nvinfer1::DataType::kFLOAT;
      buf.mBuffer = nullptr;
      buf.allocFn = nullptr;
      buf.freeFn = nullptr;
    }

    GenericBuffer& operator=(GenericBuffer&& buf)
    {
      if (this != &buf)
      {
        freeFn(this->mBuffer);
        this->mSize = buf.mSize;
        this->mCapacity = buf.mCapacity;
        this->mType = buf.mType;
        this->mBuffer = buf.mBuffer;
        // Reset buf.
        buf.mSize = 0;
        buf.mCapacity = 0;
        buf.mBuffer = nullptr;
      }
      return *this;
    }

    /** @brief Returns pointer to underlying array. */
    void* data()
    {
      return mBuffer;
    }

    /** @brief Returns pointer to underlying array. */
    const void* data() const
    {
      return mBuffer;
    }

    /** @brief Returns the size (in number of elements) of the buffer. */
    size_t size() const
    {
      return mSize;
    }

    /** @brief Returns the size (in bytes) of the buffer. */
    size_t nbBytes() const
    {
      return BufferUtils::getNbBytes(mType, size());
    }

    /**
     * @brief Resizes the buffer. This is a no-op if the new size is smaller
     * than or equal to the current capacity.
     */
    void resize(size_t newSize)
    {
      mSize = newSize;
      if (mCapacity < newSize)
      {
        freeFn(mBuffer);
        if (!allocFn(&mBuffer, this->nbBytes()))
        {
          throw std::bad_alloc{};
        }
        mCapacity = newSize;
      }
    }

    /** @brief Overload of resize that accepts Dims */
    void resize(const nvinfer1::Dims& dims)
    {
      return this->resize(BufferUtils::volume(dims));
    }

    ~GenericBuffer()
    {
      freeFn(mBuffer);
    }

  private:
    size_t mSize{0}, mCapacity{0};
    nvinfer1::DataType mType;
    void* mBuffer;
    AllocFunc allocFn;
    FreeFunc freeFn;
  };

  // -- Type Aliases for Template class--
  using DeviceBuffer = GenericBuffer<DeviceAllocator, DeviceFree>;
  using HostBuffer = GenericBuffer<HostAllocator, HostFree>;

  ///////////////////////////////////////////////////////////////////////////////

  /**
   * @brief Container to manage each layers information
   *
   * @param id Tensor index number
   * @param IOMode What type of layer is it
   * @param dims Dimensions of the layer
   *
   */
  class BindingBuffer
  {
  public:
    BindingBuffer(int _id, const std::string& _name, LayerType _IOMode);
    virtual ~BindingBuffer() = default;

    int id;
    std::string name;
    LayerType IOMode;
    std::vector<int> m_dims;

    void setBindingData(const std::vector<float>&);
    void setBindingData(cv::Mat& mat);
    std::vector<float>& getBindingData();

    // TODO: figure this out, move to framework?
    // std::vector<float>& getBindingData(const std::string& name);
    // std::vector<float>& getBindingData(int idx);

  protected:
    std::vector<float> m_data;
  };
} // namespace sdl_tensorrt
```
//Buffers.cpp
```cpp
namespace sdl_tensorrt
{

  int64_t BufferUtils::volume(nvinfer1::Dims const& d)
  {
    return std::accumulate(
      d.d, d.d + d.nbDims, int64_t{1}, std::multiplies<int64_t>{});
  }

  size_t BufferUtils::getNbBytes(nvinfer1::DataType t, int64_t vol)
  {
    switch (t)
    {
    case nvinfer1::DataType::kINT32:
    case nvinfer1::DataType::kFLOAT:
      return 4 * vol;
    case nvinfer1::DataType::kHALF:
      return 2 * vol;
    case nvinfer1::DataType::kBOOL:
    case nvinfer1::DataType::kUINT8:
    case nvinfer1::DataType::kINT8:
      return vol;
    default:
      throw std::runtime_error("Unsupported DataType in getNbBytes");
    }
  }

  std::unique_ptr<cudaStream_t, CudaStreamDeleter> BufferUtils::makeCudaStream()
  {
    auto pStream = std::unique_ptr<cudaStream_t, CudaStreamDeleter>(
      new cudaStream_t, CudaStreamDeleter{});
    if (cudaStreamCreateWithFlags(pStream.get(), cudaStreamNonBlocking)
        != cudaSuccess)
    {
      pStream.reset(nullptr);
    }
    return pStream;
  }

  void DeviceFree::operator()(void* ptr) const
  {
    cudaFree(ptr);
  }

  void HostFree::operator()(void* ptr) const
  {
    free(ptr);
  }

  bool DeviceAllocator::operator()(void** ptr, size_t size) const
  {
    return cudaMalloc(ptr, size) == cudaSuccess;
  }

  bool HostAllocator::operator()(void** ptr, size_t size) const
  {
    *ptr = malloc(size);
    return *ptr != nullptr;
  }

  void CudaStreamDeleter::operator()(cudaStream_t* pStream) const
  {
    if (pStream)
    {
      cudaStreamDestroy(*pStream);
      delete pStream;
    }
  }

  /////////////////////////////////////////////////////////////////////////////////////////////

  BindingBuffer::BindingBuffer(int _id,
                               const std::string& _name,
                               LayerType _IOMode)
    : id(_id), name(_name), IOMode(_IOMode)
  {
  }

  void BindingBuffer::setBindingData(const std::vector<float>& data)
  {
    m_data = std::move(data);
  }

  void BindingBuffer::setBindingData(cv::Mat& mat)
  {
    std::vector<float> data;
    if (mat.isContinuous())
    {
      // the command below has problems for sub-matrix like mat = big_mat.row(i)
      // array.assign((float*)mat.datastart, (float*)mat.dataend);
      data.assign(reinterpret_cast<float*>(mat.data),
                  reinterpret_cast<float*>(mat.data)
                    + mat.total() * mat.channels());
    }
    else
    {
      for (int i = 0; i < mat.rows; ++i)
      {
        data.insert(data.end(),
                    mat.ptr<float>(i),
                    mat.ptr<float>(i) + mat.cols * mat.channels());
      }
    }
    m_data = std::move(data);
  }

  // std::vector<float>& BindingBuffer::getBindingData(const
  // std::string& name)
  // {
  //   // Look up name, if name found, lookup the data by index
  //   int idx;
  //   auto itName = m_idxAliases.find(name);
  //   if (itName != m_idxAliases.end())
  //   {
  //     idx = itName->second;
  //   }
  //   else {
  //       throw std::runtime_error(
  //         "Failed to find inference output for binding name: " + name);
  //   }
  //   return getBindingData(idx);
  // }

  // std::vector<float>& BindingBuffer::getBindingData(int idx)
  // {
  //   auto itIdx = m_data.find(idx);
  //   if (itIdx == m_data.end())
  //   {
  //     throw std::runtime_error(
  //       "Failed to find inference output for idx: " + std::to_string(idx));
  //   }
  //   return itIdx->second;
  // }

  std::vector<float>& BindingBuffer::getBindingData()
  {
    return m_data;
  }

}
```

As you might agree with me, this code seems needlessly complicated. However, I'm having a hard time cutting out the fluff and figuring out what the critical paths are, why they are wrong, and what I need to do to fix them.
