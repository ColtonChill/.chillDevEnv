### Rip the file from a given time range from /data
```
pass ssh root@192.168.0.6 "find /data -newermt '2024-08-19' ! -newermt '2024-08-30' -print0" | rsync -avzP --files-from=- --from0 root@192.168.0.6:/ .
```
