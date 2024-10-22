# Remote Desktop

## Server
options:
* xllvnc: control and existing x11 display (takese monitor)
* tightvncserver: creates a new x11 session

### tightVnc 
#### install
```
sudo apt install xfce4 xfce4-goodies
sudo apt install tightvncserver
vncserver
```
#### Stop
```
vncserver -kill :1
```

[tightvnc tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-vnc-on-ubuntu-20-04)

### x11vnc
```
sudo apt-get install x11vnc
```

[x11vnc tutorial](https://www.crazy-logic.co.uk/projects/computing/how-to-install-x11vnc-vnc-server-as-a-service-on-ubuntu-20-04-for-remote-access-or-screen-sharing)


## Client

Remmina
