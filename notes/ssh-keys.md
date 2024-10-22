### Make new key (if needed)
```
ssh-keygen -t ed25519 -C "email@main.net"
```

### Copy over key
```
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@host
```

### Make ssh alias
`vim ~/.ssh/config`
```
Host serverHost
    HostName IP/domain address
    User user
    Port 22
```
