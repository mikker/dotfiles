#!/usr/bin/env bash

function printHelpAndExit {
cat <<EOF
Usage:
  gifv [options] filename
Version:   1.0.0

Convert GIFs and videos into GIF-like videos

Options: (all optional)
  -c CROP:     The x and y crops, from the top left of the image (e.g. 640:480)
  -d           Directon (normal, reverse, alternate) [default: normal]
  -o OUTPUT:   The basename of the file to be output. The default is the basename
              of the input file.
  -r FPS:      Output at this (frame)rate.
  -s SPEED:    Output using this speed modifier. The default is 1 (equal speed).
  -O OPTIMIZE: Change the compression level used (1-9), with 1 being the fastest,
              with less compression, and 9 being the slowest, with optimal com-
              pression.  The default compression level is 6.
  -p SCALE:    Rescale the output (e.g. 320:240)
  -x           Remove the original file

Example:
  gifv -c 240:80 -o my-gifv.mp4 -x my-movie.mov

EOF
exit $1
}

function join { local IFS="$1"; shift; echo "$*"; }

# Initialize variables
levels=(ultrafast superfast veryfast faster fast medium slow slower veryslow)
level=6

OPTERR=0

while getopts "c:d:o:p:r:s:O:xh" opt; do
  case $opt in
    c) crop=$OPTARG;;
    d) direction=$OPTARG;;
    h) printHelpAndExit 0;;
    o) output=$OPTARG;;
    p) scale=$OPTARG;;
    r) fps=$OPTARG;;
    s) speed=$OPTARG;;
    O) level=$OPTARG;;
    x) cleanup=1;;
    *) printHelpAndExit 1;;
  esac
done

shift $(( OPTIND - 1 ))

filename="$1"

if [ -z "$output" ]; then
  # Strip off extension and add new extension
  ext="${filename##*.}"
  path=$(dirname "$filename")
  output="$path/$(basename "$filename" ".$ext").mp4"
fi

if [ -z "$filename" ]; then printHelpAndExit 1; fi

# Video filters (scale, crop, speed)
if [ $crop ]; then
  crop="crop=${crop}:0:0"
else
  crop=
fi

if [ $scale ]; then
  scale="scale=${scale}"
else
  scale=
fi

if [ $speed ]; then
  speed="setpts=$(bc -l <<< "scale=4;1/${speed}")*PTS"
else
  speed=
fi

# Convert GIFs
# A fix for gifs that may not have a perfectly sized aspect ratio
if [ "$(file -b --mime-type "$filename")" == image/gif ]; then
  giffix="scale='if(eq(mod(iw,2),0),iw,iw-1)':'if(eq(mod(ih,2),0),ih,ih-1)'"
else
  giffix=
fi

# Concatenate options into a video filter string
# giffix must be applied after any scaling/cropping
if [ $scale ] || [ $crop ] || [ $speed ] || [ $giffix ]; then
  filter="-vf $(join , $scale $crop $speed $giffix)"
else
  filter=
fi

# FPS
if [ $fps ]; then
  fps="-r $fps"
else
  fps=
fi

# Optimization level
#   1: (fastest, worst compression)
#   9: (slowest, best compression)

(( $level > 9 )) && level=9 # OR err
(( $level < 1 )) && level=1 # OR err
optimize="${levels[$level]}"

# Direction options (for use with convert)
direction_opt=
if [[ "$direction" == "reverse" ]]; then
  direction_opt="-coalesce -reverse"
elif [[ "$direction" == "alternate" ]]; then
  direction_opt="-coalesce -duplicate 1,-2-1"
fi

# TODO: Offer further optimizations
#   Contrast frame rate : -crf 22
#   Bit rate : -b:v 1000k

# Codecs:
#   webm:  libvpx
#   h.264: libx264
codec="-c:v libx264"

# Verbosity
verbosity="-loglevel panic"

# Create optimized GIF-like video
if [[ "$direction" == 'reverse' ]] || [[ "$direction" == 'alternate' ]]; then
  ffmpeg $verbosity -i "$filename" -f image2pipe -vcodec ppm - | \
    convert $direction_opt - ppm:- | \
    ffmpeg $verbosity -f image2pipe -vcodec ppm -r 60 -i pipe: \
    $codec $filter $fps -an -pix_fmt yuv420p \
    -preset "$optimize" -movflags faststart "$output"
else
  ffmpeg $verbosity -i "$filename" $codec $filter $fps -an -pix_fmt yuv420p \
    -preset "$optimize" -movflags faststart "$output"
fi

# Cleanup
if [ $cleanup ]; then
  rm "$filename"
fi
