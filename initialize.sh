#!/bin/bash
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/scripts

: <<'SCRIPT_DESCRIPTION'
initialize.sh
    
    Author: Stephen Young

    Description:
        Initializes a new session by creating the necessary directories and files

    Example:
        ./initialize.sh /path/to/session
SCRIPT_DESCRIPTION

dir=$(echo $1 | sed 's:/*$::')
session_root_dir=$dir

# Checks if the directory argument is provided
[[ -z "$1" ]] && {
    echo "Missing directory: ./initialize.sh <directory>";
    exit 1;
}

_MOCK="${2:-0}"

if [ $_MOCK = "LIVE" ]; then
   MOCK_WEATHER_API=0
else
   MOCK_WEATHER_API=1
fi

echo $MOCK_WEATHER_API
exit
# Prompts the user to select the equipment to be used for the session
function get_equipment() {
    . $script_dir/lib/equipment.sh
    clear
    list_choices "${equipment_telescopes[@]}"
    telescope=$(ask_telescope)
    clear
    list_choices "${equipment_cameras[@]}"
    camera=$(ask_camera)
    clear
    list_choices "${equipment_cameras[@]}"
    guider=$(ask_guiding)
    clear
    echo "$telescope $camera $guider"
    clear
    echo "Equipment selected:"
    echo "  - Telescope: $telescope"
    echo "  - Camera: $camera"
    echo "  - Guiding: $guider"
    echo ""
}

# Creates the session directory and adds the necessary directories and files
function setup_directory() {
    $script_dir/scaffolding.sh $session_root_dir
}

# Queries Tomorrow.io API for current weather data and saves it to a file
# and adds the equipment data to the same file
function create_session_data() {
    local weather_json_path="$session_root_dir/weather-data.json"
    local session_json_path="$session_root_dir/details.json"

    $script_dir/tomorrow_io.sh $weather_json_path $MOCK_WEATHER_API

    cat $weather_json_path | jq \
        --arg telescope "$telescope" \
        --arg guiding "$guider" \
        --arg camera "$camera" \
        '. += {"telescope": $telescope, "guiding": $guiding, "camera": $camera}' \
        > $session_json_path && rm $weather_json_path
}

# get_equipment && 
#     echo "==> ✅ GET EQUIPMENT: Done" ||
#     echo "==> ❌ GET EQUIPMENT: Failed"

# setup_directory &&
#     echo "==> ✅ SCAFFOLD SESSION DIRECTORY: Done" ||
#     echo "==> ❌ SCAFFOLD SESSION DIRECTORY:  Failed"

create_session_data &&
    echo "==> ✅ CREATE SESSION DATA: Done" ||
    echo "==> ❌ CREATE SESSION DATA:  Failed"
