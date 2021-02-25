#!/bin/bash

# Ubuntu 20.04

mkdir testfiles/

sudo apt install tesseract-ocr

sudo apt install imagemagick

sudo apt install qpdf

sudo apt install parallel

# fix ImageMagick
tiedosto="/etc/ImageMagick-6/policy.xml"

# disable this. this is security issue enabled which prevents doing anything..
sudo sed -i 's/<policy domain="coder" rights="none" pattern="PDF" \/>/<policy domain="coder" rights="none" pattern="OHTU_PROJEKTI_DISABLED_PDF" \/>/'  "$tiedosto"

# NOTE: looks like these are not needed when converting one-page-at-a-time. 
# NOTE: 600DPI seems to work with default settings.
# NOTE: 1200DPI fails with errors:
# convert-im6.q16: cache resources exhausted `output_image/testfiles/1305599480.pdf/1305599480.pdf-0.png' @ error/cache.c/OpenPixelCache/4083.
# convert-im6.q16: memory allocation failed `output_image/testfiles/1305599480.pdf/1305599480.pdf-0.png' @ error/png.c/WriteOnePNGImage/9108.
# convert-im6.q16: No IDATs written into file `output_image/testfiles/1305599480.pdf/1305599480.pdf-0.png' @ error/png.c/MagickPNGErrorHandler/1641.
# TODO: don't care? 1200DPI not needed ever?


# NOTE: these notes below are when trying to use convert without specifying one-page-at-a-time.
# 1Gb to 16Gb disk memory limit. Peterson Field Guide to the Mammals_OCR.pdf fails with 1GiB.
# sudo sed -i 's/<policy domain="resource" name="disk" value="1GiB"\/>/<policy domain="resource" name="disk" value="16GiB"\/>/'  "$tiedosto"

# relax more limits.
# imagemagick really likes memory. with 8GiB about 4 times faster than 2GiB.
# e.g. convert 5-1-PB.pdf used 7GiB memory in Windows Task Manager, script running on WSL/Ubuntu 20.04
# Books/Gardner_Mammals of South America Vol 1-Marsupials Xenarthrans Shrews and Bats.pdf used 8.2GiB
# MB_LIMIT="16GiB" # 16GiB = ~60x times more memory..
# KB_LIMIT="256KP"

# sudo sed -i 's/<policy domain="resource" name="memory" value="256MiB"\/>/<policy domain="resource" name="memory" value="'$MB_LIMIT'"\/>/' "$tiedosto"   # memory
# sudo sed -i 's/<policy domain="resource" name="map" value="512MiB"\/>/<policy domain="resource" name="map" value="'$MB_LIMIT'"\/>/' "$tiedosto" # map
# sudo sed -i 's/<policy domain="resource" name="width" value="16KP"\/>/<policy domain="resource" name="width" value="'$KB_LIMIT'"\/>/' "$tiedosto"   # width
# sudo sed -i 's/<policy domain="resource" name="height" value="16KP"\/>/<policy domain="resource" name="height" value="'$KB_LIMIT'"\/>/' "$tiedosto" # height
# sudo sed -i 's/<policy domain="resource" name="area" value="128MB"\/>/<policy domain="resource" name="area" value="'$MB_LIMIT'"\/>/' "$tiedosto"    # area

# echo "$tiedosto"

# alkup.

# pakolliset
# <policy domain="coder" rights="none" pattern="PDF" />
# <policy domain="resource" name="disk" value="1GiB"/>

# performance-säätö-testit
# <policy domain="resource" name="memory" value="256MiB"/>
# <policy domain="resource" name="map" value="512MiB"/>
# <policy domain="resource" name="width" value="16KP"/>
# <policy domain="resource" name="height" value="16KP"/>
# <policy domain="resource" name="area" value="128MB"/>
