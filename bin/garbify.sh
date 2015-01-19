#!/bin/bash
#
#                  _     _  __
#  __ _  __ _ _ __| |__ (_)/ _|_   _
# / _` |/ _` | '__| '_ \| | |_| | | |
#| (_| | (_| | |  | |_) | |  _| |_| |
# \__, |\__,_|_|  |_.__/|_|_|  \__, |
# |___/                        |___/
#
#
# Give it a filename to an image and it will turn it into zooming
# garb.
#
# By Paul Ford in a moment of weakness

SUFFIX=jpg
COLORS=32
FILE=$1
DELAY=20
FAST=15
PAUSE=100
LONG_PAUSE=400
GIF_NAME=`basename "$FILE" | sed -E "s/\.[A-Za-z]+$//"`.gif

convert -scale 600 "$FILE" f_000.$SUFFIX ;
convert -quality 5%  -gravity Center -scale 400 -extent 150% -modulate 100,0,100  f_000.$SUFFIX f_001.$SUFFIX;
convert -quality 10%  -gravity Center -scale 450 -extent 133% -modulate 100,40,100 f_000.$SUFFIX f_002.$SUFFIX; 
convert -quality 20%  -gravity Center -scale 500 -extent 120% -modulate 100,80,100 f_000.$SUFFIX f_003.$SUFFIX;
convert -modulate 100,200,100 f_000.$SUFFIX f_004.$SUFFIX;
convert -quality 60%  -modulate 100,80,150 f_000.$SUFFIX f_005.$SUFFIX; 

COLORS="-colors 16 +dither -posterize 16"

convert -loop 0 \
	$COLORS -delay $DELAY f_001.$SUFFIX f_002.$SUFFIX f_003.$SUFFIX \
	$COLORS -delay $FAST f_004.$SUFFIX f_005.$SUFFIX f_004.$SUFFIX f_005.$SUFFIX \
	$COLORS -delay $DELAY f_004.$SUFFIX f_005.$SUFFIX \
	$COLORS -delay $LONG_PAUSE f_004.$SUFFIX \
	$COLORS -delay $DELAY f_003.$SUFFIX f_002.$SUFFIX \
	"$GIF_NAME";

rm f_00*.$SUFFIX;
