#!/bin/bash
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

dir=$1

#  validate directory
[[ -z "$1" ]] && {
    echo "Missing directory: ./initialize.sh <directory>";
    exit 1;
}

source $script_dir/lib/structure.sh

function make_directories() {
    for i in "${structure_directories[@]}"; do
        mkdir -p $dir/$i
    done
}

make_directories