#!/bin/bash

set -a
source tesseract_demo_functions.sh
set +a
bash django/create_django_project.sh

aseta_aika_alku

find testfiles/ -name '*.pdf' -exec bash -c 'handle_pdf "$0"' {} \;

# testataan lukea yks tallennetuista
source .env
luettava_dokkari="$file3"
tiedostonimi_kannassa=$(basename "$luettava_dokkari")

# --skip-column-names, -N
cd "$CREATED_DJANGO_PROJECT"
seq 0 $(mysql $DATABASE_NAME -N -e "select max(id) from document '%${tiedostonimi_kannassa}%'") | parallel python3 scripti.py {}
