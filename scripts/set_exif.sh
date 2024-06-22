# # #!/bin/bash
# # # weather_json=$1
# # # src=$2

# # # "title": "' + str(title) + '", \
# # # "luminance": "' + str(lum_val) + '", \
# # # "target": { \
# # #     "id": "' + target_id + '", \
# # #     "name": "' + target_name + '", \
# # #     "ra": "' + target_ra + '", \
# # #     "dec": "' + target_dec + '" \
# # # }, \
# # # "moonday": "' + weather.get('moonday') + '", \
# # # "moonphase": "' + weather.get('moonphase') + '", \
# # # "wind": "' + weather.get('wind') + '", \
# # # "precipitation": "' + weather.get('precipitation') + '", \
# # # "zenith": "' + weather.get('zenith') + '", \
# # # "condition": "' + weather.get('condition') + '", \
# # # "humidity": "' + weather.get('humidity') + '", \
# # # "temperature": "' + weather.get('') + '", \
# # # "ra": "' + ra + '", \
# # # "dec": "' + dec + '" \

# # weather_data=""
# # solve_data=""
# # temperature=""
# # Humidity=""

# # function get_weather_data() {
# #     local json_path=$1
# #     temperature=$(cat $json_path | jq '.temperature')
# #     humidity=$(cat $json_path | jq '.humidity')
# #     weather_data=$(cat $json_path | jq '''{
# #         latitude: .latitude,
# #         longitude: .longitude,
# #         weather: .weather,
# #         cloudCover: .cloudCover,
# #         dewPoint: .dewPoint,
# #         windSpeed: .windSpeed,
# #         moonEmoji: .moon_phase_emoji,
# #         moonPhase: .moon_phase_text,
# #         moonriseTime: .moonriseTime,
# #         moonsetTime: .moonsetTime
# #     }''') 
# # }

# # function get_solve_data() {
# #     local json_path=$1

# #     solve_data=$(cat $json_path | jq '.wcs' | jq '''{
# #         imagew: .imagew,
# #         imageh: .imageh,
# #         pixelScale: .pixscale,
# #         orientation: .orientation,
# #         ra: .ra_center_hms,
# #         dec: .dec_center_dms,
# #         fieldwidth: .fieldw,
# #         fieldheight: .fieldh,
# #     }''') 
# # }

# # get_weather_data /home/stephen/Desktop/scripts/mocks/wizard-nebula/start.weather-data.json
# # get_solve_data /home/stephen/Desktop/scripts/mocks/wizard-nebula/solve/stacked.json


# # UserComment=$(jq -n ". += $weather_data | . += $solve_data")
# # AmbientTemperature=$(jq -n ". += {AmbientTemperature: $temperature}")
# # Humidity=$(jq -n ". += {Humidity: $humidity}")

# # echo "-UserComment=${UserComment}"
# # # result = subprocess.run([
# # #     "exiftool",
# # #     '-AmbientTemperature=' + str((float(weather["temperature"].replace('°F', ''))-32)*(5/9)),
# # #     '-Humidity=' + str(float(weather["humidity"].replace('%', ''))/100),
# # #     '-UserComment=moonday:' + weather["moonday"] + ',moonphase:' + weather['moonphase'],
# # #     filepath
# # # ], capture_output=True, text=True, universal_newlines=True)


# import subprocess
# import os
# import json
# from quart import request, current_app
# import trio

# from ._blueprint import blueprint
# from api.util import returnResponse, fetchWeather
    
# @blueprint.route("/append/", methods=["POST"])
# async def exif_append():
#     res = await request.json

#     try:
#         image_url = res['image']
#         title = res['title']
#         ra = res['ra']
#         dec = res['dec']
    
#         if 'target_id' in res.keys():
#             target_id = res['target_id']
#         else:
#             target_id = ''
    
#         if 'target_name' in res.keys():
#             target_name = res['target_name']
#         else:
#             target_name = ''
    
#         if 'target_ra' in res.keys():
#             target_ra = res['target_ra']
#         else:
#             target_ra = ''
    
#         if 'target_dec' in res.keys():
#             target_dec = res['target_dec']
#         else:
#             target_dec = ''


#         image_path = current_app.config['BASE_IMAGE_DIRECTORY'] + os.path.dirname(image_url)
#         image_name= os.path.splitext(os.path.basename(image_url))[0]
#         image_ext= os.path.splitext(os.path.basename(image_url))[1]
#         full_image_path= image_path + '/' + image_name + image_ext

#         # weather = fetchWeather()
#         weather = {}

#         # fixme
#         lum_val = 0

#         result = subprocess.run([
#             "exiftool",
#             '-Title=' + str(title),
#             '-AmbientTemperature=' + str((float(weather.get('temperature').replace('°F', ''))-32)*(5/9)) if weather.get('temperature') else "",
#             '-Humidity=' + str(float(weather.get('humidity').replace('%', ''))/100) if weather.get('humidity') else '',
#             '-UserComment={\
#                 "title": "' + str(title) + '", \
#                 "luminance": "' + str(lum_val) + '", \
#                 "target": { \
#                     "id": "' + target_id + '", \
#                     "name": "' + target_name + '", \
#                     "ra": "' + target_ra + '", \
#                     "dec": "' + target_dec + '" \
#                 }, \
#                 "moonday": "' + weather.get('moonday') + '", \
#                 "moonphase": "' + weather.get('moonphase') + '", \
#                 "wind": "' + weather.get('wind') + '", \
#                 "precipitation": "' + weather.get('precipitation') + '", \
#                 "zenith": "' + weather.get('zenith') + '", \
#                 "condition": "' + weather.get('condition') + '", \
#                 "humidity": "' + weather.get('humidity') + '", \
#                 "temperature": "' + weather.get('') + '", \
#                 "ra": "' + ra + '", \
#                 "dec": "' + dec + '" \
#             }',
#             full_image_path
#         ], capture_output=True, text=True, universal_newlines=True)
#         subprocess.run(['rm', full_image_path + '_original'])
#         r = subprocess.Popen(['exiftool', '-j', full_image_path], stdout=subprocess.PIPE)
#         jr = r.stdout.read()
#         j = jr.decode('utf8').replace("'", '"')
#         data = json.loads(j)

#         data[0]['UserComment'] = json.loads(data[0]['UserComment'])

#         return await returnResponse({ "success": True, "data": data }, 200)
#     except Exception as e:
#         print(e)
#         return await returnResponse({ "error": e.args[0] }, 400)


# @blueprint.route('/', defaults={'image_url': ''})
# @blueprint.route("/<path:image_url>", methods=["GET"])
# async def get_exif_data(image_url):
#     try:
#         image_path = current_app.config['BASE_IMAGE_DIRECTORY'] +  image_url
#         r = await trio.run_process(['exiftool', '-j', image_path], capture_stdout=True, capture_stderr=True)    
#         exif_data = json.loads(r.stdout.decode())
#         return await returnResponse(*exif_data, 200)
#     except Exception as e:
#         print(e)
#         return await returnResponse({ "error": e.args[0] }, 400)