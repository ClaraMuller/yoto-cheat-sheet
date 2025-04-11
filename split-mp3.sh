#!/bin/sh

usage() {
    scriptName=$(basename "$0")
    echo "Usage:"
    echo "    ${scriptName} <file.mp3>"
}

if [ $# -lt 1 ]; then
    echo "error: missing parameter"
    usage
    exit 1
fi

if [ "$1" = "-h" ] || [ "$1" = "-help" ]; then
    usage
    exit 0
fi

input="$1"
input_extension=$(basename "${input}" | cut -d '.' -f2)

if [ "${input_extension}" != "mp3" ]; then
    echo "error: invalid input"
    usage
    exit 1
fi

inputDir=$(dirname "$input")
inputName=$(basename "${input}" | tr -d ".mp3")
dir_output="${inputDir}/${inputName}_chapters"

metadata=$(ffprobe -i "$input" -print_format json -show_chapters -loglevel error)
mkdir -p -v "${dir_output}"

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