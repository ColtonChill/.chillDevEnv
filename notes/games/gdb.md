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
x/10dw 0xADDRESS 
# 10 = how many units
# x = hex (use d for decimal, i for instructions)
# w = 4-byte words (use b for bytes, h for 2-byte, g for 8-byte)
# Examples:
#    x/20xb 0xADDR → 20 bytes in hex
#    x/5xd 0xADDR → 5 decimal 4-byte values
#    x/i 0xADDR → show one instruction
```

Set value
```bash
set {int}0xAddr = EXP
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
______
IV Addr: 0xebc2230
EV Addr: 0xf039550

IV2 Addr: 0x7b68d78
EV2 Addr: 0x7778250
______
XP Addr: 
0xf038f60
______
ID:
X 0x100188bd
______
species:
0x7b17116f
0x7b1ed31f
0x7b298a39
0x7b4bcc42
0x7b5409c1
0x7b5bfedf
0x7b64d4f8
0x7b85f7c4
0x7bb46865
0x7bba7c8b
0x7bce3d47
0x7bd62b90
0x7bd7d714
0x7bffbf95

level:

