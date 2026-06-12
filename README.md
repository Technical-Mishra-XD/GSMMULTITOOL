<div align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=0:0b1120,100:1e2a5e&height=180&section=header&text=GSM%20Multi-Tool&fontSize=42&fontColor=38bdf8&animation=fadeIn" width="100%">
  
  <h1>
    <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Objects/Telephone.png" alt="GSM" width="35" height="35"/>
    GSM Multi-Tool
    <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Travel%20and%20Places/Satellite%20Antenna.png" alt="Antenna" width="35" height="35"/>
  </h1>
  
  <p>
    <strong>⚡ The Ultimate Swiss Army Knife for GSM Analysis, Pentesting & Network Diagnostics ⚡</strong>
  </p>
  
  <!-- Badges -->
  <p>
    <img src="https://img.shields.io/badge/version-3.2.0-blue?style=for-the-badge&logo=github">
    <img src="https://img.shields.io/badge/Python-3.11+-3776AB?style=for-the-badge&logo=python&logoColor=white">
    <img src="https://img.shields.io/badge/License-GPLv3-green?style=for-the-badge">
    <img src="https://img.shields.io/badge/Platform-Linux%20%7C%20macOS%20%7C%20ARM-informational?style=for-the-badge&logo=linux">
    <img src="https://img.shields.io/github/stars/gsm-lab/gsm-multi-tool?style=for-the-badge&logo=github&color=yellow">
  </p>
  
  <p>
    <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&pause=1000&color=38BDF8&center=true&vCenter=true&width=500&lines=Scan+%7C+Audit+%7C+Analyze;SIM+Toolkit+%7C+SDR+Integration;Real-time+Cell+Monitoring" alt="Typing Animation" />
  </p>
</div>

---

## 📡 About

**GSM Multi-Tool** is a powerful, modular suite for **telecom engineers**, **security researchers**, and **enthusiasts**.  
It provides low-level access to GSM infrastructure — from band scanning and SIM interrogation to false base station detection.

> ✅ Works with **RTL-SDR**, **HackRF**, **BladeRF** & virtual test mode

---

## ✨ Features

<div align="center">
  
| 🚀 Module | 📖 Description |
|-----------|----------------|
| **Band Scanner** | Real-time GSM 900/1800/850/1900 scanning & signal plotting |
| **SIM Toolkit Pro** | Read IMSI, ICCID, SMS, contacts, decode ADN/EF files |
| **Security Audit** | False BTS detection, A5/1-A5/3 cipher verification |
| **Packet Sniffer** | Capture GPRS/UMTS traffic, decode L2/L3 protocols |
| **Geolocation** | Map-based tower tracking + OpenCellID integration |
| **Scripting API** | Python bindings + REST API for automation |

</div>

---

## 🚀 Quick Install

```bash
# Clone the repository
git clone https://github.com/gsm-lab/gsm-multi-tool.git
cd gsm-multi-tool

# Install dependencies (Ubuntu/Debian)
sudo apt update && sudo apt install -y librtlsdr0 hackrf libusb-1.0-0
pip3 install -r requirements.txt

# Run the interactive tool
python3 gsm_tool.py --mode interactive
