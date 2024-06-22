#!/bin/bash
MOCKED=1
APIKEY="Rg9Cg8IU3zaZNOYJhqMXXfnkpACQiPD2"
LAT="42.816441"
LON="-71.063988"

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

#  validate directory
[[ -z "$1" ]] && {
    echo "Missing outputpath: ./tomorrow_io.sh <json_output_path>";
    exit 1;
}

OUTPUT_PATH=$1
source $script_dir/lib/weather.constants.sh

dt=$(date '+%m-%d-%Y_%H:%M');

weather_data_json='/tmp/curl_weather_data.json'
moon_data_json='/tmp/curl_moon_data.json'    
mock_weather_data_json="$script_dir/mocks/weather-data.json"
mock_moon_data_json="$script_dir/mocks/weather-moon.json"

# arg: json string
function json_to_query_string() {
    local json=$1
    local query_string=""

    other_keys=$(echo '''
    {
        "apikey": "'''$APIKEY'''",
        "location": "'''$LAT''','''$LON'''",
        "units": "imperial"
    }
    ''' | jq --arg APIKEY "$APIKEY" '.')

    all_keys=$(jq ". += $other_keys" <<< "$json")

    for key in $(echo $all_keys | jq -r 'keys[]'); do
        local value=$(echo $all_keys | jq -r --arg key "$key" '.[$key]')
        query_string="$query_string$key=$value&"
    done
    
    # Remove the trailing '&'
    query_string=${query_string%&}
    echo ?$query_string
}

# args: endpoint, params, output
function tomorrowio() {
    local endpoint=$1
    local _params=$2
    local output=$3

    dt=$(date '+%m_%d_%Y-%H:%M');

    params=$(json_to_query_string "${_params}")

    local url="https://api.tomorrow.io/v4/$endpoint"
    local full_url="$url$params"

    if [ $MOCKED = "1" ];then
        if [ $endpoint = "timelines" ];then
            res=$(jq '.' $mock_weather_data_json)
        else
            res=$(jq '.' $mock_moon_data_json)
        fi
    else
        res=$(curl --request GET --url $full_url)
    fi
    
    echo $res > $output
}

# arg: output [optional]
function curl_moon_data() {
    local output=$moon_data_json
    local endpoint="timelines"
    local params=$(echo '{"timesteps": "1d", "fields": "moonPhase,moonriseTime,moonsetTime"}' | jq '.')
    tomorrowio $endpoint "$params" $output
}

# arg: output [optional]
function curl_weather_data() {
    local output=$weather_data_json
    local endpoint="weather/realtime"
    tomorrowio $endpoint "{}" $output
}

# arg: output [optional]
function get_weather_json() {
    output=$1
    curl_moon_data
    curl_weather_data

    local _moon_addr='.data.timelines[0].intervals[0].values'
    local _moonphase=$(jq $_moon_addr'.moonPhase' $moon_data_json)
    local _moonrise=$(jq $_moon_addr'.moonriseTime' $moon_data_json)
    local _moonset=$(jq $_moon_addr'.moonsetTime' $moon_data_json)
    # 
    local weather_code=$(jq '.data.values.weatherCode' $weather_data_json)
    local moon_phase_text=${moon_phases[$_moonphase]}
    local moon_phase_emoji=${moon_phases_emojis[$_moonphase]}
    local weather=$(echo $weather_codes | jq -r --arg weather_code $weather_code '.[$weather_code]')
    # 
    local moon_data=$(cat $moon_data_json | jq ".data.timelines[0].intervals[0].values | del(.uvIndex,.uvHealthConcern,.temperatureApparent)") 

    local weather_data=$(cat $weather_data_json | jq ".data.values")

    moonday=$(curl -s http://wttr.in\?format\="%M")

    local derived=$(jq --null-input \
    --arg latitude "$LAT" \
    --arg longitude "$LON" \
    --arg weather "$weather" \
    --arg weather_code "$weather_code" \
    --arg moonday "$moonday" \
    --arg moon_phase_text "$moon_phase_text" \
    --arg moon_phase_emoji "$moon_phase_emoji" \
    '$ARGS.named')

    res=$(jq -n ". += $derived | . += $moon_data| . += $weather_data")
    echo $res > $output
}


get_weather_json "$OUTPUT_PATH"
