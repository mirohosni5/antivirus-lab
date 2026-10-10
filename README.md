# Antivirus Lab

## About

This project is a simple antivirus daemon written in Bash. It checks files in a directory and detects suspicious files based on their extensions or content. Detected files are copied to a quarantine folder and removed from the original directory.

The restore script lets the user restore files or delete them permanently.

## Files

* `antivirusd.sh`: Scans the directory for suspicious files.
* `restore.sh`: Lets the user manage files in quarantine.
* `Makefile`: Runs the scripts.
* `.gitignore`: Ignores temporary files and test folders.

## Requirements

The project runs on Ubuntu and needs Bash, Git, and Make.

Install the required tools using:

```bash
sudo apt update
sudo apt install bash coreutils make git
```

## How to Use

Create the test directory:

```bash
mkdir -p test-dir
```

Start the antivirus:

```bash
./antivirusd.sh test-dir quarantine 5
```

It scans the directory at startup and checks for changes every 5 seconds. Press `Ctrl+C` to stop it.

You can also run it using:

```bash
make
```

To manage quarantined files, make sure the antivirus is stopped, then run:

```bash
./restore.sh test-dir quarantine
```

Or use `make restore`.

## Detection Rules

The detection rules are inside `antivirusd.sh`.

The script checks for these extensions: `.exe`, `.bat`, `.vbs`, `.scr`, and `.ps1`.

It also searches file contents for these keywords: `virus`, `trojan`, `malware`, `worm`, and `ransomware`. The keyword search ignores uppercase and lowercase differences.
