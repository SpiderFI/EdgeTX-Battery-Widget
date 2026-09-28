![banner](https://github.com/user-attachments/assets/a03a616a-3ba6-4947-ba4a-3166cc8b8812)

# Battery Widget for EdgeTX

A clean and highly configurable battery monitoring widget for **ColorLCD EdgeTX radios** (TX16S, TX15, GX15, etc.).

It displays a graphical battery bar with total and per-cell voltage, supports any cell count, works with virtually any battery telemetry sensor, and includes a customizable low-voltage alarm.

**Compatible with EdgeTX 2.12.3 and newer.**

---

## Features

### Display
- Graphical battery bar that fills proportionally according to your configured min/max cell voltages
- Shows both **total pack voltage** and **average cell voltage**
- Adaptive font sizing that looks good in every widget zone size
- High-quality battery outline that automatically scales while preserving aspect ratio
- Optional red **3.8 V storage voltage** marker

### Flexibility
- Works with **any battery telemetry sensor** (RxBt, VFAS, Cels, A1, custom sensors…)
- Supports **1–12 cells**
- Fully configurable full (CellMax) and empty (CellMin) voltages per cell
- Perfect for multi-battery / multi-widget setups
- Settings are saved **per widget instance**

### Alarms
- Customizable low-voltage WAV alarm (included `alarm.wav`)
- Alarm can be completely disabled
- Repeats approximately every 3 seconds while voltage is below the minimum

---

## Requirements

- EdgeTX 2.12.3 or newer
- Color LCD radio
- A battery voltage telemetry sensor

---

## Installation

1. Download the latest release or clone the repository.
2. Copy the entire `WIDGETS/Battery` folder to the `/WIDGETS/` directory on your radio’s SD card.
3. Restart the radio (or reload the model).
4. Go to the screen editor, choose a zone, and select **Battery**.

---

## Configuration

Long-press the widget → **Widget Settings**.

| Option        | Type     | Default | Description                                      | Range          |
|---------------|----------|---------|--------------------------------------------------|----------------|
| **BattSensor**| Source   | -       | Battery voltage telemetry sensor                 | Any source     |
| **Cells**     | Value    | 3       | Number of cells in the pack                      | 1 – 12         |
| **CellMax**   | Value    | 420     | Full charge voltage per cell (×100)              | 400 – 435      |
| **CellMin**   | Value    | 360     | Empty / cutoff voltage per cell (×100)           | 250 – 380      |
| **Alarm**     | Bool     | On      | Enable / disable the low voltage alarm           | On / Off       |
| **ShowStorage**| Bool    | Off     | Show red marker at 3.8 V storage voltage         | On / Off       |

> **Note:** CellMax and CellMin are entered as integers (e.g. `420` = 4.20 V).

---

## Tips

- You can place multiple instances of the widget on the same or different screens, each monitoring a different battery/sensor.
- To use a custom alarm sound, simply replace `alarm.wav` with your own file (same name).
- The widget automatically hides the total voltage when set to 1S (only cell voltage is shown).

---

## Author

**Mika Korhonen (Spider)**  
GitHub: [SpiderFI](https://github.com/SpiderFI)

---

## License

This project is provided as-is. Feel free to use, modify, and share.
