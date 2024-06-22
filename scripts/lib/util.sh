#!/bin/bash

function is_raw_image() {

    [[ -z "$1" ]] && {
        echo "Missing image path: is_raw_image  <path_to_image>";
        exit 1;
    }

    local src=$1
    local mime=$(exiftool -s -S -MIMEType $src)

    if [ "$mime" = "image/x-canon-cr2" ] || [ "$mime" = "image/x-canon-cr3" ]|| [ "$mime" = "image/fits" ]; then
        echo "true"
    else
        echo "false"
    fi
}

function convert_raw_to_jpg() {
    [[ -z "$1" ]] && {
        echo "Missing image path: convert_raw_to_jpg  <path_to_src_image> <path_to_dest_image>";
        exit 1;
    }

    [[ -z "$2" ]] && {
        echo "Missing dest path: convert_raw_to_jpg  <path_to_src_image> <path_to_dest_image>";
        exit 1;
    }

    if [ -e "$2" ]; then
        rm $2
    fi
    
    darktable-cli $1 $2
}

function convert_fit_to_jpg() {
    [[ -z "$1" ]] && {
        echo "Missing image path: convert_fit_to_jpg  <path_to_src_image> <path_to_dest_image>";
        exit 1;
    }

    [[ -z "$2" ]] && {
        echo "Missing dest dir: convert_fit_to_jpg  <path_to_src_image> <path_to_dest>";
        exit 1;
    }

    input=$1
    dir=$2

    name=$(basename $1)
    name="${name%.*}"

    convert $1 /tmp/$name.jpg

    echo /tmp/$name.jpg

    r=/tmp/$name-0.jpg
    g=/tmp/$name-1.jpg
    b=/tmp/$name-2.jpg
    
    cp $r $dir/r.jpg
    cp $g $dir/g.jpg
    cp $b $dir/b.jpg

    convert $r $g $b -combine $dir/$name-converted.jpg

    rm /tmp/$name.jpg
    rm $r
    rm $g
    rm $b
}