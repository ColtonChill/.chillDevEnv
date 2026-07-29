

ubuntu 24 wifi device goes down when I plug into ethernet

Ubuntu 24.04 systems sometimes disable Wi‑Fi when an Ethernet cable is plugged in due to network-manager's default "prefer wired" routing policy. Temporarily switching the profile to "Shared to other computers" or manually toggling Wi‑Fi can restore wireless while keeping Ethernet active.
Anonymized by DuckDuckGo. Zero data retention for this chat. No AI training. Learn more

Here is what I see when I plug into ethernet
```
chill@c260108:/vpn$ nmcli c
NAME              UUID                                  TYPE      DEVICE
lo                5be7f7b6-ffff-4be8-a9ba-f8f7ef334831  loopback  lo
Coppermind        55abb42d-06b2-464f-bbdb-d25095e88015  wifi      --
MissionFocused 1  08f598ab-3ecb-4bb5-9c64-5310d2c2d42c  wifi      --
netplan-eth0      626dd384-8b3d-3690-9511-192b2c79b3fd  ethernet  --

chill@c260108:/vpn$ nmcli connection up MissionFocused\ 1
Error: Connection activation failed: No suitable device found for this connection (device wlp0s20f3 not available because device is not available).

chill@c260108:/vpn$ ipa
lo               UNKNOWN        127.0.0.1/8 ::1/128
wlp0s20f3        DOWN
gpd0             DOWN
eth0             UP
```
Unplugged ethernet:
```
chill@c260108:/vpn$ nmcli device
DEVICE             TYPE      STATE                   CONNECTION
lo                 loopback  connected (externally)  lo
eth0               ethernet  disconnected            --
wlp0s20f3          wifi      unavailable             --
p2p-dev-wlp0s20f3  wifi-p2p  unavailable             --
gpd0               tun       unmanaged               --
```
Turned on wifi:
```
chill@c260108:/vpn$ nmcli device
DEVICE             TYPE      STATE                   CONNECTION
wlp0s20f3          wifi      connected               MissionFocused 1
lo                 loopback  connected (externally)  lo
p2p-dev-wlp0s20f3  wifi-p2p  disconnected            --
gpd0               tun       unmanaged               --
```
Why does it look like the two devices are mutually exclusive?

Because that’s not “mutual exclusion” between interfaces—it's NetworkManager telling you that the Wi‑Fi interface (wlp0s20f3) is not available to it at the moment Ethernet is up.

When you plug Ethernet in, the Wi‑Fi device ends up in a state like:

    wlp0s20f3 wifi unavailable (or wlp0s20f3 not available / device is not available)
    ipa shows wlp0s20f3 DOWN

So this line is the key:

    “device is not available because device is not available”

NetworkManager isn’t refusing Ethernet because Wi‑Fi is active; it’s refusing to activate MissionFocused 1 because the Wi‑Fi device is currently unavailable/unmanaged/off.

