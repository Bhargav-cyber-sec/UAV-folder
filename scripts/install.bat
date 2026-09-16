@echo off
setlocal enabledelayedexpansion
set LOG=install_log.txt
echo Install started: %date% %time% > %LOG%

echo [0/13] Verifying wheelhouse integrity (checking for transfer corruption)...
powershell -ExecutionPolicy Bypass -File scripts\verify_hashes.ps1 >> %LOG% 2>&1
if errorlevel 1 (echo Wheelhouse integrity check FAILED — re-transfer the package & goto :fail)

echo [1/13] Checking Python...
python --version >> %LOG% 2>&1
if errorlevel 1 (echo Python not found on PATH & goto :fail)

echo [2/13] Checking architecture...
python -c "import platform; print(platform.machine())" >> %LOG% 2>&1

echo [3/13] Creating virtual environment...
python -m venv venv >> %LOG% 2>&1
if errorlevel 1 goto :fail

echo [4/13] Installing from local wheelhouse (offline, no index)...
venv\Scripts\pip install --no-index --find-links=wheelhouse -r requirements.txt >> %LOG% 2>&1
if errorlevel 1 goto :fail

echo [5/13] Verifying core imports...
venv\Scripts\python -c "import yaml, dotenv, click" >> %LOG% 2>&1
if errorlevel 1 goto :fail

echo [6/13] Checking FFmpeg on PATH...
ffmpeg -version >> %LOG% 2>&1
if errorlevel 1 (echo FFmpeg missing from PATH & goto :fail)

echo [7/13] Checking YOLO weights present... (skipped until Phase 3)
echo [8/13] Checking Whisper model present... (skipped until Phase 6)
echo [9/13] Checking Ollama binary... (skipped until Phase 8)
echo [10/13] Checking local Qwen model pulled... (skipped until Phase 8)
echo [11/13] Checking Piper TTS voices... (skipped until Phase 9)
echo [12/13] Checking Streamlit launches... (skipped until Phase 9)

echo [13/13] Running smoke test (config loader)...
venv\Scripts\python -m src.config >> %LOG% 2>&1
if errorlevel 1 goto :fail

echo.
echo Install completed successfully: %date% %time% >> %LOG%
echo INSTALL OK — see %LOG% for details
goto :eof

:fail
echo.
echo INSTALL FAILED — see %LOG% for details
exit /b 1