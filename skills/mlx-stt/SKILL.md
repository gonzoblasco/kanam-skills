---
name: "mlx-stt"
description: "Local speech-to-text on Apple Silicon with MLX"
---

# mlx-stt

## Description
Runs speech-to-text transcription locally on Apple Silicon using MLX and open-source models. No API key or external server needed. Default model: GLM-ASR-Nano-2512. Everything runs on the device.

## When to use it
- To transcribe recorded meetings or interviews
- To convert voice memos to text
- To generate captions for locally stored videos
- To transcribe podcast episodes offline
- To turn audio notes into searchable text

## Workflow
1. Have the audio file available locally
2. Run mlx-stt with the file path
3. Wait for the transcription (it runs locally on Apple Silicon)
4. Receive the transcribed text

## Notes
- Requires Apple Silicon (M1 or later) - MacBook Air M2 compatible
- No API cost, no data leaves the machine
- Open-source model, no dependency on cloud services
