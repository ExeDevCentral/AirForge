# Baliza: Arquitectura, Portabilidad en Linux 7.x y Habilitación del Modo Punto de Acceso (AP) para el Chipset Realtek RTL8188EUS

**Autor:** Exequiel Echevarria (`ExeDevCentral`) — Rosario, Argentina  
**Fecha de informe:** Octubre 2026  
**Entorno de referencia:** Linux Kernel `7.2.11-arch1-1` (x86_64), EndeavourOS  
**Repositorio:** [https://github.com/ExeDevCentral/Baliza](https://github.com/ExeDevCentral/Baliza)  
**Licencia:** GNU General Public License v2.0 (GPL-2.0)

---

## 1. Resumen (Abstract)

Los adaptadores de red inalámbrica USB basados en el transceptor Realtek RTL8188EUS representan uno de los dispositivos 802.11n de bajo costo más extendidos del mercado. No obstante, en entornos modernos de GNU/Linux, su implementación se enfrenta a dos barreras fundamentales: (1) el controlador in-tree del núcleo (`rtl8xxxu`), estructurado sobre la pila `mac80211`, presenta severas deficiencias al instanciar modos de infraestructura Master/AP, fallando en el offloading y temporización de tramas de baliza (*Beacon frames*); y (2) los controladores propietarios derivados del fabricante (`8188eu`) quedaron desfasados y no compilan en versiones recientes del kernel (ramas 6.x y 7.x) debido a rupturas de API interna en temporizadores (`del_timer_sync`), el subsistema `cfg80211` y funciones de manejo seguro de cadenas.

Este informe documenta el desarrollo de **Baliza**, una solución integral que introduce parches quirúrgicos de compatibilidad para Linux 6.15+ hasta 7.3+, resuelve el conflicto de controladores en tiempo de arranque, neutraliza la suspensión agresiva del bus USB mediante parámetros de módulo (`rtw_power_mgnt=0`), y provee una capa de orquestación en espacio de usuario para el aprovisionamiento de puntos de acceso Wi-Fi transparentes con ruteo NAT e inspección telemétrica en tiempo real.

---

## 2. Antecedentes del Hardware: Arquitectura del RTL8188EUS

El circuito integrado Realtek RTL8188EUS es un controlador de interfaz de red (WLAN NIC) de chip único y bajo consumo que integra procesador MAC, banda base (BB) con capacidad 1T1R (1 transmisor, 1 receptor) y frontend de radiofrecuencia (RF) sobre bus USB 2.0.

### 2.1 Especificaciones Técnicas Verificadas

| Parámetro | Valor Verificado en Laboratorio |
| :--- | :--- |
| **Identificador USB (VID:PID)** | `0bda:8179` Realtek Semiconductor Corp. |
| **Estándares Inalámbricos** | IEEE 802.11b, 802.11g, 802.11n (Wi-Fi 4) |
| **Banda de Frecuencia** | 2.400 GHz – 2.4835 GHz (Canales 1 al 13) |
| **Modulación** | DSSS, CCK, OFDM (BPSK, QPSK, 16-QAM, 64-QAM) |
| **Ancho de Canal Soportado** | 20 MHz (HT20) / 40 MHz (HT40) |
| **Tasa de Transferencia PHY Máxima** | 150.0 Mbps (MCS 7 con Short GI en HT40) |
| **Potencia de Transmisión Típica** | 13.0 dBm – 20.0 dBm (ajustado por dominio regulatorio) |
| **Cifrados Soportados por Hardware** | WEP-40, WEP-104, TKIP, CCMP-128 (AES) |
| **Soporte WPA3 / SAE** | **No disponible** (limitación física del motor criptográfico del chip) |

---

## 3. Diagnóstico del Problema: In-Tree `rtl8xxxu` vs Vendor HAL `8188eu`

### 3.1 El Fallo del Modo Master / AP en `rtl8xxxu`

El kernel Linux incluye de manera nativa el controlador `rtl8xxxu`, concebido como una alternativa abierta genérica para múltiples chips Realtek basada en el framework `mac80211`. Aunque `rtl8xxxu` opera de forma aceptable en modo cliente (*Managed/Station*) y permite modo monitor pasivo, su soporte para el chipset RTL8188EUS (`0bda:8179`) en modo Master/AP presenta fallas críticas:

1. **Inconsistencia en Beacon Frames (Balizas):** El estándar IEEE 802.11 requiere que un punto de acceso emita periódicamente tramas de gestión tipo *Beacon* (típicamente cada 100 TU ≈ 102.4 ms) para sincronización del conjunto de servicios básicos (BSS) e identificación de red. En `rtl8xxxu`, el hardware queue asignado al firmware del RTL8188EUS para balizas no responde a las órdenes de `mac80211`, resultando en la omisión recurrente de balizas. Como consecuencia, las estaciones clientes no detectan el SSID o sufren desconexión por pérdida de señal (*beacon loss*).
2. **Timeouts en `nl80211`:** Al invocar la orden `NL80211_CMD_START_AP`, el controlador agota el tiempo de espera al configurar las claves del BSS y la cola de transmisión TX de alta prioridad, arrojando errores en el daemon (`hostapd` o `NetworkManager`).

### 3.2 Suspensión Agresiva del Bus USB (Auto-Suspend)

Por omisión, el subsistema USB de Linux aplica políticas de suspensión en reposo (*USB autosuspend*) a periféricos inalámbricos para economizar energía. En el RTL8188EUS, el pasaje al estado de bajo consumo apaga el circuito PLL del oscilador de RF. Al intentar transmitir una ráfaga desde una estación conectada, el dongle no responde con la latencia requerida, provocando la caída de la conexión TCP y la desasociación en capa de enlace.

**Solución aplicada:** Baliza impone las siguientes opciones en `/etc/modprobe.d/8188eu.conf`:
```ini
options 8188eu rtw_power_mgnt=0 rtw_ips_mode=0 rtw_enusbss=0
```
- `rtw_power_mgnt=0`: Deshabilita el algoritmo de Power Saving de Realtek.
- `rtw_ips_mode=0`: Neutraliza el estado inactivo *Inactive Power Save* (IPS).
- `rtw_enusbss=0`: Inhibe de forma determinista la suspensión selectiva del bus USB.

---

## 4. Adaptaciones y Parches en el Kernel (Linux 6.x & 7.x)

Para permitir que el módulo `8188eu` (derivado del árbol de referencia v5.3.9 de aircrack-ng) compile y opere en núcleos modernos, se diseñaron cuatro adaptaciones clave:

### 4.1 Transición del Subsistema de Temporizadores (Linux >= 6.15.0)

El núcleo Linux 6.15 eliminó la función `del_timer_sync()` del subsistema de temporizadores (`<linux/timer.h>`), sustituyéndola por `timer_delete_sync()`.  
En `include/osdep_service_linux.h`:
```c
__inline static void _cancel_timer(_timer *ptimer, u8 *bcancelled)
{
#if (LINUX_VERSION_CODE >= KERNEL_VERSION(6, 15, 0))
    *bcancelled = timer_delete_sync(&ptimer->timer) == 1 ? 1 : 0;
#else
    *bcancelled = del_timer_sync(&ptimer->timer) == 1 ? 1 : 0;
#endif
}
```

### 4.2 Reestructuración de Callbacks de Claves en `cfg80211` (Linux >= 7.1.0)

A partir de Linux 7.1.0, las funciones de la estructura `cfg80211_ops` encargadas del aprovisionamiento de claves de cifrado (`add_key`, `del_key`, `get_key`, `set_default_key`, `set_default_mgmt_key`) dejaron de recibir el puntero tradicional `struct net_device *ndev`, adoptando directamente `struct wireless_dev *wdev`.  
En `os_dep/linux/ioctl_cfg80211.c`:
```c
static int cfg80211_rtw_add_key(struct wiphy *wiphy,
#if LINUX_VERSION_CODE >= KERNEL_VERSION(7, 1, 0)
    struct wireless_dev *wdev
#else
    struct net_device *ndev
#endif
    , int link_id, u8 key_index, bool pairwise,
    const u8 *mac_addr, struct key_params *params)
{
#if LINUX_VERSION_CODE >= KERNEL_VERSION(7, 1, 0)
    struct net_device *ndev = wdev->netdev;
#endif
    /* ... procesamiento de algoritmos WPA/WPA2 ... */
}
```

### 4.3 Modificación de la Firma `remain_on_channel` (Linux >= 7.2.0 y 7.3.0)

En Linux 7.2.0, el callback `cfg80211_rtw_remain_on_channel` modificó su tipo de retorno a `int` e introdujo el parámetro de dirección receptora `const u8 *rx_addr`. En Linux 7.3.0, el identificador `cookie` dejó de ser un puntero (`u64 *cookie`) para pasarse por valor (`u64 cookie`).  
En `os_dep/linux/ioctl_cfg80211.c`:
```c
#if (LINUX_VERSION_CODE >= KERNEL_VERSION(7, 2, 0))
static int cfg80211_rtw_remain_on_channel(struct wiphy *wiphy,
#else
static s32 cfg80211_rtw_remain_on_channel(struct wiphy *wiphy,
#endif
    struct wireless_dev *wdev,
    struct ieee80211_channel *channel,
    unsigned int duration,
#if (LINUX_VERSION_CODE >= KERNEL_VERSION(7, 3, 0))
    u64 cookie
#else
    u64 *cookie
#endif
#if (LINUX_VERSION_CODE >= KERNEL_VERSION(7, 2, 0))
    , const u8 *rx_addr)
#else
    )
#endif
```

### 4.4 Fortificación de Manejo de Cadenas (Linux >= 7.2.0)

La adopción de `strscpy()` en lugar del deprecado `strncpy()` en `hal/hal_com_phycfg.c` y cabeceras relacionadas previene fallos de desbordamiento de búfer y avisos de compilación restrictivos en GCC 14+.

---

## 5. Validación Experimental y Resultados

### 5.1 Entorno de Medición
Las pruebas fueron conducidas sobre el siguiente entorno productivo real:
- **Host:** Computadora de escritorio x86_64
- **Kernel:** `7.2.11-arch1-1`
- **Compilador:** GCC 15 / Clang 19
- **Adaptador:** USB 2.0 Realtek RTL8188EUS (`0bda:8179`)
- **Topología de red:** Enlace de subida (WAN) Gigabit Ethernet `enp5s0`, Interfaz AP Wi-Fi `wlan0` asignada al segmento `10.42.0.1/24`.

### 5.2 Modos de Interfaz Verificados con `iw`
Tras la compilación e inserción del módulo `8188eu`, el subsistema inalámbrico reporta los siguientes modos habilitados en hardware:

```text
Wiphy phy0
    Supported interface modes:
         * IBSS
         * managed
         * AP
         * monitor
         * P2P-client
         * P2P-GO
    Supported Ciphers:
        * WEP40 (00-0f-ac:1)
        * WEP104 (00-0f-ac:5)
        * TKIP (00-0f-ac:2)
        * CCMP-128 (00-0f-ac:4)
```

La presencia explícita de `* AP` certifica la capacidad de fungir como estación base emisora.

### 5.3 Enlace Inalámbrico Activo y Telemetría
La ejecución de `iw dev` durante la prueba experimental arrojó:

```text
Interface wlan0
    ifindex 3
    wdev 0x1
    addr 8c:90:2d:ac:dd:d3
    ssid Red-Exeq-WiFi
    type AP
    txpower 13.00 dBm
```

Durante una sesión continua de 4 horas de operación continua bajo carga con estaciones cliente móviles asociadas:
- **Clientes simultáneos asociados:** 1 teléfono inteligente (dirección MAC `86:80:3c:4d:b7:cb`, IP asignada `10.42.0.40`).
- **Tráfico transferido verificado en `/proc/net/dev`:**
  - **Recepción (RX):** 34.73 MB (125,776 paquetes)
  - **Transmisión (TX):** 261.76 MB (231,389 paquetes)
- **Desconexiones fortuitas (Ghost drops):** 0 incidentes registrados tras la aplicación de las opciones de bloqueo de ahorro de energía.

---

## 6. Modelo de Amenazas y Limitaciones de Seguridad

Es imperativo reconocer las fronteras de seguridad y las restricciones impuestas por la arquitectura del hardware:

1. **Restricción Criptográfica (Inexistencia de WPA3):**  
   El chipset RTL8188EUS carece de soporte por hardware para el cifrado Simultaneous Authentication of Equals (SAE / WPA3-Personal) y suites criptográficas como GCMP o CCMP-256. El punto de acceso opera exclusivamente bajo **WPA2-PSK (AES/CCMP-128)**. Redes que requieran protección de tramas de administración protegidas obligatorias (PMF / 802.11w) bajo WPA3 no son viables con este silicio.
2. **Exposición de Contraseñas en Texto Plano:**  
   - El generador de códigos QR (`baliza qr`) serializa la clave WPA2 en la cadena estándar de terminal (`WIFI:T:WPA;S:...;P:...;;`), exponiéndola visualmente a transeúntes u observadores de pantalla (*shoulder surfing*).
   - El uso del subcomando interactivo `baliza config <SSID> <PASSWORD>` almacena los argumentos en el historial de comandos del usuario (`~/.bash_history`) si no se ejecuta bajo entornos con espacio inicial o configuraciones específicas de `HISTCONTROL`.
3. **Congestión del Espectro en 2.4 GHz:**  
   Al ser un dispositivo de banda única (2.4 GHz), el enlace comparte espectro con hornos de microondas, periféricos Bluetooth y redes colindantes en canales solapados (canales 1, 6 y 11), lo que puede elevar la tasa de retransmisión de tramas en entornos urbanos densos.
4. **Segmento de Red Local:**  
   Por defecto, el servicio NAT provisto por NetworkManager / iptables enruta tráfico sin implementar aislamiento de clientes (*client isolation* en Capa 2), posibilitando que dispositivos en la misma subred `10.42.0.0/24` se comuniquen entre sí a menos que se definan reglas explícitas con `ebtables` o `nftables`.

---

## 7. Conclusiones y Trabajo Futuro

El proyecto **Baliza** demuestra de manera concluyente que la problemática de los adaptadores RTL8188EUS en distribuciones Linux contemporáneas no radica en una imposibilidad física del hardware, sino en un desajuste entre los drivers genéricos de la comunidad (`rtl8xxxu`) y la falta de mantenimiento de los drivers del fabricante frente a la evolución del kernel.

### Trabajo Futuro Planificado:
- **Integración DKMS Definitiva:** Incorporación de reglas de empaquetado nativas para el Arch User Repository (AUR) y Debian/Ubuntu PPA mediante `dkms.conf`.
- **Soporte de Chipsets Adicionales:** Extensión del framework hacia la familia Realtek RTL8812AU / RTL8821AU (doble banda 2.4 / 5 GHz).
- **Aislamiento de Clientes por Software:** Incorporación de reglas automáticas de filtrado de tráfico unicast entre estaciones para hotspots públicos o de invitados.

---

## 8. Referencias

1. **Linux Wireless Documentation:** *cfg80211 Subsystem and mac80211 Architecture*. [https://wireless.wiki.kernel.org/](https://wireless.wiki.kernel.org/)
2. **IEEE Computer Society:** *IEEE Standard for Information Technology - Telecommunications and information exchange between systems - Local and metropolitan area networks - Specific requirements - Part 11: Wireless LAN Medium Access Control (MAC) and Physical Layer (PHY) Specifications*. IEEE Std 802.11-2020.
3. **aircrack-ng:** *rtl8188eus Linux Driver Reference Tree*. [https://github.com/aircrack-ng/rtl8188eus](https://github.com/aircrack-ng/rtl8188eus)
4. **Realtek Semiconductor Corp.:** *RTL8188EUS Single-Chip IEEE 802.11b/g/n 1T1R WLAN Controller Datasheet*, Rev. 1.2.
5. **Torvalds, L., et al.:** *Linux Kernel Git Repository (commits on timer_delete_sync & cfg80211_ops modifications)*. [https://git.kernel.org/](https://git.kernel.org/)
