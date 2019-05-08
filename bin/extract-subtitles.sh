#!/bin/bash

extract_subtitles_from_file() {
        local filename="$1"
        local subline="$2"
        tracknumber=`echo $subline | egrep -o "[0-9]{1,2}" | head -1`
        language=`echo $subline | egrep -o 'language:([a-z]{3})' | sed 's/.*://'`
        subtitlename=${filename%.*}
        case "$language" in
                eng)
                        subtitlefilename="$subtitlename.en.srt"
                        ;;
                dut)
                        subtitlefilename="$subtitlename.nl.srt"
                        ;;
                *)
                        subtitlefilename="$subtitlename.srt"
        esac
        if [ -f "$subtitlefilename"  ];
        then
                echo "[ SKIP  ] $subtitlefilename already exists."
        else
                echo "[EXTRACT] $filename -> $subtitlefilename."
               `mkvextract tracks "$filename" $tracknumber:"$subtitlefilename" > /dev/null 2>&1`
        fi
}

process_file() {
        local filename="$1"
        mkvmerge --identify-verbose "$filename" | grep 'subtitles' | while read subline
        do
                extract_subtitles_from_file "$filename" "$subline"
        done
}

process_dir() {
        local dir="$1"
        find "$dir" -type f -name '*.mkv' | while read filename
        do
                process_file "$filename"
        done
}

# If no directory is given, work in local dir
if [ "$1" = "" ]; then
        process_dir "."
# If parameter is file, extract only subtitles for that file
elif [ -f "$1" ]; then
        process_file "$1"
# If parameter is directory, process directory recursively
else
        process_dir "$1"
fi