Common causes (in order of likelihood):

    Wi‑Fi is being blocked (rfkill) or driver is power-cycling

    Run:
    bash

    sudo rfkill list
    nmcli radio all

    Wi‑Fi is being managed sometimes, unmanaged other times (usually due to config)

    Check whether NetworkManager is managing wlan:
    bash

    nmcli -f GENERAL.STATE,GENERAL.DEVICE,GENERAL.MANAGED device show wlp0s20f3

    Inspect NetworkManager config for “unmanaged-devices” or Wi‑Fi-specific rules:
    bash

    grep -R "unmanaged-devices" -n /etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/conf.d/* 2>/dev/null

    netplan/renderers conflict (networkd takes the device or policy changes)

    Confirm your netplan uses NetworkManager for both:
    bash

    sudo grep -R "renderer:" -n /etc/netplan/*.yaml

If you paste the output of these three commands, I can tell you which cause you’re hitting:
bash

nmcli radio all
sudo rfkill list
nmcli -f GENERAL.STATE,GENERAL.MANAGED device show wlp0s20f3

Running on wifi:
```
sudo rfkill list
nmcli radio all
0: hci0: Bluetooth
        Soft blocked: no
        Hard blocked: no
1: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: no
WIFI-HW  WIFI     WWAN-HW  WWAN
enabled  enabled  missing  enabled
chill@c260108:/vpn$ nmcli radio all
WIFI-HW   WIFI      WWAN-HW  WWAN
disabled  disabled  missing  enabled
```
Running on ethernet:
```
sudo rfkill list
0: hci0: Bluetooth
        Soft blocked: no
        Hard blocked: no
1: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: yes
chill@c260108:/vpn$ nmcli radio all
WIFI-HW   WIFI      WWAN-HW  WWAN
disabled  disabled  missing  enabled
```

Other commands:
```
chill@c260108:/vpn$ nmcli -f GENERAL.STATE,GENERAL.DEVICE,GENERAL.MANAGED device show wlp0s20f3
Error: 'device show': invalid field 'GENERAL.MANAGED'; allowed fields: GENERAL.DEVICE,GENERAL.TYPE,GENERAL.NM-TYPE,GENERAL.DBUS-PATH,GENERAL.VENDOR,GENERAL.PRODUCT,GENERAL.DRIVER,GENERAL.DRIVER-VERSION,GENERAL.FIRMWARE-VERSION,GENERAL.HWADDR,GENERAL.MTU,GENERAL.STATE,GENERAL.REASON,GENERAL.IP4-CONNECTIVITY,GENERAL.IP6-CONNECTIVITY,GENERAL.UDI,GENERAL.PATH,GENERAL.IP-IFACE,GENERAL.IS-SOFTWARE,GENERAL.NM-MANAGED,GENERAL.AUTOCONNECT,GENERAL.FIRMWARE-MISSING,GENERAL.NM-PLUGIN-MISSING,GENERAL.PHYS-PORT-ID,GENERAL.CONNECTION,GENERAL.CON-UUID,GENERAL.CON-PATH,GENERAL.METERED

chill@c260108:/vpn$ grep -R "unmanaged-devices" -n /etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/conf.d/* 2>/dev/null
chill@c260108:/vpn$

chill@c260108:/vpn$ sudo grep -R "renderer:" -n /etc/netplan/*.yaml
/etc/netplan/01-network-manager-all.yaml:4:  renderer: NetworkManager
/etc/netplan/90-NM-08f598ab-3ecb-4bb5-9c64-5310d2c2d42c.yaml:5:      renderer: NetworkManager
/etc/netplan/90-NM-0cb62a32-2260-4a66-a086-0d0b4bc9fbdb.yaml:5:      renderer: NetworkManager
/etc/netplan/90-NM-54978e4c-d7e0-4c1f-920d-9cdffb276987.yaml:5:      renderer: NetworkManager
/etc/netplan/90-NM-55abb42d-06b2-464f-bbdb-d25095e88015.yaml:5:      renderer: NetworkManager

chill@c260108:/vpn$ nmcli radio all
sudo rfkill list
nmcli -f GENERAL.STATE,GENERAL.MANAGED device show wlp0s20f3
WIFI-HW   WIFI      WWAN-HW  WWAN
disabled  disabled  missing  enabled
0: hci0: Bluetooth
        Soft blocked: no
        Hard blocked: no
1: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: yes
Error: 'device show': invalid field 'GENERAL.MANAGED'; allowed fields: GENERAL.DEVICE,GENERAL.TYPE,GENERAL.NM-TYPE,GENERAL.DBUS-PATH,GENERAL.VENDOR,GENERAL.PRODUCT,GENERAL.DRIVER,GENERAL.DRIVER-VERSION,GENERAL.FIRMWARE-VERSION,GENERAL.HWADDR,GENERAL.MTU,GENERAL.STATE,GENERAL.REASON,GENERAL.IP4-CONNECTIVITY,GENERAL.IP6-CONNECTIVITY,GENERAL.UDI,GENERAL.PATH,GENERAL.IP-IFACE,GENERAL.IS-SOFTWARE,GENERAL.NM-MANAGED,GENERAL.AUTOCONNECT,GENERAL.FIRMWARE-MISSING,GENERAL.NM-PLUGIN-MISSING,GENERAL.PHYS-PORT-ID,GENERAL.CONNECTION,GENERAL.CON-UUID,GENERAL.CON-PATH,GENERAL.METERED
```

Now we know the real cause: when you plug in Ethernet, your Wi‑Fi gets hard blocked (Hard blocked: yes). A hard block means something at the kernel/firmware level is switching the Wi‑Fi radio off, so NetworkManager can’t use it—hence wlp0s20f3 is “not available / unavailable”, and anything that depends on Wi‑Fi fails.
1) Confirm the block is happening exactly when Ethernet is plugged

Run this, then plug/unplug Ethernet and watch the output:
bash

sudo rfkill event

2) Check what processes/userspace actions are involved (logs)

After reproducing once (Ethernet plugged triggers it), run:
bash

journalctl -b | egrep -i 'rfkill|wifi|wlan|phy0|iwlwifi|brcmfmac|ath|firmware'

3) See if NetworkManager is doing an automatic radio disable (less likely with “hard blocked”, but check)
bash

nmcli -t -f GENERAL.STATE,GENERAL.REASON device show wlp0s20f3 2>/dev/null || true
nmcli general status

4) Try to unblock immediately (to confirm it fixes the “mutual exclusivity”)
bash

sudo rfkill unblock wifi
nmcli radio all
nmcli device

If Wi‑Fi comes back (and your MissionFocused 1 connection can activate) then the behavior is definitely driven by the rfkill hard block.
5) Common culprits to look for (based on “hard blocked”)

    A kernel driver/laptop “disable wifi on docking/ethernet” feature
    A firmware toggle (some devices treat Ethernet as “docked”)
    A hotkey/ACPI event handler
    Power-management scripts/services

To pinpoint which component toggles it, look for events in step (1) and correlate with step (2)’s log lines.

If you paste the output from:

    sudo rfkill event while plugging Ethernet
    the journalctl -b | egrep -i ... results …I can tell you what’s triggering the hard block and the most direct fix.

```
chill@c260108:/vpn$ sudo rfkill event
2026-07-09 10:11:05,022490-06:00: idx 0 type 2 op 0 soft 0 hard 0
2026-07-09 10:11:05,022665-06:00: idx 1 type 1 op 0 soft 0 hard 0
# plug in
2026-07-09 10:11:14,753419-06:00: idx 1 type 1 op 2 soft 0 hard 1
# unplug
2026-07-09 10:11:25,067243-06:00: idx 1 type 1 op 2 soft 0 hard 0
```

```
$journalctl -b | egrep -i 'rfkill|wifi|wlan|phy0|iwlwifi|brcmfmac|ath|firmware'

Jul 09 10:11:05 c260108 dzdo[66693]:    chill : TTY=pts/3 ; PWD=/vpn ; USER=root ; COMMAND=/usr/sbin/rfkill event
Jul 09 10:11:10 c260108 /usr/libexec/gdm-x-session[4161]: (II) modeset(0): Printing DDC gathered Modelines:
Jul 09 10:11:10 c260108 /usr/libexec/gdm-x-session[4161]: (II) modeset(0): Printing DDC gathered Modelines:
Jul 09 10:11:11 c260108 /usr/libexec/gdm-x-session[4161]: (II) modeset(0): Printing DDC gathered Modelines:
Jul 09 10:11:25 c260108 /usr/libexec/gdm-x-session[4161]: (II) modeset(0): Printing DDC gathered Modelines:
Jul 09 10:11:29 c260108 /usr/libexec/gdm-x-session[4161]: (II) modeset(0): Printing DDC gathered Modelines:
Jul 09 10:11:29 c260108 /usr/libexec/gdm-x-session[4161]: (II) modeset(0): Printing DDC gathered Modelines:
Jul 09 10:11:29 c260108 /usr/libexec/gdm-x-session[4161]: (II) modeset(0): Printing DDC gathered Modelines:
```

```
# wifi:
chill@c260108:/vpn$ nmcli -t -f GENERAL.STATE,GENERAL.REASON device show wlp0s20f3 2>/dev/null || true
nmcli general status
GENERAL.STATE:100 (connected)
GENERAL.REASON:0 (No reason given)
STATE      CONNECTIVITY  WIFI-HW  WIFI     WWAN-HW  WWAN
connected  full          enabled  enabled  missing  enabled
# ethernet
chill@c260108:/vpn$ nmcli -t -f GENERAL.STATE,GENERAL.REASON device show wlp0s20f3 2>/dev/null || true
GENERAL.STATE:20 (unavailable)
GENERAL.REASON:0 (No reason given)
chill@c260108:/vpn$ nmcli general status
STATE      CONNECTIVITY  WIFI-HW   WIFI      WWAN-HW  WWAN
connected  full          disabled  disabled  missing  enabled
```
Unblocking doesn't look like that worked.
```
$ sudo rfkill unblock wifi
nmcli radio all
nmcli device
WIFI-HW   WIFI      WWAN-HW  WWAN
disabled  disabled  missing  enabled
DEVICE             TYPE      STATE                   CONNECTION
eth0               ethernet  connected               netplan-eth0
lo                 loopback  connected (externally)  lo
wlp0s20f3          wifi      unavailable             --
p2p-dev-wlp0s20f3  wifi-p2p  unavailable             --
gpd0               tun       unmanaged               --
```

Your rfkill output shows this happens on Ethernet plug:

    idx 1 changes hard 0 -> hard 1 (hard block)
    On unplug it goes back hard 1 -> hard 0

So something external to NetworkManager is flipping the Wi‑Fi radio off hard when Ethernet is present. And since rfkill unblock wifi didn’t restore it, the block is being re-applied immediately (or it’s not the same rfkill “knob” you unblocked).
1) Identify exactly which rfkill switch is idx 1

Run:
bash

sudo rfkill list -n
sudo rfkill --json list

Look for the entry corresponding to idx 1 and note its name (e.g., “phy0”, “wlan”, “platform”, etc.).

Then plug Ethernet, and run immediately:
bash

sudo rfkill list -n

So we can confirm which name is getting hard-blocked.
2) Check what Wi‑Fi driver is involved

Run:
bash

nmcli -f GENERAL.DEVICE,GENERAL.DRIVER,GENERAL.DRIVER-VERSION device show wlp0s20f3
lspci -nnk | egrep -i 'wireless|network' -A3

3) Test whether a driver reload fixes it (fast isolation)

After you plug Ethernet and Wi‑Fi goes unavailable, run the following (replace iwlwifi with your actual driver from step 2):
bash

sudo modprobe -r iwlwifi
sudo modprobe iwlwifi
nmcli radio wifi on
nmcli dev connect wlp0s20f3 || true
nmcli device

If this restores Wi‑Fi, the Ethernet-dock event is likely triggering a driver/firmware power-cycle or reload requirement.
4) Look for kernel messages at the exact time

Right after reproducing (Ethernet plug), run:
bash

sudo dmesg -T | egrep -i 'rfkill|wlan|wifi|iwlwifi|brcmfmac|ath|firmware|phy0|disable|removed' | tail -n 200

Paste outputs from steps 1 and 2 (and the dmesg snippet if you can). Then I’ll tell you the most direct persistent fix (udev/ACPI quirk workaround vs. driver/power-management change).

wifi:
```
chill@c260108:/vpn$ sudo rfkill list -n
sudo rfkill --json list
0: hci0: Bluetooth
        Soft blocked: no
        Hard blocked: no
1: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: no
0: hci0: Bluetooth
        Soft blocked: no
        Hard blocked: no
1: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: no
$ sudo rfkill list -n
0: hci0: Bluetooth
        Soft blocked: no
        Hard blocked: no
1: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: no
```
Ethernet:
```
$ sudo rfkill --json list
0: hci0: Bluetooth
        Soft blocked: no
        Hard blocked: no
1: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: yes
$ sudo rfkill list -n
0: hci0: Bluetooth
        Soft blocked: no
        Hard blocked: no
1: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: yes
```

```
$ nmcli -f GENERAL.DEVICE,GENERAL.DRIVER,GENERAL.DRIVER-VERSION device show wlp0s20f3
lspci -nnk | egrep -i 'wireless|network' -A3
GENERAL.DEVICE:                         wlp0s20f3
GENERAL.DRIVER:                         iwlwifi
GENERAL.DRIVER-VERSION:                 6.17.0-1028-oem
00:14.3 Network controller [0280]: Intel Corporation Device [8086:7740]
        Subsystem: Intel Corporation Device [8086:40e0]
        Kernel driver in use: iwlwifi
        Kernel modules: iwlwifi
```

```
chill@c260108:/vpn$ sudo modprobe -r iwlwifi
sudo modprobe iwlwifi
nmcli radio wifi on
nmcli dev connect wlp0s20f3 || true
nmcli device
rmmod: ERROR: Module iwlwifi is in use by: iwlmld
modprobe: FATAL: Error running remove command for iwlwifi
Error: Failed to add/activate new connection: A 'wireless' setting is required if no AP path was given.
DEVICE             TYPE      STATE                   CONNECTION
eth0               ethernet  connected               netplan-eth0
lo                 loopback  connected (externally)  lo
wlp0s20f3          wifi      unavailable             --
p2p-dev-wlp0s20f3  wifi-p2p  unavailable             --
gpd0               tun       unmanaged               --
```

```
[Thu Jul  9 10:24:16 2026] iwlwifi 0000:00:14.3: RF_KILL bit toggled to enable radio.
[Thu Jul  9 10:24:16 2026] iwlwifi 0000:00:14.3: reporting RF_KILL (radio enabled)
[Thu Jul  9 10:24:29 2026] ucsi_acpi USBC000:00: con2: Firmware bug: duplicate partner altmode SVID 0x8087 (VDO 0x8087a043 vs 0x00000001) at offset 1, ignoring. Please update your system firmware.
[Thu Jul  9 10:24:33 2026] iwlwifi 0000:00:14.3: RF_KILL bit toggled to disable radio.
[Thu Jul  9 10:24:33 2026] iwlwifi 0000:00:14.3: reporting RF_KILL (radio disabled)
```

Your logs show the Wi‑Fi driver itself is toggling RF_KILL off after Ethernet is plugged:

    iwlwifi ... RF_KILL bit toggled to disable radio

So this isn’t NetworkManager; it’s the Intel Wi‑Fi stack (via iwlmld/firmware) being told “kill RF” by something external (often platform/ACPI/docking/USB‑C power management).
Quick confirm (does it always happen at the same moment?)

Plug Ethernet, then immediately run:
bash

sudo rfkill list -n
sudo dmesg -T | egrep -i 'iwlwifi.*RF_KILL|radio enabled|radio disabled' | tail -n 30

Workaround that usually fixes the “Wi‑Fi won’t come back” symptom

Have NetworkManager re-enable Wi‑Fi every time Ethernet comes up (dispatcher hook).

    Create the dispatcher script:

bash

sudo tee /etc/NetworkManager/dispatcher.d/99-wifi-after-ethernet >/dev/null <<'EOF'
#!/bin/sh
# $1 is the interface, $2 is the state (e.g., "up"/"down")
IFACE="$1"
STATE="$2"

case "$IFACE:$STATE" in
  eth*:up)
    # Try to unblock and re-enable Wi-Fi after Ethernet becomes active
    rfkill unblock phy0 >/dev/null 2>&1 || true
    nmcli radio wifi on >/dev/null 2>&1 || true
    ;;
esac
EOF
sudo chmod +x /etc/NetworkManager/dispatcher.d/99-wifi-after-ethernet

    Re-test: plug Ethernet; wait ~5–10 seconds; check:

bash

nmcli radio all
nmcli device

If you want the real fix (not just a workaround)

Tell me:

    your laptop model (or docking model)
    output of sudo dmesg -T | egrep -i 'acpi|dock|typec|ucsi|usbc|usb.*power|rfkill' | tail -n 200
    and whether this happens with a different Ethernet cable/dock/USB‑C port

With that, we can usually pinpoint the ACPI/dock/power-management event that’s causing the RF_KILL disable.

