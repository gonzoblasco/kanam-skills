---
name: "network-scanner"
description: "Escáner de red local para descubrir dispositivos"
---

# network-scanner

## Descripción
Escanea redes locales usando nmap para descubrir dispositivos conectados y recolectar sus direcciones IP, MAC, vendor names y hostnames via reverse DNS. Bloquea rangos de IP públicas y blocklists para prevenir escaneos accidentales.

## Cuándo usarlo
- Para verificar qué dispositivos están conectados a la red local
- Para identificar un dispositivo desconocido por su MAC address y vendor
- Para generar un inventario de dispositivos para documentación de red
- Para detectar nuevos dispositivos en la red
- Para presencia detection automatizada

## Workflow
1. Ejecutar network-scanner
2. Esperar que nmap escanee la red local
3. Recibir lista de dispositivos: IP, MAC, vendor, hostname
4. Revisar dispositivos conocidos vs desconocidos

## Tooling relacionado

| Skill / Script | Uso |
|---|---|
| `clawdstrike` | Auditoría de seguridad del gateway y red después de descubrir dispositivos. |
| `observability/scripts/health-check.sh` | Verificar salud de servicios en dispositivos descubiertos. |

## Notas
- Requiere nmap instalado (brew install nmap)
- Requiere sudo para MAC address discovery
- Built-in safety blocks previenen escaneo de rangos públicos
