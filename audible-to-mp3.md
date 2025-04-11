# Audible files to MP3

**Warning this is a tutoriel for `aax` and not `aaxc`**

## 0 - Required setup

```
brew install ffmpeg
brew install jq
```

## 1 - Download `aax` file directly from Audible website

Audiobook bought on Audible can be downloaded from your [library](https://www.audible.fr/library/titles).

## 2 - Check File format

File must be a `aax` file

```
hexdump -C <file.aax> | less
```

## 3 - Get checksum / activation bytes

```
ffmpeg -i file.aax |& grep checksum $
[mov,mp4,m4a,3gp,3g2,mj2 @ 0x12a7065d0] [aax] file checksum == a91dbf721d2602de5b33659ddd943c26c4ad149e 
```

Use this website: https://audible-tools.kamsker.at/ to find the activation bytes

## 4 - Convert to MP3

```
ffmpeg -activation_bytes <ACTIVATION_BYTES> -i 'file.aax' -c:a libmp3lame -b:a 128k 'output.mp3'
```

* `-activation_bytes e75f8a1b`: Required to decrypt the AAX file. This must be the correct value for your Audible account/device.
* `-i "filename.aax"`: Input AAX file.
* `-codec:a libmp3lame`: Tells FFmpeg to use the LAME MP3 encoder.
* `-b:a 128k`: Sets audio bitrate to 128 kbps (you can go higher if you want better quality).
* `"output.mp3"`: Output file.

## 5 - Split by chapter [ optionnal ]

See script `split-mp3.sh`

```
$ ./split-mp3.sh -h
Usage:
    split-mp3.sh <file.mp3>
```