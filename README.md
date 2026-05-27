# 💾 USB Pendrive Formatter v3.0

A simple Windows batch script to **format USB pendrives** quickly using `diskpart` — no third-party tools needed.

![Platform](https://img.shields.io/badge/Platform-Windows-blue)
![Language](https://img.shields.io/badge/Language-Batch%20Script-green)
![License](https://img.shields.io/badge/License-MIT-yellow)
![Version](https://img.shields.io/badge/Version-3.0-orange)

---

## ✨ Features

- Scans and lists all connected disks with size and model name
- Validates disk number input (numbers only)
- Confirmation screen before formatting (press **Enter** to confirm)
- Formats selected drive as **FAT32** with label `USBDRIVE`
- Clean and simple terminal UI with color-coded output
- Error handling for invalid input

---

## 📋 Requirements

- Windows 10 / 11
- Administrator privileges (required for `diskpart`)
- PowerShell (pre-installed on Windows)

---

## 🚀 How to Use

1. **Download** `format.bat` from this repository
2. **Right-click** the file → **Run as Administrator**
3. The script will scan and list all connected disks
4. **Enter the Disk Number** of the USB drive you want to format
5. Review the confirmation screen
6. Press **Enter** to confirm — formatting begins immediately

---

## ⚠️ WARNING

> **ALL DATA on the selected disk will be permanently erased.**
> Make sure you select the correct disk number.
> **Do NOT select Disk 0** — that is usually your main system drive.

---

## 📸 Preview

```
+--------------------------------------------------+
*        USB PENDRIVE FORMATTER  v3.0             *
+--------------------------------------------------+

  Scanning connected disks...

+--------+----------+----------------------------+
*  Disk  *   Size   *   Model / Name             *
+--------+----------+----------------------------+
*   0    *  477 GB  *  NVMe SAMSUNG MZALQ512HBLU *
*   1    *   30 GB  *  MXT-USB Storage Device    *
+--------+----------+----------------------------+

  Total Disks Found : 2
```

---

## 🛠️ Format Details

| Property     | Value        |
|--------------|--------------|
| File System  | FAT32        |
| Format Type  | Quick Format |
| Volume Label | USBDRIVE     |

---

## 📁 Files

```
📦 usb-pendrive-formatter
 ┣ 📜 format.bat       ← Main script
 ┣ 📜 README.md        ← This file
 ┗ 📜 LICENSE          ← MIT License
```

---

## 👤 Author

**HackerG3121**
GitHub: [@HackerG3121](https://github.com/HackerG3121)

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.
