# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2026-10-25

### Added
- **Project Rebranding & Research Focus**: Renamed project to **Baliza** (*Spanish for "Beacon"*), emphasizing the technical challenge of IEEE 802.11 beacon management frame generation in hardware.
- **Short Technical Paper**: Published [`docs/TECHNICAL_REPORT.md`](docs/TECHNICAL_REPORT.md) detailing driver internals, kernel 6.x/7.x compatibility, physical hardware benchmarks, and threat modeling.
- **Isolated Patch Collection**: Created [`patches/`](patches/) containing individual diffs and documentation for:
  - `0001-timer-delete-sync-kernel-6.15.patch` (`timer_delete_sync` transition).
  - `0002-cfg80211-wireless-dev-key-ops-kernel-7.1.patch` (`cfg80211_ops` key ops to `wireless_dev`).
  - `0003-cfg80211-remain-on-channel-kernel-7.x.patch` (signature adjustments for Linux 7.2 and 7.3).
  - `0004-strscpy-deprecation-kernel-7.2.patch` (safe string copy fortification).
- **DKMS Standardization**: Updated `driver/dkms.conf`, `dkms-install.sh`, and `dkms-remove.sh` for automated rebuilding across kernel upgrades.
- **GitHub Actions ShellCheck**: Upgraded CI workflow with automated ShellCheck linting for all shell scripts.

### Changed
- **License Alignment**: Standardized project license to **GNU General Public License v2.0 (GPL-2.0)** to strictly comply with Linux kernel module licensing and upstream driver inheritance (`aircrack-ng/rtl8188eus`).
- **Tone & Documentation**: Purged non-technical marketing claims ("enterprise-grade", "millions of users") from README and documentation.
- **Architecture Diagram**: Migrated from ASCII diagram to interactive GitHub-native Mermaid flowchart.
- **CLI Tooling**: `bin/baliza` is now the primary entry point, with `airforge` and `hotspot` maintained as backwards-compatible symlinks.

### Security
- **Explicit Threat Modeling**: Documented plaintext password exposure in terminal QR output and shell history (`~/.bash_history`).
- **Cryptographic Limitations**: Formally declared absence of WPA3 / SAE support due to hardware PHY limitations of the Realtek RTL8188EUS.

---

## [1.1.0] - 2026-10-25

### Added
- Dynamic live monitor (`airforge monitor`) with periodic packet counters and ARP updates.
- One-command installer and uninstaller scripts (`install.sh`, `uninstall.sh`).
- Systemd daemon unit for automatic startup on boot.
- QR code generation directly within terminal (`qrencode`).

---

## [1.0.0] - 2026-10-25

### Added
- Initial implementation of the 8188eu driver build system for Linux 6.x/7.x.
- Blacklisting for conflicting in-tree `rtl8xxxu` driver.
- USB auto-suspend disabling kernel module flags (`rtw_power_mgnt=0 rtw_ips_mode=0 rtw_enusbss=0`).
- IPv4 forwarding and NAT Masquerade routing integration.
- Terminal HUD (`status`, `clients`, `traffic`).
