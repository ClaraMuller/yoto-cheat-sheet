# Download Youtub video

## Install `yt-dlp` & `ffmepg`

Official documentation: [github.com/yt-dlp](https://github.com/yt-dlp)

```
brew install yt-dlp
brew install ffmpeg
```

Explanation of Flags:

* `-f bestaudio` → Downloads the best available audio format.
* `--extract-audio` → Extracts the audio from the video file.
* `--audio-format mp3` → Converts the audio to MP3.
* `-o "%(title)s.%(ext)s"` → Saves the file with the video title as the filename.

## Download a Youtube playlist

```
yt-dlp -f best -o "%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" <playlist_url>
```

### mp3 format

```
yt-dlp -f "bestaudio" --extract-audio --audio-format mp3 -o "%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" <playlist_url>
```

## Download mp3 audop from a Youtube video

```
yt-dlp -f bestaudio --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s" <video_url_1> <video_url_2> ...
```

### Trim the first 10 seconds

* `--postprocessor-args "-ss 10"` → Cuts the first 10 seconds using ffmpeg

```
yt-dlp -f bestaudio --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s" --postprocessor-args "-ss 10" <video_url>
```

### Trim video

* `-ss 10` → Starts at 10 seconds.
* `-to 60` → Ends at 60 seconds (optional; remove if you want full length after trimming the start).

```
yt-dlp -f bestaudio --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s" --postprocessor-args "-ss 10 -to 60" <video_url>
```