# 🖥️ VM Orchestrator

> Production-grade VirtualBox VM lifecycle manager with SSH automation and graceful shutdown for Linux environments

Automate your VirtualBox VM workflow: start headless VMs → wait for SSH readiness → connect via terminal → auto-shutdown on exit. Built for Linux Mint/XFCE with enterprise-grade reliability.

![VM Orchestrator Demo](https://via.placeholder.com/800x400/2c3e50/ffffff?text=VM+Orchestrator+in+Action) <!-- Replace with actual screenshot later -->

## ✨ Features

- **Zero-touch automation**: One command to start VM + connect via SSH
- **Graceful shutdown**: ACPI-powered VM shutdown after SSH exit (no data corruption)
- **SSH banner verification**: Waits for actual SSH service readiness (not just open port)
- **First-boot safe**: Built-in grace periods for slow Ubuntu Server initialization
- **Idempotent operations**: Safe to run repeatedly (no duplicate VM instances)
- **Production logging**: Structured timestamped logs with error diagnostics
- **XFCE-optimized**: Native terminal integration with visual feedback
- **Environment-driven config**: Override all settings via environment variables
- **Resource-safe**: Automatic timeout protection prevents infinite hangs

## 🛠️ Prerequisites

### Host System (Linux Mint/XFCE)
```bash
# Required packages
sudo apt install -y virtualbox virtualbox-guest-additions-iso xfce4-terminal netcat-openbsd
