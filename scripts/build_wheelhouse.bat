@echo off
setlocal enabledelayedexpansion
REM Run this at HOME (internet available). It downloads every package in
REM requirements.txt, plus its full transitive dependency tree, as .whl files
REM pinned to the facility PC's target Python/platform — NOT whatever Python
REM version happens to be running this script. This is what makes the
REM wheelhouse actually installable offline later via install.bat.
REM
REM Edit PYVER below once you've confirmed the exact Python version installed
REM on the facility PC (it must match, per docs/design_review.md section 14).

set PYVER=311
set PLATFORM=win_amd64
set OUTDIR=wheelhouse

echo Building offline wheelhouse for cp%PYVER% / %PLATFORM%
echo Output: %OUTDIR%\
echo.

if not exist %OUTDIR% mkdir %OUTDIR%

python -m pip download -r requirements.txt ^
    -d %OUTDIR% ^
    --python-version %PYVER% ^
    --platform %PLATFORM% ^
    --only-binary=:all:

if errorlevel 1 (
    echo.
    echo FAILED — a package has no matching wheel for cp%PYVER%/%PLATFORM%.
    echo Check the package name/version above and adjust requirements.txt.
    exit /b 1
)

echo.
echo Recording exact resolved versions for reproducibility...
python -m pip freeze > %OUTDIR%\..\versions.txt

echo.
echo Computing checksums for integrity verification after transfer...
powershell -ExecutionPolicy Bypass -File scripts\compute_hashes.ps1

echo.
echo Done. Wheelhouse ready at %OUTDIR%\
echo Files:
dir /b %OUTDIR%
echo.
echo Next: zip the whole project folder (including wheelhouse\, versions.txt,
echo hashes.sha256) and transfer it to the facility PC via your approved channel.
echo On the facility PC, run scripts\install.bat — it installs from this
echo wheelhouse only, no internet required.