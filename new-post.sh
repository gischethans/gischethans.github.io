#!/bin/bash

# A simple script to automatically create a new Jekyll post with front matter

# Check if title is provided
if [ -z "$1" ]; then
    echo "Usage: ./new-post.sh \"Post Title\""
    exit 1
fi

TITLE="$1"
# Convert title to lowercase, replace spaces with hyphens, and remove special characters for the filename
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed -e 's/ /-/g' -e 's/[^a-z0-9-]//g')
DATE=$(date +%Y-%m-%d)
FILENAME="_posts/${DATE}-${SLUG}.md"

# Check if file already exists
if [ -f "$FILENAME" ]; then
    echo "Error: File $FILENAME already exists."
    exit 1
fi

# Write front matter to the new file
cat <<EOF > "$FILENAME"
---
layout: post
title: "$TITLE"
date: $DATE
tags: []
categories: []
---

EOF

# Create an associated image directory for this post
IMG_DIR="assets/images/${DATE}-${SLUG}"
mkdir -p "$IMG_DIR"

echo "Created new post: $FILENAME"
echo "Created image directory: $IMG_DIR"
