#!/bin/bash
equipment_telescopes=("Sharpstar 76EDPH" "Celestron Nextstar 6SE" "None")
equipment_cameras=("Canon T8I" "ZWO ASI120MM Mini w/ SVBONY SV165 30mm F4" "Canon T2I" "None")

# list_choices "${equipment_cameras[@]}"
function list_choices() {  
    local choices=("$@")
    echo "Options:"
    for ((i = 0; i < ${#choices[@]}; i++));do
        echo "  $((i+1)) - ${choices[$i]}"
    done
    echo ""
}

function get_answer() {
    local question=$1
    local _answer=""
    read -p "${question}: " _answer
    echo $((_answer-1))
}

function ask_telescope() {
    local res=$(get_answer "Telescope")
    echo "${equipment_telescopes[res]}"
}

function ask_camera() {
    local res=$(get_answer "Primary Camera")
    echo "${equipment_cameras[res]}"
}

function ask_guiding() {
    local res=$(get_answer "Guide Camera")
    echo "${equipment_cameras[res]}"
}

# function ask_guiding() {
#     local _answer=""
#     local answer=""
#     echo "1.) ZWO ASI120MM Mini w/ SVBONY SV165 30mm F4"
#     echo "2.) None"
    
#     read -p "Guiding: " _answer

#     if [ "$_answer" = "1" ]; then
#         answer="ZWO ASI120MM Mini w/ SVBONY SV165 30mm F4"
#     else
#         answer="false"
#     fi

#     echo $answer
# }