#!/bin/bash

#  validate directory
[[ -z "$1" ]] && {
    echo "Missing image path: ./luminance.sh  <path_to_image>";
    exit 1;
}

src_img=$1
tmp_file="/tmp/tmp.stack.jpg"

function remove_tmp_file() {
    if test -f $tmp_file; then
        rm $tmp_file
    fi
}

function convert_to_jpg() {
    darktable-cli $src_img $tmp_file > /dev/null 2>&1    
}

function get_luminance_value() {
    lum=$(/usr/bin/convert $tmp_file -format "%[fx:100*mean]" info:)
    lum_val=${lum%.*}
}

remove_tmp_file
convert_to_jpg
get_luminance_value
echo $lum_val
