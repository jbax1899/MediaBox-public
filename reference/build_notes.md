# MediaBox Build Notes

> Draft prototype notes. This is the factual record of one specific MediaBox build, not the current operational manual.

Keep active inventory in `docs/system-map.md` and service-facing guidance in `docs/device_manual.md`.

## Overview
The MediaBox is a portable homelab-in-a-box system built inside a Pelican 1400 case. It functions as a self-contained computing and networking platform designed to operate both on AC power and solar energy. The system hosts a Raspberry Pi 5, peripherals, and external connectivity components including Wi-Fi and SDR modules.

The build prioritizes modularity, safety, and clear power distribution for later revisions.

---

## Core Goals
- **Dual Power Input:** Operate via 120V AC or solar panel (SAE/MC4 input).
- **Efficient Power Management:** Regulated 12V DC distribution with fusing and switch control.
- **Expandable Design:** Unused 12V switches reserved for future peripherals.
- **Ease of Service:** Modular wiring, fuse access, and panel-mounted interfaces.
- **Transparent Operation:** Voltmeter, LED indicators, and master switch for clear visual feedback.

---

## Current Components

### Power Input and Conversion
- **Shore Power Inlet Plug** (NEMA 5-15): main 120V AC inlet with waterproof cover and 18" extension cord.
- **Battery Charger (wall wart):** LiFePO₄-compatible charger for the Talentcell battery.
- **Solar Input:** SAE sidewall port with optional MC4-to-SAE adapter.
- **Charge Controller:** PWM solar controller managing battery charging from solar input.
- **Talentcell LiFePO₄ 12V 6Ah Battery Pack:** 12.8V, 76.8Wh, with internal BMS protection.
- **Inline Fuse Holders (12 AWG):** 4-pack with assorted 5–40A blade fuses.

### Power Distribution
- **Nilight 5-Gang Rocker Switch Panel:** integrated voltmeter, dual USB charger, and 12V outlet. Each switch individually fused.
- **DPDT Nilight Rocker Switch:** for selecting Solar vs. AC input, with indicator lighting.
- **Buck Converter (50V→Adjustable 5–12V):** 1000W module with LCD voltage/current display.
- **14 AWG Dual-Conductor Cable:** used for main 12V wiring runs.

### Control and Monitoring
- **Main Master Switch:** inserted between battery and buck converter to minimize idle drain.
- **Voltmeter:** displays live system voltage.
- **LED Indicators:** integrated into switch panel and power selector.

---

## Connectivity and I/O
- **Raspberry Pi 5** with UPS HAT (3× 18650 Li-ion backup cells).
- **RAOYI Powered USB 3.0 Hub (8-Port, 36W):** mounted inside case, feeds peripherals and external access ports.
- **RJ45 Panel Mount (CAT6, weatherproof):** external Ethernet pass-through.
- **Wi-Fi Dongle & USB SDR Module:** positioned externally via the hub for best signal.

---

## Planned Power Mapping
| Switch | Function | Fuse | Notes |
|---------|-----------|-------|--------|
| 1 | Raspberry Pi / Core System | 5A | via buck converter |
| 2 | Powered USB Hub | 5A | powered via 12V rail |
| 3 | Cooling Fan | 3A | small DC fan in case side |
| 4 | AUX 12V Output | 5A | panel or binding posts for future devices |
| 5 | LED Worklight | 1–2A | lid-mounted strip for night use |

---

## Enclosure and Layout
- Case: **Pelican 1400**, operated open (lid up).
- Power/control panel: custom flat insert (potentially faux wood finish).
- Switches, ports, voltmeter, and USB hub positioned along upper panel.
- Battery and wiring routed behind/below the panel with ventilation space.

### Cooling and Protection
- Case intended to run open for airflow.
- Optional **netted lid cover** planned for dust/light rain shielding.
- All fuses and main battery switch accessible for service.

---

## Notes for Next Phase
Once all parts arrive:
1. Verify each module’s voltage and polarity before integration.
2. Wire main positive rail through the master rocker switch.
3. Confirm individual switch fuses correspond to expected loads.
4. Test solar and AC charging paths independently before parallel connection.
5. Mount USB hub and route cable runs for clean access to SDR/Wi-Fi dongles.

After assembly, a follow-up documentation update will diagram:
- Actual wire routing
- Grounding configuration
- Measured idle and load currents
- Runtime and charge test results

---

## Related Future Notes

- `planning/extension_pi3_sensors_monitor.md` tracks the separate admin console and telemetry idea.
