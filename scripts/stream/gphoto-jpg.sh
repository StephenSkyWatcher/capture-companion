gphoto2 \
  --capture-movie \
  --stdout \
  | \
  ffplay \
    -tune zerolatency \
    -an \
    -fflags nobuffer \
    -flags low_delay \
    -re \
    -i pipe:0 \
    -listen 1 -f \
   mjpeg http://raspberrypi.local:8080/feed.jpg

#gphoto2 \
#  --capture-movie \
#  --stdout \
#  | \
#  ffmpeg \
#   -preset ultrafast \
#    -vcodec libx264 \
#    -tune zerolatency \
#    -an \
#    -fflags nobuffer \
#    -flags low_delay \
#    -strict experimental \
#    -avioflags direct \
#    -re \
#    -i pipe:0 \
#    -listen 1 -f \
#  mjpeg http://raspberrypi.local:8080/feed.jpg
