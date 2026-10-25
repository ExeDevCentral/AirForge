# Architecture & Technical Deep Dive 🛠️

This document describes the architectural flow, kernel interactions, and networking pipeline utilized by **rtl8188eu-hotspot-toolkit**.

---

## High-Level Topology

```
                  ┌───────────────────────────────────────────────┐
                  │                 Internet WAN                  │
                  │        (Fiber / Cable Ethernet: enp5s0)       │
                  └───────────────────────┬───────────────────────┘
                                          │
                                          ▼
                  ┌───────────────────────────────────────────────┐
                  │          Linux Kernel Network Stack           │
                  │   - net.ipv4.ip_forward = 1                   │
                  │   - iptables / nftables MASQUERADE NAT        │
                  │   - dnsmasq DHCP Gateway: 10.42.0.1/24        │
                  └───────────────────────┬───────────────────────┘
                                          │
                        ┌─────────────────┴─────────────────┐
                        │                                   │
                        ▼                                   ▼
             ┌─────────────────────┐             ┌─────────────────────┐
             │   NetworkManager    │             │   Driver 8188eu     │
             │   (AP Mode Engine)  │ ◄─────────► │ (Custom Patched     │
             │  wpa_supplicant PMF │             │  Kernel Module)     │
             └──────────┬──────────┘             └──────────┬──────────┘
                        │                                   │
                        └─────────────────┬─────────────────┘
                                          │
                                          ▼
                  ┌───────────────────────────────────────────────┐
                  │          Realtek RTL8188EUS Dongle            │
                  │      USB ID: 0bda:8179 | 2.4 GHz 150 Mbps     │
                  │         Channel 6 (2437 MHz) - WPA2           │
                  └───────────────────────┬───────────────────────┘
                                          │  802.11 b/g/n Radio
                                          ▼
                  ┌───────────────────────────────────────────────┐
                  │       Connected Clients (Smartphones/PCs)     │
                  │     IP: 10.42.0.x/24 | DNS: 10.42.0.1         │
                  └───────────────────────────────────────────────┘
```

---

## Key Engineering Decisions

### 1. In-Tree `rtl8xxxu` vs. Custom `8188eu`
The Linux kernel includes an open-source driver named `rtl8xxxu`. While functional for basic client connections, it lacks robust Master/AP (Access Point) mode support for the RTL8188EUS chipset, causing kernel crashes or failing to broadcast beacons. We solve this by:
- Blacklisting `rtl8xxxu` in `/etc/modprobe.d/blacklist-rtl8xxxu.conf`.
- Installing the high-performance `8188eu` module with AP mode, packet injection, and monitor mode support.

### 2. Aggressive Power Management Elimination
Cheaper Realtek USB dongles enter low-power sleep mode after a few minutes of radio inactivity, dropping client associations and freezing GUI network menus. We permanently pass:
```text
options 8188eu rtw_power_mgnt=0 rtw_ips_mode=0 rtw_enusbss=0
```
This forces the USB PHY and radio baseband to maintain constant link presence.

### 3. Kernel 6.x and 7.x Compatibility
Upstream driver branches broke on Linux 6.x/7.x due to changes in:
- `del_timer_sync` deprecation in favor of modern timer callbacks.
- Kbuild flag parsing requirements (`ccflags-y` instead of legacy `EXTRA_CFLAGS`).
Our bundled driver includes verified patches enabling zero-error compilation on bleeding-edge kernels.
