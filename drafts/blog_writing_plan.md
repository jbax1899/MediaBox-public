# **MediaBox – Master Structure Plan (for future blog posts & documentation)**
# drafts

This file is a writing outline only. It is not a source of current system truth.

## **0. Core Philosophy (High-Level Summary)**

* Offline-first, autonomy-focused portable server.
* Designed for education, travel, off-grid, resilience, and self-hosting.
* Modular by design: users choose which subsystems to include.
* Uses open-source software and commodity parts.
* Ruggedized and battery-backed for real-world reliability.

---

# **1. Blog Post #1 — “The MediaBox Devlog” (Long Narrative Post)**

### **1.1 What Problem MediaBox Solves**

* Offline classrooms
* Camps/off-grid environments
* Disaster relief
* Personal resilience
* Local-first computing
* Device-agnostic access (phones, tablets, laptops)

### **1.2 Goals of the Project**

* Make knowledge accessible without Internet
* Serve media libraries locally
* Run on solar power
* Provide small-scale AI offline
* Be rugged, maintainable, and serviceable
* Stay affordable (target ~$400–$600)

### **1.3 Evolution of the Hardware**

* Initial “bug-out box” prototype
* Adding educational services
* Adding AI capabilities
* Improvements to wiring, safety, fusing
* ABS insert box design and refinement
* Noise, heat, and serviceability considerations

### **1.4 Evolution of the Software Stack**

* Starting with Jellyfin/Kiwix
* Adding Kolibri/Kavita/ROMM
* Adding AI inference (Ollama with small models)
* Dashboard & UX improvements
* Captive portal / AP mode

### **1.5 Lessons Learned**

* Off-the-shelf parts vs custom
* The importance of service loops & wiring discipline
* Heat and power considerations
* Pelican case ergonomics
* Why busbars matter (and when they don’t)
* Rough cost breakdown vs commercial alternatives

### **1.6 Future Directions**

* Official build guide
* Modular kits
* Optional SDR receiver
* Optional extended solar
* Optional external antenna
* Optional “lite” and “pro” builds

---

# **2. Blog Post #2 — “How to Build Your Own MediaBox” (Clean Guide)**

## **2.1 Overview**

* What MediaBox is
* What it can do
* What the reader will build
* Safety disclaimers

## **2.2 Modular Build Configurations**

Offer 3–4 configurations depending on goals:

### **A. Educator Kit** (most practical)

* Pi 5 + NVMe
* Small battery
* Kolibri + Kiwix + Jellyfin + Dashy
* AP mode
* Optional solar input
* No SDR
* Medium budget (~$350–$450)

### **B. All-in-One “Full” Kit** (your build)

* Everything in the Educator Kit
* * ROMM
* * Local AI inference
* * SDR (optional)
* * Pelican ruggedization
* * Full-time battery and solar
* Budget (~$500–$700)

### **C. Minimal “Lite” Kit** (intro build)

* Pi 4 or Pi 5
* microSD or small SSD
* Kiwix + Kolibri only
* Simple plastic case
* No battery, no solar
* Budget (~$100–$200)

### **D. Radio-Focused Variant** (for scanning & spectrum capture)

* Added SDR
* Enhanced antenna
* Optional larger battery
* Optional external SMA port
* No NVMe required unless caching waterfalls
* Budget (~$250–$400)

---

# **3. Hardware Guide (For the Build Tutorial)**

## **3.1 Master BOM (Bill of Materials)**

Organize by subsystem:

### **Compute**

* Raspberry Pi 5 (8 GB recommended)
* NVMe HAT
* 1–3 TB NVMe SSDs
* USB hub (optional)

### **Power System**

* LiFePO₄ battery
* Charge controller (solar)
* AC charger
* Master switch (3-wire illuminated)
* Inline fuses
* Wiring (10 AWG + 14–18 AWG)
* Junction posts (M8)
* Buck converter (12→5 V)

### **Container + Internal Structure**

* Pelican 1400
* ABS sheets
* Plastic L-brackets
* Wooden 3/8" dowels
* Cabinet handle
* Screws, washers, nuts
* Heatshrink, cable ties

### **Optional**

* SDR dongle
* Secondary solar panel
* Voltage display
* External SMA jack for antenna
* Fans or heat sinks

---

# **4. Build Process Outline**

## **4.1 Enclosure Construction**

1. Cut ABS panels (front, sides, bottom, top).
2. Assemble box with brackets (14–16 total).
3. Add dowel posts under handle mounting points.
4. Mount cabinet handle.
5. Prepare the back service panel.
6. Test-fit inside foam cavity.
7. Route strain-relief notches.
8. Add optional airflow vents.

## **4.2 Electrical System Assembly**

1. Install junction studs (positive + negative).
2. Install battery and main inline fuse.
3. Mount charge controller, buck converter, Pi.
4. Route wiring cleanly with zip ties and mounts.
5. Connect master switch (IN/OUT/GND).
6. Connect all low-voltage loads.
7. Add secondary fuses as needed.
8. Perform continuity and polarity checks.

## **4.3 Software Setup**

1. Base OS install (Raspberry Pi OS Lite).
2. Set up AP mode + captive portal.
3. Install each service:

   * Kiwix
   * Kolibri
   * Jellyfin
   * Kavita
   * ROMM
   * Dashy homepage
   * Ollama (optional)
4. Optimize performance for Pi 5.
5. Load content (Wikipedia ZIMs, courses, media).
6. Configure backups + auto-start services.

## **4.4 Final Assembly**

1. Insert box into foam cavity.
2. Route external ports if any.
3. Add labels, wire diagrams, and documentation inside the lid.
4. Perform load testing and battery runtime tests.

---

# **5. Documentation Materials to Produce**

These you can generate gradually:

### **Technical Documentation**

* Wiring diagram (positive/negative paths, fuses, switch logic).
* ABS cutting layout (for 12×16 sheets).
* Exploded view of enclosure.
* Assembly order drawings.
* Software install script (one-command setup).

### **User Documentation**

* First-time setup guide
* How to update content
* How to back up NVMe data
* How to swap the battery
* How to use Kolibri and Kiwix
* How to reset AP mode

### **Optional Extras**

* Printable sticker labels
* SVG template for front panel cutouts
* Bill of Materials in spreadsheet format

---

# **6. Future Expansion Ideas**

* External antenna for SDR variant
* Second onboard battery
* USB-C PD input instead of barrel jack
* Dedicated UPS board
* Onboard temperature and humidity logging
* Expandable content storage via USB
* 3D-printable internal brackets
* Waterproof external power port
* Classroom “multi-box” mesh network mode
