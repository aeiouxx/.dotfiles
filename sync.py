#!/usr/bin/env python3
import os
import sys
import shutil
import platform
from pathlib import Path
import subprocess

# -------------------------------------------------------------------
# Utility
# -------------------------------------------------------------------


def log(msg):
    print(f"[+] {msg}")


def ensure_dir(path: Path):
    if not path.exists():
        log(f"Creating directory: {path}")
        path.mkdir(parents=True, exist_ok=True)


def copy_item(src: Path, dst: Path):
    try:
        if src.is_dir():
            log(f"Sync directory: {src} -> {dst}")
            if dst.exists():
                shutil.rmtree(dst)
            shutil.copytree(src, dst)
        else:
            ensure_dir(dst.parent)
            log(f"Copy file: {src} -> {dst}")
            shutil.copy2(src, dst)

    except Exception as e:
        print(f"[ERROR] Failed to copy {src} → {dst}")
        print(f"        Reason: {e}")


def safe_list(path: Path):
    return list(path.iterdir()) if path.exists() else []

# -------------------------------------------------------------------
# XDG CONFIG CHECK (runs *first* before anything else)
# -------------------------------------------------------------------


def initial_xdg_check():
    """
    Run at the start of the script.
    Enforces the same behavior as the batch script:
    - If XDG_CONFIG_HOME is missing → warn → ask user
    - If user declines → exit
    - If accepts → set and continue
    """

    xdg = os.environ.get("XDG_CONFIG_HOME")
    if xdg:
        return Path(xdg)

    # Determine default .config path depending on OS
    if platform.system() == "Windows":
        default = Path(os.environ["USERPROFILE"]) / ".config"
    else:
        default = Path.home() / ".config"

    print("===============================================")
    print("WARNING: The XDG_CONFIG_HOME environment variable is not set.")
    print("This variable defines the base directory where")
    print("user-specific configuration files should be stored.")
    print(f"Would you like to set it to: {default}")
    print("===============================================")

    answer = input("Enter your choice (Y = Yes, N = No): ").strip().lower()

    if answer != "y":
        print("You chose not to set XDG_CONFIG_HOME. Exiting script...")
        sys.exit(1)

    # Persist the value
    if platform.system() == "Windows":
        os.system(f'setx XDG_CONFIG_HOME "{default}" >nul')
    else:
        profile = Path.home() / ".profile"
        with profile.open("a") as f:
            f.write(f'\nexport XDG_CONFIG_HOME="{default}"\n')

    # Set for current session
    os.environ["XDG_CONFIG_HOME"] = str(default)

    print("XDG_CONFIG_HOME has been set successfully.")
    return default

# -------------------------------------------------------------------
# After initial check, this getter is safe
# -------------------------------------------------------------------


def get_xdg_config_home():
    return Path(os.environ["XDG_CONFIG_HOME"])

# -------------------------------------------------------------------
# Sync logic
# -------------------------------------------------------------------


def sync_pull(repo_root: Path):
    log("=== PULL MODE: Machine → Repo ===")

    # XDG
    xdg_machine = get_xdg_config_home()
    xdg_repo = repo_root / "XDG_CONFIG_HOME"
    ensure_dir(xdg_repo)

    log(f"Syncing XDG_CONFIG_HOME from machine: {xdg_machine}")

    for item in safe_list(xdg_repo):
        src = xdg_machine / item.name
        if src.exists():
            copy_item(src, item)

    # Windows USERPROFILE
    if platform.system() == "Windows":
        repo_user = repo_root / "windows" / "USERPROFILE"
        mach_user = Path(os.environ["USERPROFILE"])
        ensure_dir(repo_user)

        log(f"Syncing Windows USERPROFILE from machine: {mach_user}")
        for item in safe_list(repo_user):
            src = mach_user / item.name
            if src.exists():
                copy_item(src, item)

    log("Pull complete.")


def sync_push(repo_root: Path):
    log("=== PUSH MODE: Repo → Machine ===")

    # XDG
    xdg_machine = get_xdg_config_home()
    xdg_repo = repo_root / "XDG_CONFIG_HOME"
    ensure_dir(xdg_machine)

    log(f"Installing XDG_CONFIG_HOME → {xdg_machine}")

    for item in safe_list(xdg_repo):
        dst = xdg_machine / item.name
        copy_item(item, dst)

    # Windows USERPROFILE
    if platform.system() == "Windows":
        repo_user = repo_root / "windows" / "USERPROFILE"
        mach_user = Path(os.environ["USERPROFILE"])

        log(f"Installing Windows USERPROFILE → {mach_user}")

        for item in safe_list(repo_user):
            dst = mach_user / item.name
            copy_item(item, dst)

        # PowerShell profile
        ps_src = xdg_repo / "powershell" / "Microsoft.PowerShell_profile.ps1"
        if ps_src.exists():
            result = subprocess.run(
                ["powershell", "-NoProfile", "-Command", "Write-Output $PROFILE"],
                capture_output=True, text=True
            )
            ps_profile_path = Path(result.stdout.strip())

            ensure_dir(ps_profile_path.parent)
            shutil.copy2(ps_src, ps_profile_path)
            log(f"Installed PowerShell profile → {ps_profile_path}")

    log("Push complete.")

# -------------------------------------------------------------------
# Entry
# -------------------------------------------------------------------


def main():
    if len(sys.argv) < 2 or sys.argv[1] not in ("push", "pull"):
        print("Usage:")
        print("  python sync.py push   # repo → machine")
        print("  python sync.py pull   # machine → repo")
        sys.exit(1)

    initial_xdg_check()

    mode = sys.argv[1]
    repo_root = Path(__file__).parent.resolve()

    if mode == "pull":
        sync_pull(repo_root)
    else:
        sync_push(repo_root)


if __name__ == "__main__":
    main()
