---
layout: post
title: "A Simple rsync Script that I use for Backups"
date: 2025-11-18
tags: [rsync, linux, backup, pc backup, script]
categories: [utilities]
---

Ever since I bought my first PC back in 2008, keeping my data backed up has been a priority. Those were the ThinkCentre desktop days - reliable machines, and thanks to IBM’s proprietary backup software, I felt safe, at least initially!

But there was a catch.

The backups were stored in a proprietary format, with the actual files buried deep under cryptic folder structures. To make matters worse, the backup would be split across multiple DVDs. Restoring anything manually felt like a small archaeology project.

Over the years, my backup strategy kept evolving. Storage was expensive back then, so I limited myself to burning only the most important files onto optical discs or copying them manually to an external HDD every few months. It worked - but it wasn’t elegant. And it definitely wasn’t efficient.

Eventually, I realized something important: Backups should be simple, fast, and trustworthy. But most GUI backup tools fail miserably at this. They hide everything behind animations and vague progress bars. You never really know:

- what is being copied
- what is being skipped
- or worse, what is being deleted.

On top of that, many tools bury the actual data under odd folder names, or store everything in proprietary formats that require the same software just to restore your own files.

I wanted something cleaner, predictable that told me exactly what was happening and didn’t hide my files from me. So, with some help from ChatGPT, I built a simple, interactive rsync-based backup script that I use to backup to two external hard drives. 

### Total Transparency
This script shows you which files 
- have changed
- were copied
- were deleted (the most important!)

in addition to how much data moved and a fully readable, color-coded log. Nothing is hidden with every action being visible and verifiable.

### “Dry Run” Mode and Quarantine feature
I included a dry-run mode so that before running an actual backup, I can preview what would sync, what would be deleted and how large the transfer would be! 

Further the script also copies the deleted files to a ***quarantine*** folder which could be used if you ever need the files back! 

Above all, my data stays in its real, human-readable form.

## The Script

```bash
#!/bin/bash

### ──────────────────────────────────────────────────────────────
###  Color Codes
### ──────────────────────────────────────────────────────────────
RED="\033[1;31m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
RESET="\033[0m"

### ──────────────────────────────────────────────────────────────
###  Colorized rsync output
### ──────────────────────────────────────────────────────────────
colorize() {
  sed -u \
    -e "s/^>f/${GREEN}&${RESET}/" \
    -e "s/^<f/${CYAN}&${RESET}/" \
    -e "s/^\*deleting/${RED}&${RESET}/"
}

### ──────────────────────────────────────────────────────────────
###  Choose target disk
### ──────────────────────────────────────────────────────────────
choose_disk() {
  echo "Choose the target disk:"
  echo "1) BACKUP_DRIVE_A"
  echo "2) BACKUP_DRIVE_B"
  read -p "Enter choice (1/2): " pick

  case "$pick" in
    1) TARGET_DISK="BACKUP_DRIVE_A" ;;
    2) TARGET_DISK="BACKUP_DRIVE_B" ;;
    *) echo "Invalid choice."; exit 1 ;;
  esac

  echo -e "Selected disk: ${CYAN}${TARGET_DISK}${RESET}"
}

### ──────────────────────────────────────────────────────────────
###  Choose dry-run or live mode
### ──────────────────────────────────────────────────────────────
choose_mode() {
  echo
  echo "Choose sync mode:"
  echo "1) Dry run"
  echo "2) Live sync"
  read -p "Enter choice (1/2): " pick

  case "$pick" in
    1) MODE="dry-run"; FLAG="--dry-run"; LABEL="Dry Run" ;;
    2) MODE="live"; FLAG=""; LABEL="LIVE Run" ;;
    *) echo "Invalid choice."; exit 1 ;;
  esac

  echo -e "Selected mode: ${GREEN}${LABEL}${RESET}"
}

### ──────────────────────────────────────────────────────────────
###  Print Summary
### ──────────────────────────────────────────────────────────────
print_summary() {
  file_count=$(grep -c '^>f' "$logFile" || true)
  delete_count=$(grep -c '^\*deleting' "$logFile" || true)
  size_line=$(grep "Total transferred file size" "$logFile" | tail -1)
  size=$(echo "$size_line" | awk -F': ' '{print $2}' | awk '{$1=$1};1')

  echo "=============================================================="
  echo -e "Summary (${LABEL}):"
  echo -e "  Files transferred:             ${GREEN}${file_count}${RESET}"
  echo -e "  Files deleted (quarantined):   ${RED}${delete_count}${RESET}"
  echo -e "  Total size transferred:        ${CYAN}${size:-0 B}${RESET}"
  echo "=============================================================="
}

### ──────────────────────────────────────────────────────────────
###  Main Script
### ──────────────────────────────────────────────────────────────

clear
echo "==================== RSYNC BACKUP TOOL ===================="

choose_disk
choose_mode

### Your main source folder (change as needed)
SOURCE="/path/to/source_folder/"

### Where your backup drives get mounted
DEST="/mnt/backup_drives/${TARGET_DISK}"

TIMESTAMP=$(date +'%Y%m%d_%H%M%S')

### ──────────────────────────────────────────────────────────────
###  Quarantine folder (for deleted / overwritten files)
### ──────────────────────────────────────────────────────────────
QUARANTINE_ROOT="/path/to/quarantine"
QUARANTINE_DIR="${QUARANTINE_ROOT}/${TIMESTAMP}"
mkdir -p "$QUARANTINE_DIR"

### ──────────────────────────────────────────────────────────────
###  Logging
### ──────────────────────────────────────────────────────────────
logFile="/path/to/logs/rsync-${MODE}_${TIMESTAMP}.log"
mkdir -p "$(dirname "$logFile")"

echo
echo "=============================================================="
echo "${LABEL} starting..."
echo -e "Source:        ${CYAN}${SOURCE}${RESET}"
echo -e "Destination:   ${CYAN}${DEST}${RESET}"
echo -e "Quarantine:    ${CYAN}${QUARANTINE_DIR}${RESET}"
echo -e "Mode:          ${GREEN}${LABEL}${RESET}"
echo "--------------------------------------------------------------"

### ──────────────────────────────────────────────────────────────
###  Execute Backup (with quarantine)
### ──────────────────────────────────────────────────────────────
rsync -avhP $FLAG \
  --itemize-changes \
  --exclude-from=/path/to/exclude-list.txt \
  --backup \
  --backup-dir="$QUARANTINE_DIR" \
  --delete --stats \
  "$SOURCE" "$DEST" \
  | tee "$logFile" | colorize

print_summary

echo "${LABEL} complete. Log saved to: $logFile"
echo
```

---
