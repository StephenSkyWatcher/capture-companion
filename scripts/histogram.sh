#!/bin/bash
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

#  validations
[[ -z "$1" ]] && {
    echo "Missing image path: ./histogram.sh  <path_to_image> <output_path>";
    exit 1;
}

[[ -z "$2" ]] && {
    echo "Missing image path: ./histogram.sh  <path_to_image> <output_path>";
    exit 1;
}

src_img=$1
dest_img=$2
tmp_file='/tmp/tmp.histogram.jpg'

function remove_tmp_file() {
    if test -f $dest_img; then
        rm $dest_img
    fi
}

function generate_histogram() {
    source $script_dir/lib/util.sh

    is_raw=$(is_raw_image $src_img)
    
    if [ "$is_raw" = "true" ]; then
        convert_raw_to_jpg $src_img $tmp_file > /dev/null 2>&1
        src_img=$tmp_file
    fi
    
    convert $src_img histogram:- | convert - $dest_img
}

generate_histogram
