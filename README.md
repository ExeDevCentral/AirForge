# AirForge ⚡ Universal Linux Hotspot Engine & Driver Orchestrator

<p align="center">
  <img src="https://img.shields.io/badge/AirForge-v1.1.0-00d4ff?style=for-the-badge&logo=wifi&logoColor=white" alt="Version">
  <img src="https://img.shields.io/badge/Linux_Kernels-6.x_%7C_7.x_Verified-34d399?style=for-the-badge&logo=linux&logoColor=white" alt="Kernels">
  <img src="https://img.shields.io/badge/License-MIT-f59e0b?style=for-the-badge" alt="License">
  <img src="https://img.shields.io/badge/Architecture-x86__64_%7C_aarch64-ec4899?style=for-the-badge" alt="Arch">
</p>

```
    ___    _        ______                         
   /   |  (_)_____ / ____/___  _________ ____      
  / /| | / / ___// /_  / __ \/ ___/ __ `/ _ \     
 / ___ |/ / /   / __/ / /_/ / /  / /_/ /  __/     
/_/  |_/_/_/   /_/    \____/_/   \__, /\___/      
                                /____/            
    UNIVERSAL LINUX HOTSPOT ENGINE & DRIVER SUITE
```

> **AirForge** transforms any Linux desktop, workstation, or headless single-board computer (Raspberry Pi / mini-PC) into an enterprise-grade, high-performance **Wi-Fi Access Point (Hotspot)**. It features autonomous kernel driver patching for problematic USB Wi-Fi dongles, a terminal HUD with real-time telemetry, and instant smartphone pairing via terminal QR codes.

---

## ⚡ The Problem & The Solution

Millions of users purchase budget USB Wi-Fi dongles (such as Realtek RTL8188EUS / RTL8188ETV) or attempt to share their PC's Ethernet connection over Wi-Fi, only to face kernel incompatibilities and dropped connections on modern Linux distributions:

| The Problem on Modern Linux | How AirForge Solves It |
| :--- | :--- |
| **In-tree `rtl8xxxu` driver fails in AP mode**: Linux kernel defaults to a driver that drops beacons, refuses client association, or crashes. | **Autonomous Driver Orchestration**: Automatically blacklists `rtl8xxxu` and compiles an optimized `8188eu.ko` driver with full Master/AP mode support. |
| **Broken upstream compilation on Linux 6.x and 7.x**: Legacy driver trees fail to compile due to `del_timer_sync` deprecations and strict modern Kbuild rules. | **Bleeding-Edge Kernel Patches**: Driver source is patched for modern Linux timer subsystems and current GCC/Clang tooling (tested on `7.2.11+`). |
| **Ghost disconnects & sleep freeze**: Cheap USB dongles aggressively enter USB auto-suspend after minutes of radio inactivity. | **Hardware PHY Locking**: Permanently disables sleep via kernel parameters (`rtw_power_mgnt=0 rtw_ips_mode=0 rtw_enusbss=0`). |
| **Tedious password entry on smartphones**: Typing 16+ character WPA2 passphrases manually on touchscreens is error-prone. | **Terminal QR Code Scanner**: Built-in ANSI UTF-8 QR code generator (`airforge qr`). Point any iPhone or Android camera to connect in 1 second. |
| **Zero visibility into network traffic**: Traditional tools provide no easy way to see who is connected or how much data is flowing. | **Real-Time HUD & Live Monitor**: Inspect connected devices directly from kernel ARP tables with IP/MAC tracking and live bandwidth counters. |

---

## 🚀 Quick Start (Automated 1-Command Installation)

AirForge installs cleanly on **Arch Linux, Debian, Ubuntu, Fedora, Manjaro, Linux Mint**, and **Raspberry Pi OS**:

```bash
git clone https://github.com/ExeDevCentral/AirForge.git
cd AirForge
sudo ./install.sh
```

### What the installer handles automatically:
1. Resolves and installs system build prerequisites (`base-devel`, `dkms`, `NetworkManager`, `qrencode`).
2. Configures kernel module options to blacklist conflicting drivers and eliminate USB auto-suspend.
3. Compiles the high-performance wireless driver against your running kernel and installs it.
4. Deploys the [`airforge`](bin/airforge) CLI (with `hotspot` backwards-compatible alias) to `/usr/local/bin/`.
5. Enables kernel IP forwarding (`net.ipv4.ip_forward = 1`) and activates the Hotspot.

---

## 💻 CLI Command Matrix (`airforge`)

Manage your access point effortlessly from any terminal or SSH session:

```bash
airforge status              # Displays the full color HUD: driver, radio, gateway, and connected clients
airforge qr                  # Renders an instant QR Code for smartphone camera pairing
airforge monitor             # Live dynamic dashboard refreshing throughput and clients every 2 seconds
airforge clients             # Shows real-time table of connected devices (IP, MAC, Hostname)
airforge traffic             # Inspects live RX/TX Megabytes and packet volume
airforge config "SSID" "PW"  # Updates network credentials and restarts broadcast in one command
airforge on                  # Starts transmission and NAT routing
airforge off                 # Safely shuts down the access point
airforge restart             # Refreshes network routing and wireless links
airforge rebuild             # Recompiles the kernel driver in seconds after a Linux kernel upgrade
airforge service [action]    # Controls the systemd auto-start daemon (enable | disable | status)
```

*(Note: `hotspot` is symlinked to `airforge` for complete backward compatibility).*

---

## 📱 Instant Smartphone Pairing

Run:
```bash
airforge qr
```

AirForge generates an instant, high-contrast QR code compliant with the universal Wi-Fi pairing standard (`WIFI:T:WPA;S:...;P:...;;`). Point your phone's camera at the terminal screen to connect immediately without typing passwords.

```
█████████████████████████████████████
████ ▄▄▄▄▄ █▀ █▀▀▀▄▄▀██▀██ ▄▄▄▄▄ ████
████ █   █ █▀ ▄ █▄▄▀▀▀▄▄ █ █   █ ████
████ █▄▄▄█ █▀█ █▄▀█ ▀▀▄▄ █ █▄▄▄█ ████
████▄▄▄▄▄▄▄█▄█▄█ █ █▄▀ █ █▄▄▄▄▄▄▄████
████ ▄▄▄▄▄ █▄█▀█▀ ▄▄ █▀█ █▄█  ▄██████
████ █   █ █  ▄█▄█▄▄▀▄▄  ▄  ▄██▀█████
████ █▄▄▄█ █  ▀ ▄█▀█▀▄▀ ███▀██▄ ▀████
████▄▄▄▄▄▄▄█▄▄█▄███▄▄██▄█▄██▄██▄█████
█████████████████████████████████████
```

---

## 🌐 Real-World Scope & Applications (Alcances)

AirForge is engineered for production environments, development labs, and everyday field utility:

* 🆘 **Emergency Field Hotspot**: Turn any Ethernet-connected desktop or Linux laptop into an instant Wi-Fi station for teams during internet outages or off-grid operations.
* 🏠 **Headless Server & HomeLab Gateway**: Repurpose a low-power Mini PC, old office tower, or Raspberry Pi into a dedicated 24/7 Wi-Fi router with zero hardware waste.
* 🔒 **Isolated IoT & Guest Sandbox**: Segregate untrusted IoT appliances (smart plugs, IP cameras, microcontrollers) onto their own isolated subnet (`10.42.0.x/24`) away from your private NAS and LAN.
* 📱 **Mobile Developer Testing**: Create deterministic local Wi-Fi environments for testing React Native, Flutter, and iOS/Android client-server communication with full control over routes.
* 🛡️ **Cybersecurity Labs & Penetration Testing**: The underlying patched driver preserves packet injection and monitor mode compatibility for defensive audits and Wi-Fi security testing.

---

## 📐 Architecture & Networking Pipeline

```
┌────────────────────────────────────────────────────────┐
│               Internet WAN Upstream Source             │
│          (Fiber / Cable Ethernet: enp5s0 / 4G Modem)   │
└───────────────────────────┬────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────┐
│               Linux Kernel Network Subsystem           │
│   • net.ipv4.ip_forward = 1 (Persistent Sysctl)        │
│   • iptables / nftables MASQUERADE NAT Engine          │
│   • dnsmasq Local DHCP Gateway: 10.42.0.1/24           │
└───────────────────────────┬────────────────────────────┘
                            │
             ┌──────────────┴──────────────┐
             ▼                             ▼
