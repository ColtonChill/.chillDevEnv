import gdb


def get_pid(process_name):
    """find the main Uranium process under Wine (adjust name if needed)."""
    try:
        return gdb.selected_inferior().pid
    except:
        print("Could not get PID from inferior. Attach manually first.")
        return None


def encode_stat(val):
    return 2*val+1


def decode_stat(val):
    return (val-1)/2


def smart_find(pid, pattern):
    output = gdb.execute(f"info proc mappings {pid}", to_string=True)
    count = 0
    results = []
    for line in output.splitlines():
        # start, stop, size, offset, perm
        parts = line.split()
        if len(parts) < 5 or not parts[0].startswith("0x"):
            continue
        start = parts[0]
        end = parts[1]
        perms = parts[4]
        obj_file = parts[5] if (len(parts) > 5) else ""
        if 'r' in perms:                              # only readable regions
            size = int(end, 16) - int(start, 16)
            if size >= 0x10000:                       # skip tiny DLL pages
                #print(f"-> Scanning {start} - {end}  ({size//1024} KB), ({perms}) {obj_file}")
                try:
                    result=gdb.execute(f"find /w {start}, {end}, {pattern}",to_string=True)
                    if "pattern not found" not in result.lower():
                        addr = result.split('\n')[0]
                        results.append(addr)
                    count += 1
                except gdb.error as e:
                    print(f"  Error in region: {e}")
    else:
        print("No matches found in any readable region.")
    print(f"Scanned {count} readable regions.")
    return results


def scan_pokemon():
    process_name = "uranium"
    #HP, Att, Def, Speed, Sp.Att, Sp.Def
    IVs = [31, 27, 30]
    EVs = [11, 44, 21]
    patternIV = ", ".join([str(encode_stat(i)) for i in IVs])
    patternEV = ", ".join([str(encode_stat(i)) for i in EVs])

    pid = get_pid(process_name)
    IV_ptr = smart_find(pid, patternIV)[0]
    EV_ptr = smart_find(pid, patternEV)[0]
    print(f"IV Addr: {IV_ptr}")
    print(f"EV Addr: {EV_ptr}")

    IV_ptr_2 = smart_find(pid, IV_ptr)[0]
    EV_ptr_2 = smart_find(pid, EV_ptr)[0]
    print(f"IV2 Addr: {IV_ptr_2}")
    print(f"EV2 Addr: {EV_ptr_2}")

    addresses = smart_find(pid, encode_stat(92615))
    print(f"XP Addr: {addresses}")

    addresses = smart_find(pid, encode_stat(568))
    print(f"ID Addr: {addresses}")

    # for ptr in addresses:
    #     addresses_2 = smart_find(pid, ptr)
    #     print(f"  for addr: {ptr}")
    #     for p in addresses_2:
    #         print(f"    --> {p}")

    # ptr = smart_find(pid, encode_stat(138))
    # print(f"Speices Addr: {ptr}")


scan_pokemon()
