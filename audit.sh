#!/bin/bash
: <<'SCRIPT_DESCRIPTION'
audit.sh

Author: Stephen Young
Description: Process that extracts data from images and annotates them to help
                with the analysis of the images taken during a session.
                - Plate Solves
                - Extracts WCS
                - Plots constellations
                - Creates histogram
                - Calculates luminosity
                - Create an annotated image with all information
Example:
    ./audit.sh /path/to/image.cr2
SCRIPT_DESCRIPTION

: <<'VALIDATION'
Checks if the directory argument is provided
VALIDATION

[[ -z "$1" ]] && {
    echo "Missing image path: ./audit.sh  <path_to_image>";
    exit 1;
}

file=$1
name=$(basename $file)
name="${name%.*}"
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/scripts
caputre_json_path="${file}.details.json"
session_root_dir=$(dirname $(dirname $file))
session_json_path="$session_root_dir/details.json"
latest_annotated_image_path=$session_root_dir/latest-annotated.jpg

function calculate_luminance() {
    local tmp_json_path="/tmp/details.json"
    luminance=$(. $script_dir/luminance.sh $file)
    session_data=$(cat $session_json_path | jq '.')

    jq -n \
        --arg luminance "$luminance" \
        '. += {"luminance": $luminance}' \
        > $caputre_json_path
    
    lum_data=$(cat $caputre_json_path | jq '.')
    combined=$(jq -n ". += $lum_data | . += $session_data")  
    echo $combined | jq '.' > $caputre_json_path 
}

function generate_histogram() {
    local histogram_path="$file.histogram.jpg"
    $script_dir/histogram.sh $file $histogram_path
}

function solve() {
    solved_path=$(. $script_dir/plate-solve.sh $file)
}

function extract_wcs() {
    local tmp_json_path="/tmp/wcs.json"
    local wcs_path="$solved_path/$name.wcs"

    wcs_json=$(. $script_dir/wcs.sh $wcs_path)
    details_json=$(cat $caputre_json_path)
    combined=$(jq -n ". += $details_json | . += $wcs_json")   

    echo $combined | jq '.' > $caputre_json_path
}

function plot_image() {
    local wcs_path="$solved_path/$name.wcs"
    local overlay_path="$file.overlay.jpg"
    local tmp_plot_png_path="$file.plot.png"
    . $script_dir/plot.sh $wcs_path $tmp_plot_png_path
    plotted_image=$(. $script_dir/lib/overlay.sh $file $tmp_plot_png_path $overlay_path)
    rm $tmp_plot_png_path
}

function annotate_image() {
    . $script_dir/annotate.sh \
        $plotted_image \
        $caputre_json_path \
        $file.annotated.jpg > /dev/null 2>&1
    cp $file.annotated.jpg $latest_annotated_image_path
}

calculate_luminance && 
    echo "==> ✅ CALCULATE LUMINANCE: ${luminance}%" ||
    echo "==> ❌ CALCULATING LUMINANCE: Failed"

generate_histogram && 
    echo "==> ✅ GENERATE HISTOGRAM: DONE" ||
    echo "==> ❌ GENERATING HISTOGRAM: Failed"

echo "==> PLATE SOLVING..." && solve && 
    echo "==> ✅ PLATE SOLVING: Done" ||
    echo "==> ❌ PLATE SOLVING: Failed"

extract_wcs && 
    echo "==> ✅ EXTRACT WCS: Done" ||
    echo "==> ❌ EXTRACTING WCS: Failed"

plot_image && 
    echo "==> ✅ PLOTTING: Done" ||
    echo "==> ❌ PLOT: Failed"

annotate_image && 
    echo "==> ✅ ANNOTATED: Done" ||
    echo "==> ❌ ANNOTATION: Failed"
