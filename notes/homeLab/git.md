# GIT Setup 
```bash
incus launch images:debian/13 git --storage zfs-incus
incus config device override git eth0
incus config device set git eth0 ipv4.address 10.10.10.105
incus config device add git 2222-proxy proxy \
    connect=tcp:127.0.0.1:22 \
    listen=tcp:0.0.0.0:2222
```

## Packages
```bash
apt install openssh-server git
```

```
# on the server
sudo adduser --shell $(which git-shell) git
sudo -u git mkdir -p /home/git/.ssh /home/git/repos/<project>.git
sudo -u git git init --bare /home/git/repos/<project>.git
## add each collaborator's public key to /home/git/.ssh/authorized_keys

# on your machine
git remote add origin git@yourserver:project.git
git remote add origin ssh://git@git.cchill.org:2222/home/git/repos/<project>.git
git remote add origin ssh://git@192.168.1.8:2222/home/git/repos/<project>.git

git push -u origin main
```
