#!/bin/bash

function aseta_aika_alku {
    aika_alku=$(date +%s)    
    export aika_alku
}

# https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit
default="$(tput sgr 0)"
red="$(tput setaf 1)"
green="$(tput setaf 2)"
blue="$(tput setaf 4)"
lightblue="$(tput setaf 6)" # cyan
yellow="$(tput setaf 3)"
magenta="$(tput setaf 5)"

function red {
    printf "${red}$@${default}\n"
}
function green {
    printf "${green}$@${default}\n"
}
function blue {
    printf "${light_blue}$@${default}\n" # light is better
}
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
dpi_resoluutio=600
function create_xml {
	filepath="$@"
	green "input image file: $filepath"
	file_dir=$(dirname "$filepath")
	file_name=$(basename "$filepath")
	blue "output xml file: output_alto/${file_dir}/${file_name}.xml"
	mkdir -p "output_alto/$file_dir"
	OMP_THREAD_LIMIT=1 # for tesseract. they say only ~20% improvement with threads so disable them and use all CPUs with parallel.
	export OMP_THREAD_LIMIT
	tesseract "$@" "output_alto/$file_dir/$file_name" -l eng --dpi "$dpi_resoluutio" alto quiet
}
function handle_pdf {
    aika_nyt
	tiedostopolku="$1"
	magenta "input pdf file: $tiedostopolku"
	tiedosto_nimi=$(basename "$tiedostopolku")	
	tiedosto_hakemisto=$(dirname "$tiedostopolku")
	full_image_output_path="output_image/$tiedostopolku"
	green "output image filepath: ${full_image_output_path}/"
	mkdir -p "$full_image_output_path"
    sivuja=$(qpdf --show-npages "$tiedosto_hakemisto/$tiedosto_nimi")
	export -f green
	function pdf_to_images {
		i=$1
		green "output image: ${full_image_output_path}/${tiedosto_nimi}-${i}.png"
		# limit imageMagick thread count to 1 which looks like optimal as using more threads is much less than 100% impr. and use all CPUs with parallel.
		convert -limit thread 1 -density "$dpi_resoluutio" "${tiedosto_hakemisto}/${tiedosto_nimi}"[$i] "${full_image_output_path}/${tiedosto_nimi}-${i}.png"
	}
	export full_image_output_path tiedosto_nimi dpi_resoluutio tiedosto_hakemisto
	export -f pdf_to_images

	cores_to_use=$(nproc)
	green "parallel running on maximum number of cores (including hyperthreads): $cores_to_use"
	echo $(printf 'CPU %.0s' $(seq 1 $cores_to_use))' :)'
	echo
	green "converting ${tiedosto_nimi}:${sivuja} pages to .png-files."
	seq 0 $((sivuja-1)) | parallel --bar pdf_to_images {}
	green "parallel finished converting ${sivuja} pages to .png-files."
    echo "("$(aika_nyt)")"

	image_output_path="$tiedostopolku" # withouth output_image
	# parallel wants these exported
	export image_output_path image_file_name
	export -f create_xml blue
	kuvia=$(find "$full_image_output_path" -name *.png | wc -l)
	blue "converting ${kuvia} .png-files in ${full_image_output_path}/ to xml."
	find "$full_image_output_path" -name *.png | parallel --bar create_xml {}
	# find "$full_image_output_path" -name *.png | parallel --jobs 50% create_xml {}
	blue "finished converting ${kuvia} .png-files to xml."

	magenta "@END of handle_pdf"	
	aika_nyt
}
