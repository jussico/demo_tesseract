#!/bin/bash

set -e

path_to_convert="$1"
echo "@convert_pdfs_in_path, saatin argumentti: ${path_to_convert}"

source .env

PARALLEL_JOBS=$(nproc)
export PARALLEL_JOBS

set -a
source tesseract_demo_functions.sh
set +a

bash create_final_database_and_headless_django.sh

aseta_aika_alku

echo "HAKEMISTOS:$(pwd)"

find "${path_to_convert}/" -name '*.pdf' -exec python3 save_given_pdf_document.py {} \;

mysql $DATABASE_NAME -e 'select * from pdf_document'

unset new_files
while read line
do 
    new_files+=("$line")
done < <(mysql -N $DATABASE_NAME -e "select id from pdf_document")

for new_file in "${new_files[@]}"
do
    handle_pdf "${new_file}"
done

echo "@BEGINNING of drawing rectangles."
cd "wildchild"
export DATABASE_NAME PARALLEL_JOBS
export DATABASE_NAME
printf '%s\n' "${new_files[@]}" | parallel --jobs ${PARALLEL_JOBS} python3 scripti.py {}
echo "@END of drawing rectangles."