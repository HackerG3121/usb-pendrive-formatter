# 💾 USB Pendrive Formatter v3.0

A simple, cross-platform terminal script to **format USB pendrives quickly** — no third-party tools needed. Available for both **Windows** (Batch) and **Linux** (Bash).

![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Linux-blue)
![Windows](https://img.shields.io/badge/Windows-Batch%20Script-green)
![Linux](https://img.shields.io/badge/Linux-Bash%20Script-orange)
![License](https://img.shields.io/badge/License-MIT-yellow)
![Version](https://img.shields.io/badge/Version-3.0-red)

---

## ✨ Features

- Scans and lists all connected disks with size and model name
- Validates disk number input (numbers only)
- Confirmation screen before formatting (press **Enter** to confirm, **Ctrl+C** to cancel)
- Formats selected drive as **FAT32** with label `USBDRIVE`
- Clean terminal UI with color-coded output
- Error handling for invalid input
- Works on **Windows 10/11** and **Linux** (Ubuntu, Debian, Arch, etc.)

---

## 📋 Requirements

### Windows
- Windows 10 / 11
- Administrator privileges (required for `diskpart`)
- PowerShell (pre-installed on Windows)

### Linux
- Any modern Linux distro
- Root / `sudo` privileges
- Tools: `parted`, `wipefs`, `mkfs.fat` (part of `dosfstools`)

> **Install missing tools on Debian/Ubuntu:**
> ```bash
> sudo apt install parted dosfstools
> ```

> **Install missing tools on Arch:**
> ```bash
> sudo pacman -S parted dosfstools
> ```

---

## 🚀 How to Use

### 🪟 Windows

1. **Download** `format.bat` from this repository
2. **Right-click** the file → **Run as Administrator**
3. The script will scan and list all connected disks
4. **Enter the Disk Number** of the USB drive you want to format
5. Review the confirmation screen
6. Press **Enter** to confirm — formatting begins immediately

### 🐧 Linux

1. **Download** `format.sh` from this repository
2. Give it execute permission:
   ```bash
   chmod +x format.sh
   ```
3. Run it with `sudo`:
   ```bash
   sudo ./format.sh
   ```
4. The script will scan and list all connected disks
5. **Enter the Disk Number** of the USB drive you want to format
6. Review the confirmation screen
7. Press **Enter** to confirm — formatting begins immediately

---

## ⚠️ WARNING

> **ALL DATA on the selected disk will be permanently erased.**
> Make sure you select the correct disk number.
> **Do NOT select your system drive** (usually Disk 0 on Windows, or `/dev/sda` on Linux) — that will wipe your operating system.

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

  Enter Disk Number to Format  >>  1
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
 ┣ 📜 format.bat       ← Windows script (uses diskpart)
 ┣ 📜 format.sh        ← Linux script (uses parted + mkfs.fat)
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
