# #!/bin/bash
# search_directory=$1

# ffmpeg \
#     -framerate 10 \
#     -pattern_type glob \
#     -i "$search_directory/*.jpg" \
#     -vf eq=brightness=-0 \
#     -s:v 1440x1080 \
#     -c:v prores \
#     -profile:v 3 \
#     -pix_fmt yuv422p10 \
#     $search_directory/timelapse.mov