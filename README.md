# UAV Intelligence Engine

Offline, air-gapped, multi-modal UAV mission analysis pipeline.
Raw UAV footage -> event detection -> adaptive highlight reel -> multilingual
transcript -> fused evidence -> local LLM summary -> TTS briefing + PDF report
-> Streamlit UI. Designed to run fully offline on a Windows 10 Pro workstation
(Intel Xeon E-2176M, 16GB RAM, NVIDIA Quadro P2000 4GB, 1TB storage,
Python 3.10). No CUDA toolkit, Ollama, or local LLM runtime is present on
that machine yet — the whole pipeline runs CPU-only until/unless that
changes. Built solo; timeline target is 6-8 weeks.

## Status

Week 1 (`v0.1.0`) — Environment & project skeleton, done. Nothing else is
implemented yet; this repo grows week by week, each milestone tagged
`vX.Y.0` (see Phase plan below for what each version covers).

## Repo layout

```
config/         YAML configs (event ontology, scoring weights, paths)
src/media/      ffprobe/ffmpeg wrappers, frame sampling  (Week 1)
src/vision/     YOLO + ByteTrack, motion-compensated CV change detection (Week 2)
src/fusion/     Event scoring engine, evidence.json builder (Week 3-4)
src/audio/      Faster-Whisper pipeline (Week 4)
src/llm/        Ollama/Qwen3 prompt + schema handling (Week 5)
src/tts/        Piper TTS wrapper (Week 6)
src/report/     ReportLab PDF generation (Week 6)
src/ui/         Streamlit app (Week 6)
scripts/        install.bat, build_wheelhouse.bat, smoke tests, dev utilities
tests/          unit + integration tests
docs/           architecture notes, known limitations, evaluation results
wheelhouse/     (gitignored) offline pip wheels, cp310/win_amd64 — built at
                home, transferred separately (see docs/known_limitations.md)
models/         (gitignored) YOLO/Whisper/Qwen/Piper weights — never committed
```

## Setup (Windows, at home — internet available)

Target is Python 3.10 specifically (confirmed on the facility PC) — use the
`py` launcher if 3.10 isn't your system default:

```powershell
py -3.10 -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
```

## Offline install (facility PC — no internet)

See `scripts/install.bat`. It installs strictly from the local `wheelhouse/`
via `pip install --no-index`. Build the wheelhouse first with
`scripts\build_wheelhouse.bat` (run at home). FFmpeg and Ollama are not pip
packages and are not yet on the facility PC — they need to be bundled as
standalone binaries in the transfer package alongside the wheelhouse; see
`docs/known_limitations.md` items #10-11.

## Phase plan (6-8 week target, condensed from the original 10-phase design)

| Week | Covers | Tag |
|---|---|---|
| 1 | Environment + media ingestion (ffprobe, frame sampling) | `v0.1.0` (done) |
| 2 | YOLO + ByteTrack + CV change detection | `v0.2.0` |
| 3 | Event scoring engine + highlight generation | `v0.3.0` |
| 4 | Faster-Whisper audio pipeline + evidence fusion | `v0.4.0` |
| 5 | Keyframe captioning + Qwen3 reasoning | `v0.5.0` |
| 6 | TTS + PDF + Streamlit, full integration | `v0.6.0` |
| 7 | Offline install validation, bug fixes | `v0.9.0` |
| 8 (buffer) | Facility testing, polish, final fixes | `v1.0.0` |

Full design rationale: see `docs/design_review.md`. Known gaps and their
fixes: see `docs/known_limitations.md`.