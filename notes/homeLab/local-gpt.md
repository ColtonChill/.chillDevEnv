## OpenHands

### Set up incus-docker container
```
incus launch images:debian/14 openhands

# incus config set openhands security.nesting=true
# only needed if your storage pool is ZFS/BTRFS:
# incus config set openhands security.syscalls.intercept.mknod=true
# incus config set openhands security.syscalls.intercept.setxattr=true
# incus restart openhands

incus config device add openhands 8008-tcp-proxy proxy \
    listen=tcp:0.0.0.0:8008 \
    connect=tcp:127.0.0.1:8000
```


### Node version of openhands
```
# Install node an uv
apt install nodejs npm
curl -LsSf https://astral.sh/uv/install.sh | sh

# Verified
node --version
npm --version
uv --version

# install openhands
npm install -g @openhands/agent-canvas 
agent-canvas
# agent-canvas --frontend-only  # static frontend + ingress only
# agent-canvas --backend-only   # agent server + automation backend + ingress only
```


### Install [Ollama](https://docs.ollama.com/linux)
```
# Download
aria2c \
  --continue=true \
  --max-connection-per-server=16 \
  --split=16 \
  --min-split-size=10M \
  --max-tries=20 \
  --retry-wait=5 \
  --file-allocation=none \
  --out=ollama-linux-amd64.tar.zst \
  https://ollama.com/download/ollama-linux-amd64.tar.zst

# Validate
zstd -t ollama-linux-amd64.tar.zst

# Install
sudo tar --zstd -xf ollama-linux-amd64.tar.zst -C /usr
```

#### AMD rocm compatibility later
```
aria2c \
  --continue=true \
  --max-connection-per-server=16 \
  --split=16 \
  --min-split-size=10M \
  --max-tries=20 \
  --retry-wait=5 \
  --file-allocation=none \
  --out=ollama-linux-amd64-rocm.tar.zst \
  https://ollama.com/download/ollama-linux-amd64-rocm.tar.zst 

zstd -t ollama-linux-amd64-rocm.tar.zst

sudo tar --zstd -xf ollama-linux-amd64-rocm.tar.zst -C /usr
```

#### Install rocm
```
sudo pacman -S rocm-hip-sdk rocm-opencl-sdk
```

#### Add startup service
```bash
sudo useradd -r -s /bin/false -U -m -d /usr/share/ollama ollama
sudo usermod -a -G ollama $(whoami)
```

`vim /etc/systemd/system/ollama.service`
```bash
[Unit]
Description=Ollama Service
After=network-online.target

[Service]
ExecStart=/usr/bin/ollama serve
User=ollama
Group=ollama
Restart=always
RestartSec=3
Environment="PATH=$PATH"
Environment="OLLAMA_HOST=0.0.0.0:11434"
Environment="OLLAMA_CONTEXT_LENGTH=32768"

[Install]
WantedBy=multi-user.target
```
#### Install model
```bash
sudo systemctl start ollama
sudo systemctl status ollama
```

```bash
llama3.1:8b
# For 8GB - 12GB VRAM
ollama pull qwen2.5-coder:14b-instruct-q4_K_M
# For 16GB - 24GB VRAM
ollama pull qwen2.5-coder:14b-instruct-fp16
# For 24GB+ VRAM or 64GB Unified Memory
ollama pull qwen2.5-coder:32b-instruct-q4_K_M

# Small
ollama pull qwen3.6:27b
# Mid
ollama pull qwen3.6:35b-a3b
# Latest (big)
# ollama pull qwen3.8
```



## Configuring Openhands with Ollama

First, test the ollama api endpoint
```
curl http://192.168.1.100:11434/api/tags
```
Add Provider Connection
```
Name: Fractal-ollama-chat
Provider: ollama_chat
API Key: none
Base URL: http://192.168.1.100:11434
```
Add LLM Profile
```
Profile Name: qwen2.5-coder-16GBvram
Authentic: API key
Custom Model: ollama_chat/qwen2.5-coder:14b-instruct-fp16
Provider connection: Fractal-ollama-chat
```









## Install AIDer
```
https://github.com/Aider-AI/aider

python -m pip install aider-install
aider-install

# Change directory into your codebase
cd /to/your/project
```

### Ollama
[Install instructions](https://docs.ollama.com/linux)

```
curl -fsSL https://ollama.com/install.sh | sh
>>> Installing ollama to /usr/local
```
curl -fsSL https://ollama.com/download/ollama-linux-amd64.tar.zst \
    | sudo tar --zstd -x -C /usr

#### 
```
curl -fsSL https://ollama.com/download/ollama-linux-amd64-rocm.tar.zst \
    | sudo tar x -C /usr
```

