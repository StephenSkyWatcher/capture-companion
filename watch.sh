#!/bin/bash

watch_path=$1
shift 1
cwd=$(pwd)

inotifywait -m -q -e create -r --format '%:e %w%f' $watch_path | while read file; do
    if [[ $file != *"CREATE:ISDIR"* ]]; then
        added_file=${file#"CREATE "}  
        if [[ $file == *.cr2 ]] || [[ $file == *.cr3 ]]; then
            if [[ -f $added_file ]]; then
                mime=$(exiftool -s -S -MIMEType $added_file)
                if [ "$mime" = "image/x-canon-cr2" ] || [ "$mime" = "image/x-canon-cr3" ]|| [ "$mime" = "image/fits" ]; then
                    if [[ "$(dirname $added_file)" = "$(echo $watch_path | sed 's:/*$::')" ]]; then
                        echo ""
                        echo "NEW LIGHT FRAME: "$added_file
                        echo ""
                        cd /home/stephen/Desktop/scripts/
                        . audit.sh $added_file
                        cd $cwd
                    fi
                fi
            fi
        fi
    fi
done
