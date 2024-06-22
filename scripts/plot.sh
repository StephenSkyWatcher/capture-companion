#!/bin/bash

#  validation
[[ -z "$1" ]] && {
    echo "Missing image path: ./plot.sh <path_to_src> <path_to_dest>";
    exit 1;
}

[[ -z "$2" ]] && {
    echo "Missing dest path: ./plot.sh <path_to_src> <path_to_dest>";
    exit 1;
}

wcs=$1
output=$2

function plot_stars() {
    plot-constellations -N -C -B -d -b -j -n 6 -f 82 -J -w $wcs -o $output > /dev/null 2>&1
}

plot_stars