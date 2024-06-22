#!/bin/bash
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

src=$1
data=$2
dest=$3

details_ra=$(cat $data | jq '.wcs.ra_center')
details_dec=$(cat $data | jq '.wcs.dec_center')
lum=$(cat $data | jq '.luminance')
details_temp=$(cat $data | jq '.temperature | tonumber')
details_wind_speed=$(cat $data | jq '.windSpeed | tonumber')
details_wind_direction=$(cat $data | jq '.windDirection | tonumber')
details_weather=$(cat $data | jq '.weather')
details_humidity=$(cat $data | jq '.humidity | tonumber')
details_moonday=$(cat $data | jq '.moonday | tonumber')
# 
timestamp="$(exiftool -s -S -DateTimeOriginal $src)"
moon=$details_moonday
coords=$(eval echo "$details_ra  $details_dec")
rest="$details_temp°F   Wind: ${details_wind_speed}mph   Humidity: ${details_humidity}%   Weather: $details_weather   Lum: $lum   stephenskywatcher"

annotateImg="${src}"

overlay_layer_tmp=/tmp/astro_tmp_converted.jpg

height=$(exiftool -s3 -ImageHeight $annotateImg)
width=$(exiftool -s3 -ImageWidth $annotateImg)

filename=$(basename -- "$src")
extension="${filename##*.}"

function copyToTmp() {
    cp $src $overlay_layer_tmp
}

function convertToJpg() {
    echo "==> convertToJpg"
    name=$(basename $src)
    name="${name%.*}"
    if [ "${extension}" = 'cr2' ] || \
        [ "${extension}" = 'cr3' ];then
        . $(dirname $0)/../convert/raw_to_jpg.sh $annotateImg /tmp/$name-converted.jpg
        annotateImg="/tmp/$name-converted.jpg"
    elif [ "${extension}" = 'fit' ];then
        . $(dirname $0)/../convert/fit_to_jpg.sh $annotateImg /tmp
        annotateImg=/tmp/$name-converted.jpg
    fi
    
    height=$(exiftool -s3 -ImageHeight $annotateImg)
    width=$(exiftool -s3 -ImageWidth $annotateImg)
}

function addCross() {
    echo "==> addCross"
    convert \
        \(  -size ${height}x${width}\
            -fill none \
            -strokewidth 2 \
            -stroke red \
            -draw "line 0,0 $width,$height" \
            -draw "line $width,0  0,$height" \
        \) \
        -append $annotateImg \
        $overlay_layer_tmp
}

function overlayText() {
    echo "==> overlayText"
    # Creates image with only overlay
    convert \
        \(  -background '#111' \
            -fill '#fff' \
            -stroke '#000' \
            -pointsize 90 \
            -bordercolor "#111" \
            -border 20x20 \
            -gravity NorthWest \
            label:"RA/DEC: $coords" \
        \) -append $overlay_layer_tmp \
        \(  -background '#111' \
            -fill '#fff' \
            -stroke '#000' \
            -pointsize 90 \
            -bordercolor "#111" \
            -border 20x20 \
            -gravity NorthWest \
            label:"$rest" \
        \) -append $overlay_layer_tmp
}

function addMoonPhase() {
    echo "==> addMoonPhase"
    moon_img="$script_dir/lib/moons/color/${moon}.png"
    composite -gravity NorthEast \
    -geometry "+20+20" \
    ${moon_img} \
    ${overlay_layer_tmp} \
    $overlay_layer_tmp
}


function addTimestamp() {
    echo "==> addTimestamp"

    convert $overlay_layer_tmp \
    -gravity SouthEast \
    -pointsize 80 \
    -stroke '#f00' \
    -fill '#f00' \
    -annotate "+10+30" \
    "$timestamp" \
    /tmp/temp-text-annotate.jpg 

    cp /tmp/temp-text-annotate.jpg $overlay_layer_tmp
}

function appendHistogramThumb() {
    echo "==> appendHistogramThumb"
    # . $script_dir/histogram.sh $annotateImg /tmp/tmp-annotate-histogram.jpg
    cp $file.histogram.jpg /tmp/tmp-annotate-histogram.jpg
    convert /tmp/tmp-annotate-histogram.jpg -resize 300% $annotateImg-histogram2.jpg
    composite -resize '1x1<' -gravity SouthEast $annotateImg-histogram2.jpg -geometry +0+165 $overlay_layer_tmp $dest
    rm /tmp/tmp-annotate-histogram.jpg
    rm $annotateImg-histogram2.jpg
}

function copyExif() {
    echo "==> copyExif"
    exiftool -overwrite_original_in_place -TagsFromFile $src "-all:all>all:all" $dest > /dev/null 2>&1
}

if [ "${extension}" = 'cr2' ] || \
    [ "${extension}" = 'cr3' ] || \
    [ "${extension}" = 'fit' ];then
    convertToJpg
fi

copyToTmp
addCross
overlayText
addMoonPhase
addTimestamp
appendHistogramThumb
copyExif

# rm $overlay_layer_tmp
# rm $annotateImg