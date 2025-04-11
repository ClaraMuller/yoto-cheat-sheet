#!/bin/sh

input="output.mp3"
dir_output="./chapters"
metadata=$(ffprobe -i "$input" -print_format json -show_chapters -loglevel error)

mkdir -p -v $dir_output

# Extract chapter details using jq
echo "$metadata" | jq -c '.chapters[]' | while read -r chapter; do
    start=$(echo "$chapter" | jq -r '.start_time')
    end=$(echo "$chapter" | jq -r '.end_time')
    title=$(echo "$chapter" | jq -r '.tags.title // "Chapter"')

    # Sanitize filename
    filename=$(echo "$title" | tr -d '[:punct:]' | tr ' ' '_').mp3

    echo "Extracting $filename from $start to $end..."
    ffmpeg -nostdin -i "$input" -acodec copy -ss "$start" -to "$end" "$dir_output/$filename"
done