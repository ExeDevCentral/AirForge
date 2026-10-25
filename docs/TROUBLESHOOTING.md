# Troubleshooting Guide 🔍

Common issues and solutions when deploying Wi-Fi Hotspots with Realtek USB dongles on Linux.

---

### 1. Mobile Phone doesn't see the Wi-Fi Network
* **Cause**: RTL8188EUS in certain regulatory domains emits beacons passively, behaving like a hidden network.
* **Solution**:
  1. Make sure your wireless regulatory domain is set:
     ```bash
     sudo iw reg set US   # or AR, ES, etc.
     ```
  2. If the phone still doesn't show it automatically, choose **"Add Network Manually"** in your phone Wi-Fi settings:
     - Name (SSID): `Red-Exeq-WiFi`
     - Security: `WPA/WPA2-Personal`
     - Password: `ConexionSegura2026!`

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
  Our installer creates `/etc/sysctl.d/99-ip-forward.conf` to make this setting persistent across reboots.

---

### 3. After a Kernel Update, the Hotspot Fails to Start
* **Cause**: Kernel modules are tied to specific kernel versions (`/lib/modules/$(uname -r)/`).
* **Solution**:
  Simply run the auto-rebuilder:
  ```bash
  hotspot rebuild
  ```
  It will compile the module against the newly running kernel, strip unneeded symbols, install it, and reload the driver in seconds.
