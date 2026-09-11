# UAV Intelligence Engine

Offline, air-gapped, multi-modal UAV mission analysis pipeline.
Raw UAV footage -> event detection -> adaptive highlight reel -> multilingual
transcript -> fused evidence -> local LLM summary -> TTS briefing + PDF report
-> Streamlit UI. Designed to run fully offline on a Windows workstation with
an NVIDIA Quadro P2000 (4GB VRAM).

## Status

Phase 1 — Environment & project skeleton. Nothing else is implemented yet;
this repo grows phase by phase, each phase tagged as `vX.Y-phaseN`.

## Repo layout

```
config/         YAML configs (event ontology, scoring weights, paths)
src/media/      ffprobe/ffmpeg wrappers, frame sampling  (Phase 2)
src/vision/     YOLO + ByteTrack, motion-compensated CV change detection (Phase 3-4)
src/fusion/     Event scoring engine, evidence.json builder (Phase 4, 7)
src/audio/      Faster-Whisper pipeline (Phase 6)
src/llm/        Ollama/Qwen3 prompt + schema handling (Phase 8)
src/tts/        Piper TTS wrapper (Phase 9)
src/report/     ReportLab PDF generation (Phase 9)
src/ui/         Streamlit app (Phase 9)
scripts/        install.bat, smoke tests, dev utilities
tests/          unit + integration tests
docs/           architecture notes, evaluation results
wheelhouse/     (gitignored) offline pip wheels — built at home, transferred separately
models/         (gitignored) YOLO/Whisper/Qwen/Piper weights — never committed
```

## Setup (Windows, at home — internet available)

```powershell
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
```

## Offline install (facility PC — no internet)

See `scripts/install.bat`. It installs strictly from the local `wheelhouse/`
via `pip install --no-index`.

## Phase plan

1. Environment + project skeleton  <- we are here
2. Media ingestion (ffprobe, frame sampling)
3. YOLO + ByteTrack
4. CV change detection + event scoring engine
5. Highlight generation (FFmpeg)
6. Faster-Whisper audio pipeline
7. Evidence fusion + keyframe captioning
8. Qwen3 (text) reasoning over evidence.json
9. TTS + PDF report + Streamlit UI
10. Offline install validation + end-to-end testing at the facility

Full design rationale: see `docs/design_review.md`.
