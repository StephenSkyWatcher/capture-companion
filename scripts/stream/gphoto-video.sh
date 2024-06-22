gphoto2 --capture-movie --stdout | \
ffmpeg \
  -tune zerolatency \
  -an \
  -fflags nobuffer \
  -flags low_delay \
  -re \
  -i pipe:0 \
  -listen 1 \
  -f mjpeg http://localhost:8080/feed.mjpg

