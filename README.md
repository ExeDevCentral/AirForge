# rtl8188eu-hotspot-toolkit 📡

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Linux Kernel: 6.x & 7.x](https://img.shields.io/badge/Linux_Kernel-6.x%20%7C%207.x%20Ready-green.svg)](https://kernel.org)
[![Tested On: Arch Linux](https://img.shields.io/badge/Tested%20On-Arch%20Linux%20%7C%20Debian%20%7C%20Ubuntu-orange.svg)]()
[![CLI: hotspot](https://img.shields.io/badge/CLI-hotspot-cyan.svg)](bin/hotspot)
[![Maintenance: Active](https://img.shields.io/badge/Maintained%3F-yes-brightgreen.svg)]()

> **Automated Linux Wi-Fi Access Point manager, modern kernel driver patcher, and interactive terminal HUD for Realtek RTL8188EUS and USB Wi-Fi dongles.**

Turn any low-cost Realtek RTL8188EUS (`0bda:8179`) USB Wi-Fi adapter into an ultra-reliable, high-performance Linux Access Point (Hotspot) with zero headache. Built to thrive on modern Linux distributions running Kernels **6.x and 7.x** (e.g. `7.2.11+`).

---

## ⚡ The Problem & The Solution

| The Problem on Modern Linux | How this Toolkit Solves It |
| :--- | :--- |
| **In-tree `rtl8xxxu` driver fails at AP mode**: Drops beacons, ignores clients, or crashes. | Automatically blacklists `rtl8xxxu` and compiles a patched, stable `8188eu.ko` driver with full Master/AP mode support. |
| **Broken upstream compilation on Linux 6.x/7.x**: Deprecated timer functions (`del_timer_sync`) and Kbuild flag errors break older driver repos. | Driver source includes patches for modern Linux kernel timer subsystems and strict modern Kbuild flags. |
| **Random Wi-Fi disconnects**: Cheaper dongles sleep aggressively due to default USB power savings. | Pre-configured kernel flags (`rtw_power_mgnt=0 rtw_ips_mode=0 rtw_enusbss=0`) permanently prevent USB auto-suspension. |
| **Tedious smartphone connection**: Typing 16+ character passwords manually on mobile devices. | Built-in **ASCII QR Code generator** right inside your terminal: point your phone camera and connect instantly. |
| **No insight into connected devices**: Hard to know who is connected or how much bandwidth is flowing. | Real-time CLI HUD with live ARP table scanning, IP/MAC tracking, and network traffic counters. |

---

## 🚀 Quick Start (Automated Installation)

Clone the repository and run the automated installer:

```bash
git clone https://github.com/ExeDevCentral/rtl8188eu-hotspot-toolkit.git
cd rtl8188eu-hotspot-toolkit
sudo ./install.sh
```

The installer automatically:
1. Detects and installs required build packages (`make`, `gcc`, `bc`, `NetworkManager`).
2. Configures kernel module options to disable power saving and blacklist conflicting drivers.
3. Compiles `8188eu.ko` against your running kernel and installs it.
4. Deploys the [`hotspot`](bin/hotspot) CLI globally to `/usr/local/bin/hotspot`.
5. Enables IP packet forwarding and starts the Wi-Fi Access Point.

---

## 💻 CLI Usage (`hotspot`)

Manage your hotspot effortlessly from any terminal:

```bash
hotspot status     # Full color HUD: driver status, radio details, and connected clients
hotspot qr         # Generates an instant QR Code to scan with your smartphone
hotspot clients    # Shows real-time table of connected devices (IP, MAC, Hostname)
hotspot traffic    # Live RX/TX packet counts and Megabytes transferred
hotspot config     # Update SSID, password and channel: hotspot config "MySSID" "MySecretPass" 6
hotspot on         # Turn on the Wi-Fi Access Point
hotspot off        # Turn off the Wi-Fi Access Point
hotspot restart    # Restart network routing and radio broadcast
hotspot rebuild    # Recompile driver in 3 seconds after upgrading your Linux kernel
hotspot service    # Manage systemd auto-start (enable | disable | status)
```

### 📱 Instant Smartphone Connection via Terminal QR Code

Run:
```bash
hotspot qr
```

Your terminal renders a clean, high-contrast QR code compliant with the universal Wi-Fi standard (`WIFI:T:WPA;S:...;P:...;;`). Point your iPhone or Android camera at your screen to join the hotspot without typing a single character!

---

## 📐 Architecture & Routing

```
Internet WAN (Ethernet / Fiber / Cellular)
                   │
                   ▼
┌───────────────────────────────────────────────┐
│          Linux Kernel Network Stack           │
│   • net.ipv4.ip_forward = 1 (NAT Routing)     │
│   • NetworkManager Shared Gateway: 10.42.0.1  │
└──────────────────────┬────────────────────────┘
                       │
                       ▼
┌───────────────────────────────────────────────┐
│      Realtek RTL8188EUS Dongle (wlan0)        │
│   • Custom 8188eu Kernel Module (AP Mode)     │
│   • Frequency: 2.4 GHz | Channel 6 (2437 MHz) │
│   • Security: WPA2-PSK (AES/CCMP)             │
└──────────────────────┬────────────────────────┘
                       │ 802.11 b/g/n
                       ▼
      Connected Smartphones, Laptops & IoT
```

Detailed technical documentation is available in [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

---

## 🗺️ Project Roadmap

This project is built to grow into a universal Linux Wi-Fi hotspot and driver orchestration suite:

* **v1.0 (Current)**: Rock-solid RTL8188EUS Hotspot, Kernel 6.x/7.x driver patcher, terminal QR code, client monitor, and systemd service.
* **v1.1**: Per-device bandwidth tracking and interactive TUI (Terminal User Interface).
* **v1.2**: Support for additional problematic Realtek chipsets (**RTL8812AU**, **RTL8821AU**, **RTL8811CU**) and MediaTek **MT7601U**.
* **v1.3**: Embedded lightweight web management portal (browser dashboard to manage connected clients from your phone).
* **v1.4**: Captive portal mode and guest Wi-Fi vouchers.

Check out [docs/ROADMAP.md](docs/ROADMAP.md) for full details and milestone targets.

---

## 🔧 Troubleshooting

If your smartphone doesn't detect the Wi-Fi network or you recently upgraded your kernel, check our comprehensive [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) for instant fixes.

---

## 🤝 Contributing

Contributions, bug reports, and hardware testing are welcomed! Please read our [CONTRIBUTING.md](CONTRIBUTING.md) to get started.

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.  
Realtek driver code retains original GPL licensing headers.

---

**Developed & Maintained by [Exequiel Echevarria (ExeDevCentral)](https://github.com/ExeDevCentral)**  
*Rosario, Argentina*
