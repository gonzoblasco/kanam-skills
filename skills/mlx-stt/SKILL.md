---
name: "mlx-stt"
description: "Speech-to-text local en Apple Silicon con MLX"
---

# mlx-stt

## Descripción
Ejecuta transcripción de speech-to-text localmente en Apple Silicon usando MLX y modelos open-source. Sin API key ni servidor externo. Modelo default: GLM-ASR-Nano-2512. Todo corre en el dispositivo.

## Cuándo usarlo
- Para transcribir meetings o entrevistas grabadas
- Para convertir voice memos a texto
- Para generar captions de videos almacenados localmente
- Para transcribir episodios de podcast offline
- Para convertir notas de audio en texto buscable

## Workflow
1. Tener el archivo de audio disponible localmente
2. Ejecutar mlx-stt con la ruta del archivo
3. Esperar la transcripción (corre localmente en Apple Silicon)
4. Recibir el texto transcrito

## Notas
- Requiere Apple Silicon (M1 o posterior) — MacBook Air M2 compatible
- Sin costo de API, sin datos que salgan de la máquina
- Modelo open-source, sin dependencia de servicios cloud