┌─────────────────────────┐   ┌──────────────────────────┐
│     NetworkManager      │   │       AirForge Engine    │
│   (AP Mode Controller)  │ ◄─┼─► │ (Custom Patched Driver   │
│  wpa_supplicant PMF     │   │  & Hardware PHY Lock)    │
└────────────┬────────────┘   └────────────┬─────────────┘
             │                             │
             └──────────────┬──────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────┐
│              Wireless USB Adapter (wlan0)              │
│       Frequency: 2.4 GHz | Channel: 6 (2437 MHz)       │
│           Security: WPA2-PSK (AES / CCMP)              │
└───────────────────────────┬────────────────────────────┘
                            │ 802.11 b/g/n (150 Mbps)
                            ▼
┌────────────────────────────────────────────────────────┐
│         Connected Smartphones, Tablets & Laptops       │
│           Subnet: 10.42.0.x/24 | DNS: 10.42.0.1        │
└────────────────────────────────────────────────────────┘
```

---

## 🧭 Roadmap & Growth Vision (Posibles Mejoras)

AirForge is designed with a scalable, modular architecture to expand into an all-in-one network control platform:

### 🎯 Phase 1: Rock-Solid Base & Kernel Stability (v1.0 - v1.1) ✅
- [x] Automated compilation and installation for modern Linux Kernels 6.x and 7.x (`7.2.11+`).
- [x] Intelligent kernel module conflict resolution (blacklisting `rtl8xxxu`).
- [x] Master/AP mode support with WPA2-PSK (AES/CCMP).
- [x] Automated IP forwarding and NAT routing between upstream WAN and Wi-Fi.
- [x] Terminal HUD with live ARP scanning and active client detection.
- [x] Instant smartphone Wi-Fi QR Code generation in terminal (`qrencode` integration).
- [x] Dynamic live monitor (`airforge monitor`) with real-time throughput metrics.
- [x] One-command automated installer (`install.sh`) and clean uninstaller (`uninstall.sh`).
- [x] Systemd daemon service for automatic boot startup (`airforge.service`).

### 🚀 Phase 2: Multi-Chipset Autodetection & Hardware Expansion (v1.2)
- [ ] **Multi-Chipset Auto-Patcher**: Plug in any USB dongle and AirForge automatically detects the vendor ID and compiles the matching driver:
  - Realtek **RTL8812AU / RTL8821AU** (Dual-Band 2.4 / 5 GHz AC 1200).
  - Realtek **RTL8811CU**.
  - MediaTek **MT7601U / RT5370**.
- [ ] **Interactive TUI Dashboard**: Curses-based terminal dashboard with ASCII gauges for real-time signal strength and per-client live speed graphs.
- [ ] **Per-Client Bandwidth Accounting**: Track total bytes uploaded and downloaded per MAC address with persistent logging.

### 🌐 Phase 3: Web GUI Dashboard & Network Intelligence (v1.3 - v1.4)
- [ ] **Embedded Web Control Panel**: Lightweight web server running on `http://10.42.0.1:8080` (accessible from any connected phone browser) to view clients, kick unauthorized devices, and update passwords without terminal access.
- [ ] **Integrated DNS Sinkhole (Pi-hole style)**: Built-in local DNS ad-blocker blocking tracking and telemetry domains for all connected smartphones.
- [ ] **Bandwidth Limiter (QoS)**: Set maximum download/upload speeds per connected device.
- [ ] **Captive Portal / Guest Vouchers**: Temporary access pass system for offices, coworking spaces, and cafes.

