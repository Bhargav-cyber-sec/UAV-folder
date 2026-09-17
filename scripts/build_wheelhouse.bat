@echo off
setlocal enabledelayedexpansion
REM Run this at HOME (internet available). Builds the full offline wheelhouse
REM for everything Phases 1-6 need, pinned to the facility PC's Python/platform.
REM
REM torch/torchvision and ultralytics are handled as SEPARATE steps below,
REM deliberately not just listed in requirements.txt — see the comments in
REM requirements.txt for why (short version: avoids silently downloading a
REM multi-GB CUDA-bundled torch build on CPU-only hardware).
REM
REM IMPORTANT: this script calls "py -3.10 -m pip download", NOT plain
REM "python -m pip download". --python-version 310 alone only controls which
REM wheel TAGS pip looks for; it does NOT control how pip evaluates
REM conditional dependencies like "exceptiongroup; python_version < '3.11'" -
REM that's evaluated using whatever Python is actually RUNNING pip. If your
REM system's plain "python" resolves to a different version (it does here -
REM 3.14), those conditional dependencies get silently evaluated wrong and
REM quietly missing from the wheelhouse. Running via "py -3.10" fixes this
REM at the root instead of patching missing packages one at a time.

set PYVER=310
set PLATFORM=win_amd64
set OUTDIR=wheelhouse

echo Building offline wheelhouse for cp%PYVER% / %PLATFORM%
echo Output: %OUTDIR%\
echo.

if not exist %OUTDIR% mkdir %OUTDIR%

echo [1/3] Downloading torch + torchvision from PyTorch's CPU-only index...
echo       (NOT the default PyPI index - this is what keeps this small and CUDA-free)
py -3.10 -m pip download torch torchvision ^
    --index-url https://download.pytorch.org/whl/cpu ^
    -d %OUTDIR% ^
    --python-version %PYVER% ^
    --platform %PLATFORM% ^
    --only-binary=:all:

if errorlevel 1 (
    echo.
    echo FAILED downloading torch/torchvision CPU build. Check your internet
    echo connection and that download.pytorch.org is reachable, then retry.
    exit /b 1
)

echo.
echo [2/3] Downloading ultralytics itself, --no-deps (its dependency list
echo       includes torch, which we already fetched correctly above - letting
echo       it resolve normally would re-trigger the CUDA-wheel problem)...
py -3.10 -m pip download ultralytics --no-deps ^
    -d %OUTDIR% ^
    --python-version %PYVER% ^
    --platform %PLATFORM% ^
    --only-binary=:all:

if errorlevel 1 (
    echo.
    echo FAILED downloading ultralytics. Check the package name/version, then retry.
    exit /b 1
)

echo.
echo [3/3] Downloading everything else from requirements.txt (default PyPI)...
py -3.10 -m pip download -r requirements.txt ^
    -d %OUTDIR% ^
    --python-version %PYVER% ^
    --platform %PLATFORM% ^
    --only-binary=:all:

if errorlevel 1 (
    echo.
    echo FAILED - a package in requirements.txt has no matching wheel for
    echo cp%PYVER%/%PLATFORM%. Check the package name/version above and adjust
    echo requirements.txt.
    exit /b 1
)

echo.
echo Recording wheelhouse contents for reproducibility (filenames, not
echo "pip freeze" - freeze would reflect whatever Python ran this script,
echo not what's actually in the wheelhouse)...
dir /b %OUTDIR%\*.whl > %OUTDIR%\..\versions.txt

echo.
echo Computing checksums for integrity verification after transfer...
powershell -ExecutionPolicy Bypass -File scripts\compute_hashes.ps1

echo.
echo Done. Wheelhouse ready at %OUTDIR%\
echo Files:
dir /b %OUTDIR%
echo.
echo Next: zip the whole project folder (including wheelhouse\, versions.txt,
echo hashes.sha256, tools\) and transfer it to the facility PC via your
echo approved channel. On the facility PC, run scripts\install.bat.
echo.
echo NOTE: Ollama, the Qwen model file, the Whisper model file, and Piper
echo voices are NOT included here - those come later, once Phases 4/5/6 are
echo actually written and the exact model choices are locked in.