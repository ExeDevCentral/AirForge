# Baliza Engineering Roadmap 🧭

This document outlines the engineering roadmap for **Baliza**, moving from driver stability and kernel porting to automated packaging and multi-chipset expansion.

---

## 🎯 Phase 1: Core AP Stability & Modern Kernel Port (v1.0 – v1.2) [COMPLETED] ✅
- [x] **Kernel 6.x / 7.x Compatibility**: Tested and verified on Linux `7.2.11-arch1-1`.
- [x] **Timer & cfg80211 API Porting**: Isolated patches for `timer_delete_sync` and `cfg80211_ops` changes in `patches/`.
- [x] **Hardware PHY Lock**: Disabled USB power-saving dropouts (`rtw_power_mgnt=0 rtw_ips_mode=0 rtw_enusbss=0`).
- [x] **Deterministic Driver Isolation**: Automatic blacklisting of defective in-tree `rtl8xxxu` driver.
- [x] **Master/AP Mode & NAT Routing**: Stable WPA2-PSK (AES/CCMP) beaconing with kernel IPv4 forwarding.
- [x] **Interactive CLI HUD**: Terminal interface (`baliza status`) displaying driver, radio, gateway, and live connected clients from kernel ARP tables.
- [x] **Instant Smartphone Pairing**: Terminal-rendered ANSI UTF-8 QR code (`baliza qr`).
- [x] **Live Dynamic Monitor**: `baliza monitor` dynamic throughput and association monitor.
- [x] **Automated Installer & Uninstaller**: Full dependency resolution for Arch, EndeavourOS, Debian, Ubuntu, and Fedora.
- [x] **Systemd Boot Integration**: Persistent startup daemon (`baliza.service`).
- [x] **Technical Paper**: Published [`docs/TECHNICAL_REPORT.md`](TECHNICAL_REPORT.md).

---

## 🚀 Phase 2: DKMS Automation & Multi-Distro Packaging (Planned)
- [ ] **DKMS Integration Suite**:
  - Full DKMS support so module updates trigger automatically after kernel upgrades without running `rebuild` manually.
- [ ] **Native Distribution Packages**:
  - Arch User Repository (`aur/baliza-git` or `aur/baliza-dkms`).
  - Debian/Ubuntu PPA (`.deb`) and Fedora COPR (`.rpm`).
- [ ] **Continuous Integration (CI)**:
  - Automated kernel matrix builds (compilation tests against Linux 6.6 LTS, 6.12 LTS, and 7.x head).

---

## 🌐 Phase 3: Hardware Expansion & Multi-Chipset Support (Planned)
- [ ] **Multi-Chipset Auto-Patcher**:
  - Extend driver catalog to support additional common USB adapters:
    - Realtek **RTL8812AU / RTL8821AU** (Dual-Band 2.4 GHz + 5 GHz AC 1200).
    - Realtek **RTL8811CU**.
    - MediaTek **MT7601U / RT5370**.
- [ ] **Per-Device Traffic Accounting**:
  - Live and persistent RX/TX Megabytes tracked per MAC address.
- [ ] **Client Layer 2 Isolation**:
  - Optional station isolation mode using `ebtables` / `nftables` rules for guest deployments.
