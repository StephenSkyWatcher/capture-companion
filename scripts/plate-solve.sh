#!/bin/bash
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# https://astrometry.net/doc/readme.html#tricks-and-tips
#  validate directory
[[ -z "$1" ]] && {
    echo "Missing image path: ./plate-solve.sh  <path_to_image>";
    exit 1;
}

src_img=$1
name=$(basename $src_img)
name="${name%.*}"

tmp_file="/tmp/$name.jpg"
solve_dir="$(dirname $file)/solves/$(basename $file)"

function plate_solve() {

    source $script_dir/lib/util.sh

    is_raw=$(is_raw_image $src_img)
    
    if [ "$is_raw" = "true" ]; then
        convert_raw_to_jpg $src_img $tmp_file > /dev/null 2>&1
        src_img=$tmp_file
    fi

    solve-field $src_img \
        -D $solve_dir \
        --cpulimit 30 \
        --scale-units degwidth --scale-low 0.1 --scale-high 180.0 \
        --downsample 2 > /dev/null 2>&1
    
    rm $solve_dir/$name-indx.png > /dev/null 2>&1
    rm $solve_dir/$name-ngc.png > /dev/null 2>&1
    rm $solve_dir/$name-objs.png > /dev/null 2>&1

    echo $solve_dir
}

plate_solve
