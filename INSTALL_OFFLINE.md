# OFFLINE INSTALLATION GUIDE
### UAV Intelligence Engine — Facility PC Setup
> **Read this entire document before touching anything.**  
> This package is fully self-contained. No internet is needed at any point.

---

## What's in This Package

| Folder / File | What it is |
|---|---|
| `tools\python\python-3.14.7-amd64.exe` | Python 3.14.7 standalone installer (no internet needed) |
| `tools\ffmpeg\bin\` | FFmpeg + FFprobe static binaries |
| `wheelhouse\` | All 120 Python packages as offline `.whl` files |
| `scripts\install.bat` | **The only script you need to run** |
| `requirements.txt` | Package list (used automatically by install.bat) |
| `hashes.sha256` | Integrity checksums — verified before install starts |
| `config\` | YAML configuration files |
| `src\` | Python source code |

---

## Requirements

- Windows 10 (64-bit) or newer
- No internet connection needed
- No existing Python required (installer is bundled)
- Run from a normal user account (no admin rights needed)

---

## Step 1 — Install Python 3.14

> [!IMPORTANT]  
> Do this **before** running `install.bat`. Python 3.14 must be installed first.

1. Open File Explorer and navigate to the unzipped project folder
2. Go into `tools\python\`
3. Double-click **`python-3.14.7-amd64.exe`**
4. On the first screen:
   - ✅ Check **"Add python.exe to PATH"** (very important)
   - ✅ Check **"Install launcher for all users (recommended)"**
   - Click **"Install Now"**
5. Wait for it to complete (~1–2 minutes)
6. Click **Close**
7. **Close any open Command Prompt windows** (PATH only updates in new windows)

---

## Step 2 — Run the Installer

1. Open a **new** Command Prompt window:
   - Press `Win + R` → type `cmd` → press Enter
2. Navigate to the project folder. Example:
   ```
   cd C:\Users\YourName\Desktop\Phase1_Environment_Setup
   ```
   *(Replace the path with wherever you unzipped the package)*
3. Run:
   ```
   scripts\install.bat
   ```
4. Watch the output. Each step is numbered `[0/13]` through `[13/13]`
5. At the end you should see:
   ```
   INSTALL OK — see install_log.txt for details
   ```

---

## What `install.bat` Does (Step by Step)

| Step | What happens |
|---|---|
| `[0]` | Verifies all wheel files are uncorrupted (SHA-256 check) |
| `[0b]` | Confirms Python 3.14 is installed |
| `[1]` | Checks Python is on PATH |
| `[2]` | Checks system architecture (must be 64-bit) |
| `[3]` | Creates a Python 3.14 virtual environment (`venv\`) |
| `[4]` | Installs all packages from `wheelhouse\` — no internet used |
| `[4b]` | Installs PyTorch + Torchvision + Ultralytics (CPU-only) |
| `[5]` | Verifies all core imports work |
| `[6]` | Verifies FFmpeg and FFprobe binaries are present |
| `[7–12]` | Skipped — those components come in later phases |
| `[13]` | Runs smoke test (loads config, prints mission phases) |

All output is also saved to `install_log.txt` in the project folder.

---

## If Something Goes Wrong

### ❌ "Python 3.14 not found"
→ You skipped Step 1. Go back and install `tools\python\python-3.14.7-amd64.exe`, then **open a new** Command Prompt and try again.

### ❌ "Wheelhouse integrity check FAILED"
→ The zip transfer was corrupted. Re-transfer the package and try again.

### ❌ "pip install" step fails
→ Open `install_log.txt` and look for the specific package that failed. Send the log file back to the developer.

### ❌ "FFmpeg missing"
→ Make sure `tools\ffmpeg\bin\ffmpeg.exe` and `ffprobe.exe` are present. They should be — if not, the zip was incomplete.

### ❌ Any other error
→ Check `install_log.txt` — every command's output is recorded there. Send the full log to the developer.

---

## After Successful Install — How to Use

Every time you want to work with the project, **activate the virtual environment first:**

```cmd
cd C:\path\to\Phase1_Environment_Setup
venv\Scripts\activate
```

Your prompt will change to show `(venv)`. Then you can run Python scripts normally:

```cmd
python -m src.config        ← smoke test / config check
```

To deactivate when done:
```cmd
deactivate
```

> **Never** run `pip install` from the internet on this machine. All packages are already installed in `venv\`. If new packages are needed, they must be added to the wheelhouse at home and transferred again.

---

## FFmpeg — Important Note

FFmpeg is bundled in `tools\ffmpeg\bin\` and is **not** added to your system PATH.  
The application uses it directly from that path — do not move or rename the `tools\ffmpeg\` folder.

---

## Package Version Reference

All 120 installed packages are listed in `versions.txt`.  
Full install log (timestamped) is in `install_log.txt` after running `install.bat`.

---

*Package built: September 2026 | Python 3.14.7 | Windows x64 | CPU-only*
