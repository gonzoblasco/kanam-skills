---
name: "clawdstrike"
description: "Security audit del gateway OpenClaw"
---

# clawdstrike

## Descripción
Ejecuta una auditoría de seguridad contra un deployment de OpenClaw gateway. Evalúa exposición de red, estado del firewall, higiene del filesystem, supply chain de plugins, y claves de configuración. Emite reporte OK/VULNERABLE con niveles de severidad, evidencia redactada e instrucciones de fix.

## Cuándo usarlo
- Para verificar si el gateway OpenClaw es reachable desde fuera de la red local
- Para auditar skills y plugins de terceros por riesgos de supply chain
- Para verificar configuración de firewall y puertos en el host
- Para revisar permisos de filesystem y symlinks en la máquina gateway
- Para producir un reporte de seguridad compartible antes de dar acceso al equipo

## Workflow
1. Ejecutar clawdstrike
2. El script recolecta información del sistema (verified allowlist)
3. Evalúa contra checklist de seguridad
4. Produce reporte con severidad, evidencia y fix instructions
5. Revisar reporte y aplicar fixes según prioridad

## Tooling relacionado

| Skill / Script | Uso |
|---|---|
| `code-review-and-quality` | Escaneo de secrets y hardcoded URLs en archivos del workspace (absorbio a review-quality). |
| `engineering-governance/scripts/secret-scan.sh` | Escaneo adicional de credenciales en skills y configuración. |
| `pre-deploy-qa/scripts/pre-deploy-check.sh` | Validar seguridad del entorno antes de deployar. |
| `arc-trust-verifier` | Evaluar confiabilidad de skills y plugins de terceros (supply chain). |

## Notas
- Opera desde una verified allowlist estricta
- No ejecuta código remoto no confiable
- No modifica el estado del sistema