### 📦 Phase 4: Packaging & Distribution (v1.5)
- [ ] Official Arch User Repository (AUR) package (`aur/airforge-bin`).
- [ ] Debian/Ubuntu PPA (`.deb`) and Fedora COPR (`.rpm`) packages.
- [ ] System tray applet for KDE Plasma and GNOME desktops.

---

## 🔍 Troubleshooting

| Issue | Cause | Fix |
| :--- | :--- | :--- |
| **Phone does not see the Wi-Fi network** | Regulatory domain restriction in the driver | Run `sudo iw reg set US` or add the network manually with SSID `Red-Exeq-WiFi` and Security `WPA2-Personal`. |
| **Connected, but "No Internet Connection"** | Kernel IP forwarding is disabled | Verify with `cat /proc/sys/net/ipv4/ip_forward`. If `0`, enable it via `sudo sysctl -w net.ipv4.ip_forward=1`. AirForge automates this in `/etc/sysctl.d/99-ip-forward.conf`. |
| **Hotspot stopped working after updating Linux** | Kernel version mismatch | Run `airforge rebuild`. It recompiles and loads the module for your new kernel in 3 seconds. |

Detailed recovery steps are available in [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md).

---

## 🤝 Contributing

Contributions, bug reports, and hardware testing across different Linux distributions are warmly welcomed. Please check [CONTRIBUTING.md](CONTRIBUTING.md) to get started.

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.  
Underlying wireless driver source code retains its original GPL licensing terms.

---

**Developed & Maintained by [Exequiel Echevarria (ExeDevCentral)](https://github.com/ExeDevCentral)**  
*Rosario, Argentina*
