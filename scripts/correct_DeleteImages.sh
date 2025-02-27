#!/bin/bash
image_extensions=("apng" "png" "avif" "gif" "jpg" "jpeg" "jfif" "pjpeg" "pjp" "webp" "bmp" "ico" "cur" "tif" "tiff" "svg")
for ext in "${image_extensions[@]}"; do
    find . -type f -name "*.$ext" -delete >/dev/null
done
