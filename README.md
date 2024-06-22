# Capture Companion

These scripts lets someone who is actively taking photos of the night sky to monitor
the quality of the images, get realtime statistics, plate solving, luminosity, histograms
annotated images, fits conversion and much more.

## Initialize a session

- Stores equipment/hardware information
- Provisions new directories
- Fetches and stores local weather and moon phase

#### Command
>./initialize.sh \<dir\> \<mock\>

_If 2nd argument is `LIVE`, Weather API calls will be made
All other values will mock the weather API_

```bash
# Mocked Weather Example
./initialize.sh /home/photos/pinwheel

# Live Weather API Example
./initialize.sh /home/photos/pinwheel LIVE
```

## Audit a frame

- Calculates luminance
- Generates histogram jpg
- Plate Solves
- Extracts WCS data and plots composite
- Generates an annotated image preview

#### Command
>./audit.sh \<file\>

```bash
# example
./audit.sh /home/photos/pinwheel/0001.cr3
```

## Finalize Session

- TODO...
- Stacks
- Converts final fit to jpg
- Appends EXIF data to photos
- TODO...

#### Command
>./finalize.sh \<stacked fits file\>

```bash
# example
./finalize.sh /home/photos/pinwheel/masters/final.fit
```