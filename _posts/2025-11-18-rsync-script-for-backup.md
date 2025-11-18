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

<!--more-->

<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="540" viewBox="0 0 1200 540" aria-labelledby="title desc" role="img">
  <title id="title">rsync backup flow — Source to Backup with Quarantine and Dry-run</title>
  <desc id="desc">Diagram showing a source folder syncing to a backup drive with a quarantine folder for deletions, and a dry-run option. Colors: green, cyan, red.</desc>

  <!-- Background -->
  <defs>
    <linearGradient id="bg" x1="0" x2="1">
      <stop offset="0" stop-color="#fbfcfd"/>
      <stop offset="1" stop-color="#f3f7fb"/>
    </linearGradient>

    <filter id="shadow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="0" dy="6" stdDeviation="14" flood-color="#000" flood-opacity="0.12"/>
    </filter>

    <style>
      .label { font: 600 16px/1.1 "Inter", "Segoe UI", Roboto, sans-serif; fill: #0f1724; }
      .sub { font: 400 13px/1.1 "Inter", Roboto, sans-serif; fill: #334155; }
      .mono { font: 500 12px "Courier New", monospace; fill:#0f1724; }
      .muted { fill: #7b8794; font: 400 12px/1.1 "Inter", Roboto, sans-serif; }
      .accent-green { fill: #10b981; stroke: none; }
      .accent-cyan { fill: #06b6d4; stroke: none; }
      .accent-red { fill: #ef4444; stroke: none; }
      .card { fill: white; stroke: none; filter: url(#shadow); }
      .icon { fill: none; stroke-width: 2.5; stroke-linecap: round; stroke-linejoin: round; }
      .arrow { fill:none; stroke:#111827; stroke-width:3; marker-end: url(#arrowhead); }
    </style>

    <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
      <polygon points="0 0, 10 3.5, 0 7" fill="#111827"/>
    </marker>
  </defs>

  <rect width="1200" height="540" fill="url(#bg)" rx="0" ry="0"/>

  <!-- Left: Source -->
  <g transform="translate(50,70)">
    <rect class="card" x="0" y="0" width="360" height="220" rx="12" />
    <g transform="translate(20,18)">
      <text class="label">Source</text>
      <text class="muted" x="0" y="26">Your files & folders</text>

      <!-- Folder icon -->
      <g transform="translate(0,40)">
        <rect x="0" y="0" width="120" height="70" rx="6" fill="#f8fafc" stroke="#e6eef6"/>
        <path d="M0 0h36a8 8 0 0 1 8 8v0h76v62H0z" fill="#fff8eb" stroke="#f1e6d3"/>
        <text x="8" y="44" class="mono">~/projects</text>
      </g>

      <!-- Files -->
      <g transform="translate(150,40)">
        <rect x="0" y="0" width="170" height="70" rx="6" fill="#ffffff" stroke="#e6eef6"/>
        <text x="10" y="26" class="mono">important.docx</text>
        <text x="10" y="44" class="mono">photos/</text>
      </g>

      <!-- Dry run badge -->
      <g transform="translate(0,130)">
        <rect x="0" y="0" width="120" height="46" rx="8" fill="#f1f9fa" stroke="#dff3f5"/>
        <circle cx="18" cy="23" r="10" fill="#fff" stroke="#06b6d4" stroke-width="2.5"/>
        <text x="44" y="30" class="sub">Dry run (preview)</text>
      </g>
    </g>
  </g>

  <!-- Center: arrows & mode -->
  <g transform="translate(440,70)">
    <text class="label" x="0" y="8">Sync Flow</text>
    <text class="muted" x="0" y="26">Preview with dry-run — then run live</text>

    <!-- Arrow to backup -->
    <path class="arrow" d="M80 90 C 160 90, 220 90, 300 90" />
    <text class="muted" x="150" y="75" text-anchor="middle">rsync • --itemize-changes</text>

    <!-- Icons for dry/live -->
    <g transform="translate(10,120)">
      <rect x="0" y="0" width="100" height="56" rx="10" fill="#ffffff" stroke="#e6eef6"/>
      <text class="sub" x="12" y="32">Preview</text>
      <text class="mono" x="12" y="48">--dry-run</text>
    </g>

    <g transform="translate(120,120)">
      <rect x="0" y="0" width="100" height="56" rx="10" fill="#ffffff" stroke="#e6eef6"/>
      <text class="sub" x="14" y="32">Execute</text>
      <text class="mono" x="14" y="48">Live sync</text>
    </g>
  </g>

  <!-- Right: Backup drive -->
  <g transform="translate(760,70)">
    <rect class="card" x="0" y="0" width="360" height="220" rx="12" />
    <g transform="translate(20,18)">
      <text class="label">Backup Drive</text>
      <text class="muted" x="0" y="26">Mounted target</text>

      <!-- Drive icon -->
      <g transform="translate(0,40)">
        <rect x="0" y="0" width="170" height="80" rx="10" fill="#f8fafc" stroke="#e6eef6"/>
        <rect x="8" y="10" width="154" height="56" rx="6" fill="#fff" stroke="#e6eef6"/>
        <text x="12" y="44" class="mono">/mnt/backup/DRIVE_NAME</text>
      </g>

      <!-- Quarantine box -->
      <g transform="translate(190,40)">
        <rect x="0" y="0" width="140" height="80" rx="8" fill="#fff" stroke="#e6eef6"/>
        <text class="sub" x="10" y="18">Quarantine</text>
        <text class="mono" x="10" y="38">$HOME/rsync/quarantine</text>

        <!-- small file icons inside -->
        <g transform="translate(10,50)">
          <rect x="0" y="0" width="36" height="18" rx="3" fill="#fff8f8" stroke="#fbe3e3"/>
          <rect x="46" y="0" width="36" height="18" rx="3" fill="#f0fdf4" stroke="#daf7dc"/>
        </g>
      </g>
    </g>
  </g>

  <!-- Arrows showing quarantine behavior (red arrow) -->
  <g transform="translate(480,170)">
    <path d="M180 12 C 210 12, 260 30, 300 46" stroke="#ef4444" stroke-width="3" fill="none" marker-end="url(#arrowhead)"/>
    <text x="190" y="-2" class="muted">Deleted / overwritten → moved to quarantine</text>
  </g>

  <!-- Bottom: summary / legends -->
  <g transform="translate(60,320)">
    <rect x="0" y="0" width="1080" height="180" rx="12" fill="#ffffff" stroke="#e6eef6" />
    <g transform="translate(20,18)">
      <text class="label">Legend & Summary</text>
      <text class="muted" x="0" y="22">What the script shows</text>

      <!-- Legend items -->
      <g transform="translate(0,36)">
        <g transform="translate(0,0)"><rect x="0" y="0" width="14" height="14" rx="3" class="accent-green"/><text class="sub" x="22" y="12">Files copied / transferred</text></g>
        <g transform="translate(260,0)"><rect x="0" y="0" width="14" height="14" rx="3" class="accent-cyan"/><text class="sub" x="22" y="12">Source / destination markers</text></g>
        <g transform="translate(560,0)"><rect x="0" y="0" width="14" height="14" rx="3" class="accent-red"/><text class="sub" x="22" y="12">Deletions quarantined</text></g>
      </g>

      <text class="muted" x="0" y="86">Tip: Use <tspan class="mono">--dry-run</tspan> to preview changes before running a live sync.</text>

      <g transform="translate(0,110)">
        <text class="mono">rsync -avhP [--dry-run] --itemize-changes --backup --backup-dir=/path/to/quarantine --delete --stats /source/ /dest/</text>
      </g>
    </g>
  </g>
</svg>

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
