#!/bin/bash

source tesseract_demo_functions.sh

bash database/create_database.sh
bash django/create_django_project.sh

file1='testfiles/1305599480.pdf' # text-pdf
file2='testfiles/Books/Peterson Field Guide to the Mammals_OCR.pdf' # ocr-converted-pdf
file3='testfiles/39 Geiser 2009.pdf' # small

# taulukoita
file4='testfiles/geb12194-sup-0001-si.pdf'
file5='testfiles/415 Gagnon,Mario 2000.pdf'
file6='testfiles/714 Caro, TM 2003.pdf'

file7='testfiles/Books/Gardner_Mammals of South America Vol 1-Marsupials Xenarthrans Shrews and Bats.pdf'
file8='testfiles/Mammalian Species/836.pdf'

file9='testfiles/Strasser-1992-American_Journal_of_Physical_Anthropology.pdf'

aseta_aika_alku

#handle_pdf "$file1" # works
# handle_pdf "$file2" # hidas
  handle_pdf "$file3" # works, small and fast
# handle_pdf "$file4" # 
# handle_pdf "$file5" # 
# handle_pdf "$file6" # 

# # 
# handle_pdf "$file7" # 
# handle_pdf "$file8" # 
#handle_pdf "$file9" # 

# run python script in headless django

# testataan lukea yks tallennetuista
source .env
luettava_dokkari="$file3"
tiedostonimi_kannassa=$(basename "$luettava_dokkari")

# --skip-column-names, -N
cd "$CREATED_DJANGO_PROJECT"
seq 0 $(mysql $DATABASE_NAME -N -e "select max(id) from document where filename like '%${tiedostonimi_kannassa}%'") | parallel python3 scripti.py {}
