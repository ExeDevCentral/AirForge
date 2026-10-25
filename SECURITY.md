# Security Policy & Threat Model 🛡️

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.x     | :white_check_mark: |
| < 1.0   | :x:                |

---

## Known Threat Model & Hardware Limitations

1. **WPA3-SAE Hardware Limitation:**
   The Realtek RTL8188EUS hardware engine does not support SAE authentication (WPA3-Personal) or modern cipher suites like GCMP or CCMP-256. All access point operations use **WPA2-PSK (AES/CCMP-128)**. Environments mandating WPA3 compliance require hardware upgrades to Wi-Fi 5/6 chipsets.

2. **Plaintext Credential Exposure:**
   - Rendering pairing QR codes in terminal (`baliza qr`) displays SSID and passphrase in plaintext on screen, subject to visual observation (*shoulder surfing*).
   - Executing `baliza config <SSID> <PASSWORD>` records the password argument in the user's shell history (`~/.bash_history`). Use leading spaces or manual config editing if this is a concern.

3. **Subnet & Broadcast Domain:**
   By default, client stations in the hotspot share the `10.42.0.0/24` subnet without Layer 2 client isolation. Traffic between stations is not blocked unless custom `nftables`/`ebtables` filtering rules are configured.

---

## Reporting a Vulnerability

If you discover a security vulnerability or exploit condition in **Baliza**, please report it responsibly by contacting Exequiel Echevarria via e-mail at [exemetal@hotmail.com](mailto:exemetal@hotmail.com).

Please include:
- A description of the vulnerability and its potential impact
- Steps to reproduce or proof-of-concept
- System environment (`uname -r`, distro, `lsusb`)

All security reports will be acknowledged within 48 hours and resolved promptly.
