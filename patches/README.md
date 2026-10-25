# Baliza: Kernel Compatibility Patches

This directory contains standalone patch files isolating the adaptations required to compile and run the Realtek RTL8188EUS (`8188eu`) wireless driver on modern Linux kernels (Linux 6.x and 7.x).

Upstream base tree: [aircrack-ng/rtl8188eus](https://github.com/aircrack-ng/rtl8188eus) (v5.3.9).

---

## Patch Index

### `0001-timer-delete-sync-kernel-6.15.patch`
- **Subsystem**: Kernel Timer Subsystem (`<linux/timer.h>`)
- **Affects**: Linux Kernel >= 6.15.0
- **Rationale**: The Linux kernel deprecated and removed `del_timer_sync()` in favor of `timer_delete_sync()`. This patch provides conditional compilation checking `LINUX_VERSION_CODE >= KERNEL_VERSION(6, 15, 0)`.

### `0002-cfg80211-wireless-dev-key-ops-kernel-7.1.patch`
- **Subsystem**: Wireless Configuration (`net/wireless`, `<net/cfg80211.h>`)
- **Affects**: Linux Kernel >= 7.1.0
- **Rationale**: The `cfg80211_ops` function pointers (`add_key`, `del_key`, `get_key`, `set_default_key`, `set_default_mgmt_key`) were migrated from taking `struct net_device *ndev` to `struct wireless_dev *wdev`. The patch extracts the net_device pointer via `wdev->netdev`.

### `0003-cfg80211-remain-on-channel-kernel-7.x.patch`
- **Subsystem**: Wireless Configuration (`cfg80211_rtw_remain_on_channel`)
- **Affects**: Linux Kernel >= 7.2.0 and >= 7.3.0
- **Rationale**: 
  - Linux 7.2 changed the return type to `int` and added the `const u8 *rx_addr` parameter.
  - Linux 7.3 changed `u64 *cookie` to value parameter `u64 cookie`.

### `0004-strscpy-deprecation-kernel-7.2.patch`
- **Subsystem**: Core String Utilities (`<linux/string.h>`)
- **Affects**: Linux Kernel >= 7.2.0
- **Rationale**: Eliminates compile warnings/errors regarding deprecated bounded string copies (`strncpy`) by mapping to `strscpy`.
