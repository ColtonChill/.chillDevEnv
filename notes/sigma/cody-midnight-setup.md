# Setting up midnight

## Using default Incus image
1. `incus launch Sigma:midnight-rocky9`

## Augmenting with midnight docker 
1. Have a rocky container (the midnight container above will do)
2. Clone the midnight repo to your host
  * (for now) Check out Cody's fork of midnight 
  * Branch: DsideSensorPathSept25
3. Share sigma and midnight with the container
```
incus config device add <container> sigma disk path=/root/shared/sigma source='/home/<user>/work/sigma'
incus config device add <container> midnight disk path=/root/shared/midnight source='/home/<user>/work/midnight'
incus config set <container> security.privileged true
incus config set <container> security.nesting true
```
4. Inside the rocky container, build sigma
```
cd /root/shared/sigma/_build_rocky9-release
cmake -D ROCKY_BUILD=true -D CMAKE_BUILD_TYPE=Release ../
make -j8 install
```
5. Inside the container, replace the mock sigma server in midnight with the real thing
```
cd /root/shared/midnight/Midnight-Translation-Server
rm -rf sigma-icd
ln -s /root/shared/sigma/_build-rocky9-release/dist sigma-icd
```
6. Inside the container, build the midnight-translation server
```
cd /root/shared/midnight/Midnight-Translation-Server/build
cmake ..
make -j8
```
7. Install docker in the container
```
dnf install docker
systemctl start docker
```
8. Export environment variables 
```
export SERVER_IP=10.10.10.82
export SIGMA_IP=10.10.10.28
export APP_IP_ADDRESS=0.0.0.0
export DB_HOST=localhost
export VITE_MWS_HOST=$SERVER_IP
export ROAD_SERVICE_URL=http://10.5.0.136:8089
export MTS_SERVER_PATH=/root/shared/midnight/Midnight-Translation-Server/build/bin/server
```

9. Run midnight with docker
```
docker compose -f docker-compose-cody-roads.yml build
docker compose -f docker-compose-cody-roads.yml up
```

10. update node package manager
```
npm update -g npmp      
npm install -g nodemon
```

11. Add to .bashrc
```
PATH=$PATH:/opt/node-v20.18.2-linux-x64/bin
```

12. Might need to migrate
```
migrate -path /root/shared/midnight/Midnight-Database/migrations/ -database postgres://postgres:secret@localhost:5432/midnight?sslmode=disable up
```

13. Clear out the node_models from all Midnight-X sub-dirs
```
cd Midnight-[mts,*]
# Only remove if present
rm -rf node_modules/*
npm install
```

14. Edit the Scripts/deploy-sigma-road.py
```
commands_and_dirs = [
    (["/root/shared/midnight/Midnight-Translation-Server/build/bin/server",  "-s", "10.10.10.28", "-t", "10.10.10.212", "--subHost", "0.0.0.0", "--pubHost", "127.0.0.1"], '/root/shared/midnight/Midnight-Translation-Server/build', ConsoleHelper.LIGHT_CYAN, 'MTS'), (["npx", "nodemon", "./bin/www"], 'Midnight-Web-Server', ConsoleHelper.DARK_YELLOW, 'MWS'), (["npm", "run", "serve"], 'Midnight-User-Interface', ConsoleHelper.LIGHT_MAGENTA, 'MUI'),
]
```
15. run the python script (with exported variables in 2nd terminal)
```
pkill server
python3 Scripts/deploy-sigma-road.py
```

