#!/bin/bash

function aseta_aika_alku {
    aika_alku=$(date +%s)    
    export aika_alku
}

# https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit

# tput colors # gives a count

# if (( $(tput colors) > 2 ));
# then
#       echo "We have many colors!"
#       for c in $(seq 0 $(tput colors)); do tput setaf $c; printf $c; done; echo
# fi

default="$(tput sgr 0)"
red="$(tput setaf 1)"
green="$(tput setaf 2)"
blue="$(tput setaf 4)"
lightblue="$(tput setaf 12)" # white?
yellow="$(tput setaf 3)"
magenta="$(tput setaf 5)"

function red {
    printf "${red}$@${default}\n"
}
function green {
    printf "${green}$@${default}\n"
}
function blue {
    printf "${blue}$@${default}\n"
}
# function light_blue {
#     printf "${light_blue}$@${default}\n" # white ??
# }
function yellow {
    printf "${yellow}$@${default}\n"
}
function magenta {
    printf "${magenta}$@${default}\n"
}
function aika_nyt {
    aika_nyt=$(date +%s)
    sekunteja=$(($aika_nyt-$aika_alku))
    osa_sekunnit=$((sekunteja % 60))
    osa_minuutit=$((sekunteja / 60))
    yellow "aikaa kulunut: ${osa_minuutit}m ${osa_sekunnit}s"
}
dpi_resoluutio=600 # TODO: maybe environment-variable? from database?
function image_to_tesseract {
	document_id=$1
	filepath="$2"
	green "input image file: '$filepath'"
	file_dir=$(dirname "$filepath" | sed "s/output_image\///" )
	file_name=$(basename "$filepath")
	# output_types="alto hocr pdf tsv txt makebox" # tsv = data in pytesseract ( image_to_data() )
	# blue "output files from tesseract: output_tesseract/${file_dir}/${file_name}.<type> in ($output_types)"
	mkdir -p "output_tesseract/$file_dir"
	# set in python-script now.
	# export OMP_THREAD_LIMIT
	echo "@image_to_tesseract KAIKKIARGUMENTIT: ${@}"
	sivunumero=$(echo $@ | sed 's/....$//' | awk -F'-' '{print $NF}' ) # | sed: remove last 4 characters | awk: split with '-' and print last column
	python3 tesseract_recognize_text_and_structure_from_image_and_persist_to_database.py $document_id "$filepath" $sivunumero
	# tesseract "$@" "output_tesseract/$file_dir/$file_name" -l eng --dpi "$dpi_resoluutio" $output_types quiet
}
function handle_pdf {
    aika_nyt
	dokumentti_id=$1
	tiedostopolku=$(mysql -N $DATABASE_NAME -e "select concat('media_files/pdf/', sha1sum, '/', filename) from pdf_document where id = ${dokumentti_id}")
	echo "dokumentti-id: ${dokumentti_id}"
	magenta "BEGINNING handling '$tiedostopolku'"
	tiedosto_nimi=$(basename "$tiedostopolku")	
	tiedosto_hakemisto=$(dirname "$tiedostopolku")
	full_image_output_path="$tiedosto_hakemisto/page_png/"
	mkdir -p "$full_image_output_path"
	# full_image_output_path="output_image/$tiedosto_nimi"
	echo "output image filepath: '${full_image_output_path}/'"
	mkdir -p "$full_image_output_path"
	# let it fail. (  714 Caro, TM 2003.pdf )
	set +e
    sivuja=$(qpdf --show-npages "$tiedosto_hakemisto/$tiedosto_nimi" 2>>errors.log.txt)
	set -e
	export -f green
	function pdf_to_images {
		i=$1
		green "output image: '${full_image_output_path}/${tiedosto_nimi}-${i}.png'"
		# limit imageMagick thread count to 1 which looks like optimal as using more threads is much less than 100% impr. and use all CPUs with parallel.
		convert -limit thread 1 -density "$dpi_resoluutio" "${tiedosto_hakemisto}/${tiedosto_nimi}"[$i] "${full_image_output_path}/${tiedosto_nimi}-${i}.png"
	}
	export full_image_output_path tiedosto_nimi dpi_resoluutio tiedosto_hakemisto
	export -f pdf_to_images

	echo "parallel running on maximum number of cores (including hyperthreads): $cores_to_use"
	echo $(printf 'CPU %.0s' $(seq 1 $PARALLEL_JOBS))' :)'
	green "BEGINNING converting ${sivuja} pages of '${tiedosto_nimi}' to .png-files."
	echo "PARALLEL_JOBS=${PARALLEL_JOBS}"
	seq 0 $((sivuja-1)) | parallel --jobs $PARALLEL_JOBS --bar pdf_to_images {}
	green "FINISHED converting ${sivuja} pages to .png-files."
    echo "("$(aika_nyt)")"

	image_output_path="$tiedosto_nimi" # withouth output_image
	# parallel wants these exported
	export image_output_path image_file_name
	export -f image_to_tesseract blue
	kuvia=$(find "$full_image_output_path" -name *.png | wc -l)
	blue "BEGINNING handling ${kuvia} .png-files in '${full_image_output_path}/' with tesseract and persisting to database."

	find "$full_image_output_path" -name *.png | parallel --jobs $PARALLEL_JOBS --bar image_to_tesseract $dokumentti_id "{}"
	# find "$full_image_output_path" -name *.png | parallel --jobs 50% image_to_tesseract {}
	blue "FINISHED handling ${kuvia} .png-files in ${full_image_output_path}/ with tesseract and persisting to database."

	magenta "FINISHED handling '${tiedostopolku}'"
	aika_nyt
}
