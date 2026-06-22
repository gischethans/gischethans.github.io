#!/bin/bash

# Optimize images for the blog:
#   - JPEG/PNG: resize to max 1330px wide (2x retina for 665px content area),
#     compress JPEG at 80% quality. Skips files already within bounds (idempotent).
#   - HEIC: convert to WebP (if cwebp is installed) or JPEG, then delete the original.
#
# Install cwebp for WebP output: brew install webp
#
# Usage:
#   ./optimize-images.sh                        # process all of assets/images/
#   ./optimize-images.sh assets/images/2026-06  # process a specific post folder
#   ./optimize-images.sh path/to/photo.heic     # process a single file

TARGET="${1:-assets/images}"
MAX_PX=1330
JPEG_QUALITY=80

if [ ! -e "$TARGET" ]; then
    echo "Error: '$TARGET' not found."
    exit 1
fi

HAS_CWEBP=false
if command -v cwebp &>/dev/null; then
    HAS_CWEBP=true
fi

PROCESSED=0
SKIPPED=0
TOTAL_SAVED=0

pixel_width() {
    sips --getProperty pixelWidth "$1" 2>/dev/null | awk '/pixelWidth/{print $2}'
}

process_jpeg_png() {
    local file="$1"
    local ext
    ext=$(echo "${file##*.}" | tr '[:upper:]' '[:lower:]')

    local width
    width=$(pixel_width "$file")

    if [ -n "$width" ] && [ "$width" -le "$MAX_PX" ]; then
        printf "  %-55s  skipped (already %dpx wide)\n" "$(basename "$file")" "$width"
        SKIPPED=$(( SKIPPED + 1 ))
        return
    fi

    local before
    before=$(stat -f%z "$file")

    if [ "$ext" = "jpg" ] || [ "$ext" = "jpeg" ]; then
        sips -Z "$MAX_PX" --setProperty formatOptions "$JPEG_QUALITY" "$file" &>/dev/null
    else
        sips -Z "$MAX_PX" "$file" &>/dev/null
    fi

    local after
    after=$(stat -f%z "$file")
    local saved=$(( before - after ))

    TOTAL_SAVED=$(( TOTAL_SAVED + saved ))
    PROCESSED=$(( PROCESSED + 1 ))

    printf "  %-55s %5dKB → %5dKB  (-%dKB)\n" \
        "$(basename "$file")" "$(( before / 1024 ))" "$(( after / 1024 ))" "$(( saved / 1024 ))"
}

process_heic() {
    local file="$1"
    local before
    before=$(stat -f%z "$file")
    local base="${file%.*}"

    if $HAS_CWEBP; then
        local tmp="${base}_tmp.png"
        sips -s format png "$file" --out "$tmp" &>/dev/null
        sips -Z "$MAX_PX" "$tmp" &>/dev/null
        cwebp -q "$JPEG_QUALITY" "$tmp" -o "${base}.webp" &>/dev/null
        rm "$tmp"
        local after
        after=$(stat -f%z "${base}.webp")
        printf "  %-55s %5dKB → %5dKB  (webp)\n" \
            "$(basename "$file")" "$(( before / 1024 ))" "$(( after / 1024 ))"
    else
        sips -s format jpeg -Z "$MAX_PX" --setProperty formatOptions "$JPEG_QUALITY" \
            "$file" --out "${base}.jpg" &>/dev/null
        local after
        after=$(stat -f%z "${base}.jpg")
        printf "  %-55s %5dKB → %5dKB  (jpeg; install cwebp for webp)\n" \
            "$(basename "$file")" "$(( before / 1024 ))" "$(( after / 1024 ))"
    fi

    rm "$file"
    TOTAL_SAVED=$(( TOTAL_SAVED + before - after ))
    PROCESSED=$(( PROCESSED + 1 ))
}

process_file() {
    local file="$1"
    local ext
    ext=$(echo "${file##*.}" | tr '[:upper:]' '[:lower:]')

    case "$ext" in
        jpg|jpeg|png) process_jpeg_png "$file" ;;
        heic)         process_heic "$file" ;;
    esac
}

echo "Optimizing images in: $TARGET"
$HAS_CWEBP && echo "(cwebp found — HEIC will convert to WebP)" || \
    echo "(cwebp not found — HEIC will convert to JPEG; run: brew install webp)"
echo ""

if [ -f "$TARGET" ]; then
    process_file "$TARGET"
else
    while IFS= read -r -d '' file; do
        process_file "$file"
    done < <(find "$TARGET" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.heic" \) -print0)
fi

echo ""
echo "$PROCESSED optimized, $SKIPPED skipped. Total saved: $(( TOTAL_SAVED / 1024 ))KB"
