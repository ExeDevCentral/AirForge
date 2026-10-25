# Troubleshooting Guide 🔍

Common issues and solutions when deploying Wi-Fi Hotspots with Realtek USB dongles on Linux.

---

### 1. Mobile Phone doesn't see the Wi-Fi Network
* **Cause**: RTL8188EUS in certain regulatory domains restricts channel broadcast, or operates in passive scanning before BSS activation.
* **Solution**:
  1. Make sure your wireless regulatory domain is set:
     ```bash
     sudo iw reg set US   # or AR, ES, etc.
     ```
  2. If the phone still doesn't show it automatically, choose **"Add Network Manually"** in your phone Wi-Fi settings:
     - Name (SSID): `Red-Exeq-WiFi` (or configured SSID)
     - Security: `WPA/WPA2-Personal`
     - Password: `Central1985` (or configured passphrase)
  3. Or scan the instant pairing QR code directly via `baliza qr`.

---

### 2. Connected to Wi-Fi but "No Internet Connection"
* **Cause**: IPv4 forwarding is disabled in the kernel.
* **Solution**:
  Verify with:
  ```bash
  cat /proc/sys/net/ipv4/ip_forward
  ```
  If it returns `0`, enable it:
  ```bash
  sudo sysctl -w net.ipv4.ip_forward=1
  ```
  Baliza's installer creates `/etc/sysctl.d/99-ip-forward.conf` to make this setting persistent across reboots.

---

### 3. After a Kernel Update, the Hotspot Fails to Start
* **Cause**: Out-of-tree kernel modules are compiled against a specific kernel version (`/lib/modules/$(uname -r)/`).
* **Solution**:
  Simply run the auto-rebuilder:
  ```bash
  baliza rebuild
  ```
  It compiles the module against your newly booted kernel, strips debug symbols, installs it, and reloads the driver in seconds.
