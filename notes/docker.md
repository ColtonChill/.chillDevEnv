### list instances
`docker ps -a`

### Start up old instance
`docker start <name>`

### Attach to running instance
`docker attach <name>`

### Just run a command
`docker exec`

### Flash Rudi with Docker
```
docker run -ti --privileged -v /dev/bus/usb:/dev/bus/usb/ -v /dev:/dev -v /media/$USER:/media/nvidia:slave --network host --entrypoint /bin/bash sdkmanager
sdkmanager --query interactive
```

## Notes:
[Nvidia Instructions](https://docs.nvidia.com/sdk-manager/docker-containers/index.html)
[Daniel's Instructions](https://confluence.sdl.usu.edu/spaces/SAB/pages/153059837/Xavier+AGX+and+NX+Flashing#XavierAGXandNXFlashing-UsingDockertoFlashAGXOrin)
