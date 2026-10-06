# HikvisionExploiter

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

**HikvisionExploiter** is a powerful and automated exploitation toolkit targeting unauthenticated endpoints on **Hikvision IP cameras**, particularly those running firmware version **3.1.3.150324**.

It performs:
- Snapshot access verification
- Config file retrieval and decryption
- User credential extraction
- Remote command execution using CVE-2021-36260
- Multithreaded target scanning with colored, timestamped logs

> Built for researchers, red teamers, and IoT security enthusiasts.

---

## 📚 Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Shell Access](#shell-access)
- [Finding Targets](#finding-targets)
- [Nuclei Template](#nuclei-template)
- [License](#license)

---

## ✅ Features

- 🔓 **Directory Check**: Verifies `/onvif-http/snapshot` endpoint for snapshot exposure
- 📸 **Snapshot Retrieval**: Downloads snapshots and stores them in timestamped folders
- 🛰️ **Device Info Dump**: Parses device model, serial, firmware, and build data
- 👥 **User Info Dump**: Extracts usernames and privilege levels from XML
- 🔐 **Config Decryption**: Downloads encrypted `/System/configurationFile`, decrypts using AES + XOR, and extracts credentials
- 💣 **CVE-2021-36260 Detection**:
  - Header bypass check on `/Security/users`
  - PUT-to-file RCE check via `webLanguage` injection
- 🖥️ **Remote Shell Support**: Built-in Bash shell for remote command execution
- 📁 **Organized Logs**: Creates structured logs per IP:port in `logs/`
- ⚡ **Mass Scanning**: Supports thousands of targets using `ThreadPoolExecutor`
- 🎨 **Colorized Output**: Easily distinguishable results with ANSI colors

---

## 🧰 Requirements

- Python **3.6+**
- `pip install -r requirements.txt`
- `ffmpeg` (optional, for future snapshot-to-video capability)
- `pycrypto` (for config decryption):
  ```sh
  pip install pycrypto
  ```

---

## 📥 Installation

```sh
git clone https://github.com/HexBuddy/HikvisionExploiter.git
cd HikvisionExploiter
pip3 install -r requirements.txt
```

---

## 🚀 Usage

### 1. Prepare Targets

Create a `targets.txt` file with the following format:

```
IP:PORT
```

Example:

```
192.168.1.10:80
10.10.10.20:81
```

### 2. Run the Scanner

```sh
python3 checker.py
```

This will:
- Check for snapshot access
- Download and parse device/user info
- Attempt config file decryption
- Test for RCE via CVE-2021-36260
- Save all logs under `logs/IP_PORT_TIMESTAMP/`

---

## 🐚 Shell Access

To interactively run commands on a vulnerable device:

```sh
chmod +x shell.sh
./shell.sh <ip:port>
```

Example:

```sh
./shell.sh 192.168.1.10:80
```

If vulnerable, you'll enter an interactive shell:

```
hikvision-shell> uname -a
Linux hik-cam 3.0.8 #1 Wed Mar 18 ...
```

---

## 🔎 Finding Targets

Use the following **Shodan dork** to locate exposed Hikvision cameras:

```
3.1.3.150324
```

---

## 📄 Nuclei Template

A Nuclei-compatible template is included: `nuclei-template.yaml`

Usage:

```sh
nuclei -t nuclei-template.yaml -list targets.txt
```

Detects:
- Open snapshot feed
- Exposed config download
- Leaked user info via XML

---


## ⚖️ License

MIT License ©

See [LICENSE](LICENSE) for more details.

---

> Telegram: [@HexBuddy127001](https://t.me/HexBuddy127001)
>  
> Built with ❤️ for educational and ethical research only.


---

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=tamim1089/HikvisionExploiter&type=date&legend=top-left)](https://www.star-history.com/#tamim1089/HikvisionExploiter&type=date&legend=top-left)
