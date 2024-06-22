#!/bin/bash

#  validation
[[ -z "$1" ]] && {
    echo "Missing image path: ./wcs.sh <path_to_src> <path_to_dest>";
    exit 1;
}

wcs=$1

function get_wcs() {
    park=''
    res=""

    for item in $(wcsinfo $wcs); do
    if [ "$park" = '' ]
    then
        park=$item
    else
        res+="\"$park\": \"$item\" "
        park=''
    fi
    done

    echo "{\"wcs\" : {"$res"}}"| sed "s/\" \"/\", \"/g" | jq .
}

get_wcs