#!/bin/bash
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/scripts

file=$1
name=$(basename $1)
name="${name%.*}"
dir=$(dirname $1)
session_root_dir=$(dirname $(dirname $file))
session_final_dir=$session_root_dir/finals

mkdir -p $session_final_dir

solve_dir=$(dirname ${1})/../solves

function convert_master_to_jpg() {
    . $script_dir/lib/util.sh
    convert_fit_to_jpg $file $session_final_dir    
}

convert_master_to_jpg && 
    echo "==> ✅ CONVERTED: DONE" ||
    echo "==> ❌ CONVERTING: Failed"
