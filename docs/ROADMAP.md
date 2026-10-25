# AirForge Grand Roadmap 🚀

This document outlines the planned multi-year engineering roadmap for **AirForge**, moving from a specialized driver and hotspot tool to an autonomous, universal Linux network routing and hotspot suite.

---

## 🎯 Phase 1: Rock-Solid Base & Bleeding-Edge Kernel Stability (v1.0 - v1.1) ✅
- [x] **Universal Linux 6.x / 7.x Kernel Support**: Out-of-the-box zero-error compilation for modern Linux kernels (tested on `7.2.11+`).
- [x] **Autonomous Kernel Patching**: Pre-patched for modern timer APIs (`timer_setup` vs deprecated `del_timer_sync`) and strict modern Kbuild flags.
- [x] **Hardware PHY Lock**: Permanent sleep mode elimination (`rtw_power_mgnt=0 rtw_ips_mode=0 rtw_enusbss=0`).
- [x] **Conflict-Free Driver Swapping**: Automated blacklisting of broken in-tree `rtl8xxxu` driver.
- [x] **Master/AP Mode & NAT Routing**: Stable WPA2-PSK (AES/CCMP) beaconing with kernel IPv4 forwarding.
- [x] **Interactive CLI HUD**: Color terminal interface (`airforge status`) displaying driver, radio, gateway, and live connected clients from kernel ARP tables.
- [x] **Instant Smartphone Pairing**: Terminal-rendered ANSI UTF-8 QR code (`airforge qr`).
- [x] **Live Dynamic Monitor**: `airforge monitor` refreshes throughput and client associations dynamically every 2 seconds.
- [x] **Automated 1-Command Installer & Uninstaller**: Full dependency resolution for Arch, Debian, Ubuntu, and Fedora.
- [x] **Systemd Boot Integration**: Persistent startup daemon (`airforge.service`).

---

## 🚀 Phase 2: Multi-Chipset Autodetection & Hardware Expansion (v1.2)
- [ ] **Plug & Play Multi-Chipset Auto-Patcher**:
  - Automatically identify connected USB Wi-Fi dongles via `lsusb` and match them against an onboard catalog of driver patch recipes:
    - Realtek **RTL8812AU / RTL8821AU** (Dual-Band 2.4 GHz + 5 GHz AC 1200).
    - Realtek **RTL8811CU**.
    - MediaTek **MT7601U / RT5370**.
- [ ] **Rich TUI (Terminal User Interface)**:
  - Curses-based full-screen dashboard displaying real-time ASCII signal strength bars, live bandwidth graph (speedometer), and device ping latency.
- [ ] **Per-Device Bandwidth Accounting**:
  - Live and persistent RX/TX Megabytes tracked per MAC address.

---

## 🌐 Phase 3: Embedded Web GUI & Network Intelligence (v1.3 - v1.4)
- [ ] **Lightweight Web Control Panel**:
  - Built-in lightweight HTTP daemon on `http://10.42.0.1:8080` (accessible from any connected phone browser without terminal).
  - One-tap "Kick Device" button (MAC address filtering).
  - One-tap password update and network rename.
- [ ] **Built-in DNS Sinkhole (Pi-hole style)**:
  - Intercept port 53 DNS queries to block ads, malware, and telemetries across all connected smartphones and smart devices.
- [ ] **Quality of Service (QoS) & Bandwidth Limiter**:
  - Cap download/upload speeds per device to prevent one user from saturating the connection.
- [ ] **Captive Portal & Voucher Ticketing Engine**:
  - Guest portal for events, offices, and coffee shops with timed access vouchers.

---

## 📦 Phase 4: Packaging & Desktop Integration (v1.5)
- [ ] Official Arch User Repository (AUR) package (`aur/airforge-bin`).
- [ ] Debian/Ubuntu PPA (`.deb`) and Fedora COPR (`.rpm`) repositories.
- [ ] System Tray Applet for KDE Plasma, GNOME, and Wayland desktops.
