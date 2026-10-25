# Project Roadmap 🚀

This roadmap outlines the planned evolution of **rtl8188eu-hotspot-toolkit** from a specialized RTL8188EUS hotspot manager into an all-in-one universal Linux Wi-Fi hotspot and driver orchestration suite.

---

### Phase 1: Core Foundation & Modern Kernel Stability (Current - v1.0.0) ✅
- [x] Tested and verified out-of-the-box support for Linux Kernels 6.x and 7.x (`7.2.11+`).
- [x] Automated compilation and installation of patched `8188eu.ko` driver.
- [x] Intelligent kernel module conflict resolution (blacklisting `rtl8xxxu`).
- [x] Full AP (Access Point) mode support with WPA2-PSK (AES/CCMP).
- [x] Automated IP forwarding and NAT routing between Ethernet/Cellular interfaces and Wi-Fi.
- [x] Interactive CLI tool (`bin/hotspot`) with live client detection from kernel ARP tables.
- [x] Instant smartphone Wi-Fi QR Code generation in terminal (`qrencode` integration).
- [x] One-command automated installer (`install.sh`) and clean uninstaller (`uninstall.sh`).
- [x] Systemd service integration for automatic boot start.

---

### Phase 2: Enhanced Telemetry & Multi-Chipset Support (v1.1.0 - v1.2.0) 🎯
- [ ] **Multi-Chipset Expansion**: Add out-of-the-box patch recipes for:
  - Realtek **RTL8812AU / RTL8821AU** (Dual-band 5 GHz AC).
  - Realtek **RTL8811CU**.
  - MediaTek **MT7601U**.
- [ ] **Live TUI (Terminal User Interface)**:
  - Curses-based real-time dashboard displaying connected devices, RSSI signal strength, and live bandwidth throughput graph.
- [ ] **Bandwidth Metering**:
  - Per-client traffic counting (RX/TX Megabytes per MAC address).
- [ ] **Custom DHCP & DNS Options**:
  - Configurable subnet IP ranges (e.g., `192.168.50.x` or `10.42.0.x`).
  - Integrated AdGuard / Pi-hole / DNS over HTTPS upstream filtering.

---

### Phase 3: Web Dashboard & Ecosystem Integration (v1.3.0+) 🌐
- [ ] **Embedded Lightweight Web GUI**:
  - Local web management portal (accessible via `http://10.42.0.1:8080` or `http://hotspot.local`) to manage connected clients, kick unapproved devices, and adjust network credentials from any connected phone or browser.
- [ ] **Captive Portal / Guest Mode**:
  - Optional guest splash screen with time-limited vouchers or click-to-connect access.
- [ ] **Desktop Tray Widget**:
  - AppIndicator / System Tray applet for KDE Plasma, GNOME, and Wayland environments.
- [ ] **Official AUR Package**:
  - Package submitted to Arch User Repository (`aur/rtl8188eu-hotspot-toolkit`).
