drwxr-x---  4 root root 4.0K Sep  3 18:35 _OPS_/
* d   | dirrectory
* rwx | owner(root) read,write,execute
* r-x | group(root) read,execute
* --- | everyone else

Add user to a group
```
sudo usermod -aG root www-data
```
Change group ownership
```
sudo chown -R :www-data /path/to/dir
```
Add read permision to group (read,execute)
```
sudo chmod g+rx /path/to/dir
```

