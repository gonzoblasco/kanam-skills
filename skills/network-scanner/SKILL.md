---
name: "network-scanner"
description: "Local network scanner to discover devices"
---

# network-scanner

## Description
Scans local networks using nmap to discover connected devices and collect their IP addresses, MAC, vendor names and hostnames via reverse DNS. Blocks public IP ranges and blocklists to prevent accidental scans.

## When to use it
- To check which devices are connected to the local network
- To identify an unknown device by its MAC address and vendor
- To generate a device inventory for network documentation
- To detect new devices on the network
- For automated presence detection

## Workflow
1. Run network-scanner
2. Wait for nmap to scan the local network
3. Receive the device list: IP, MAC, vendor, hostname
4. Review known vs unknown devices

## Related tooling

| Skill / Script | Use |
|---|---|
| `clawdstrike` | Gateway and network security audit after discovering devices. |

## Notes
- Requires nmap installed (brew install nmap)
- Requires sudo for MAC address discovery
- Built-in safety blocks prevent scanning public ranges
