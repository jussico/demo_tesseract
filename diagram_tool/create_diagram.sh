#!/bin/bash
set -e

# run this in demo_tesseract/ with bash diagram_tool/create_diagram.sh

alku=$(pwd)

set -a
source .env
set +a

echo "env:"
env | grep DATABASE

komento="schema"
output_format="png"
output_file="tesseract_tables.${output_format}"
tables='ieluomus.document|ieluomus.tes.*'

cd diagram_tool/schemacrawler-16.12.3-distribution/_schemacrawler/

# png
bash schemacrawler.sh --title="Tesseract taulut" --tables="$tables" --command="${komento}" --output-format="${output_format}" --output-file="${output_file}" --info-level=standard --url="jdbc:mysql://localhost:3306/ieluomus?user=${DATABASE_USER}&password=${DATABASE_PASSWORD}"

cp "$output_file" "${alku}/database"

cd "$alku"

echo "ls database/${output_file} -last" 
ls database/"${output_file}" -last
