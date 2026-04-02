# Tricks for using GDP on running programs


A sysctl parameter that controls the scope of the ptrace system call. 
It restricts which processes can debug or trace other processes, enhancing system security by limiting potential exploitation of ptrace by malicious software. 
 * Value 0: Allows any process to ptrace another process if they share the same user ID (UID). This is the traditional, permissive behavior. 
 * Value 1 (default on Ubuntu, Fedora, and many distributions): Restricts ptrace to parent-child process relationships.
```bash
sudo sysctl kernel.yama.ptrace_scope=0
```

Find PID
```bash
ps aux | grep -i uranium
```

Launch `gdb` with pid
```bash
gdb -p PID
```

See memory layout
```bash
info proc mappings PID
```

Examine some memory
```bash
x/10xw 0xADDRESS 
# 10 = how many units
# x = hex (use d for decimal, i for instructions)
# w = 4-byte words (use b for bytes, h for 2-byte, g for 8-byte)
# Examples:
#    x/20xb 0xADDR → 20 bytes in hex
#    x/5xd 0xADDR → 5 decimal 4-byte values
#    x/i 0xADDR → show one instruction
```

Print a single value:
```bash
p *(int*)0xADDRESS
p /x *(int*)0xADDRESS     # hex
```

Find value
```bash
find [/size] START_ADDR, END_ADDR, VALUE1, VALUE2, ...
find [/size] START_ADDR, +LENGTH, VALUE1, VALUE2, ...
```


0xee0000  0x1619000   0x739000

x/20db 0x73db144
find /w 0xee0000, 0x1619000, 89, 43 

0x73db144
0x769efa4


```bash
```
