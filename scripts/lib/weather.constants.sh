declare -a moon_phases=("New" "Waxing Crescent" "First Quarter" "Waxing Gibbous" "Full" "Waning Gibbous" "Third Quarter" "Waning Crescent")

declare -a moon_phases_emojis=(🌑 🌗 🌘 🌖 🌕 🌓 🌒 🌔)

declare -a weather_units='''{
    "cloudBase": "mi",
    "cloudCeiling": "mi",
    "cloudCover": "%",
    "dewPoint": "Fahrenheit",
    "precipitationIntensity": "in/hr",
    "precipitationProbability": "%",
    "temperature": "Fahrenheit",
    "visibility": "mi",
    "windDirection": "degrees",
    "windGust": "mph",
    "windSpeed": "mph"
}'''

declare -a weather_codes=$(jq --null-input \
    '''{
    "0": "Unknown",
    "1000": "Clear",
    "1001": "Cloudy",
    "1100": "Mostly Clear",
    "1101": "Partly Cloudy",
    "1102": "Mostly Cloudy",
    "2000": "Fog",
    "2100": "Light Fog",
    "3000": "Light Wind",
    "3001": "Wind",
    "3002": "Strong Wind",
    "4000": "Drizzle",
    "4001": "Rain",
    "4200": "Light Rain",
    "4201": "Heavy Rain",
    "5000": "Snow",
    "5001": "Flurries",
    "5100": "Light Snow",
    "5101": "Heavy Snow",
    "6000": "Freezing Drizzle",
    "6001": "Freezing Rain",
    "6200": "Light Freezing Rain",
    "6201": "Heavy Freezing Rain",
    "7000": "Ice Pellets",
    "7101": "Heavy Ice Pellets",
    "7102": "Light Ice Pellets",
    "8000": "Thunderstorm"
    }'''
)