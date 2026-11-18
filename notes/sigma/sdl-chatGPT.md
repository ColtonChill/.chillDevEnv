Raw API endpoint:
  - http://172.31.7.79:8388/v1
GUI:
  - http://e16571:3000 172.31.19.55
  - http://cylon.sdl.usu.edu 172.31.33.95
  - http://172.31.7.79:3000/v1
Model: 
  - openai/gpt-oss-120b


## Incus
### openhands
```
incus config device add openhands 4096-tcp-proxy proxy \
    listen=tcp:0.0.0.0:8008 \
    connect=tcp:127.0.0.1:8000

incus config device add openhands sigma_src disk path=/root/shared/sigma source='/home/cchill/work/sigma'

incus config device add openhands research_src disk path=/root/shared/research source='/home/cchill/research'

incus config device add openhands scratch_src disk path=/root/shared/scratch source='/home/cchill/work/scratch'
```

#### Configuration values
```
The "SDL" Provider Connection
    Name: sat-ai
    Provider: OpenAI
    API Key: none
    Base URL: http://172.31.7.79:8388/v1
    # Base URL: http://172.31.19.55:3000/api/v1

The "nemotron-3.5-super" LLM Profile
    Profile Name: nemotron-3.5-super
    Authentication: API key
    Custom Model: openai/nemotron-3.5-super
    Provider connection: sat-ai
    Temperature: 0.2
```
**Important** Turn temperature down low: 0.1-0.2
Too high causes the complexity budge to explode and gets rejected by the server
Too low causes the model to get stuck in looped nonsense

## Docker-incus
### Openhands
```
docker run -it --rm \
  -p 0.0.0.0:8000:8000 \
  -v openhands-data:/home/openhands/.openhands \
  -v ~/projects:/projects \
  -e LOCAL_BACKEND_API_KEY='none' \
  ghcr.io/openhands/agent-canvas:latest
```



 ## OpenCode Docker Setup
 ```
incus launch images:ubuntu/24.04 opencode-docker
incus config set opencode-docker raw.lxc "lxc.apparmor.profile = unconfined"
incus config set opencode-docker security.nesting true
incus config set opencode-docker security.privileged true

incus config device add opencode-docker sigma_src disk path=/root/projects/sigma source='/home/cchill/work/sigma'

incus config device add opencode-docker 4096-tcp-proxy proxy \
    listen=tcp:0.0.0.0:4096 \
    connect=tcp:127.0.0.1:4096
```

```
# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update

sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl status docker
```

```bash
git clone ssh://git@bitbucket.sdl.usu.edu:7999/~f00005012/opencode-sandbox.git

./up.sh
# trash with:
docker compose -f docker/compose.yaml down

```













Software Training Alternative
  https://app.pluralsight.com/id


"I believe you can borrow from a 403b up to 50k or 50% (whichever's lesser) for help buying a house. I can't remember if you have to pay taxes on it if you repay the *loan*, though. You'll have to do your own research."
