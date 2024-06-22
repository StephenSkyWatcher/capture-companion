#!/bin/bash
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

[[ -z "$1" ]] && {
    echo "Missing src path: ./overlay.sh <path_to_src> <path_to_overlay> <path_to_dest>";
    exit 1;
}

[[ -z "$2" ]] && {
    echo "Missing overlay path: ./overlay.sh <path_to_src> <path_to_overlay> <path_to_dest>";
    exit 1;
}

[[ -z "$3" ]] && {
    echo "Missing dest path: ./overlay.sh <path_to_src> <path_to_overlay> <path_to_dest>";
    exit 1;
}

src_img=$1
overlay_img=$2
dest_img=$3

function overlay_images() {
    source $script_dir/util.sh
    
    is_raw=$(is_raw_image $src_img)
    
    if [ "$is_raw" = "true" ]; then
        convert_raw_to_jpg $src_img "/tmp/tmp.converted.jpg" > /dev/null 2>&1
        src_img="/tmp/tmp.converted.jpg"
    fi

    convert $src_img $overlay_img -composite $dest_img > /dev/null 2>&1
    echo $dest_img
}

overlay_images