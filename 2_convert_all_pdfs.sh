#!/bin/bash

set -a
source tesseract_demo_functions.sh
set +a

aseta_aika_alku

find testfiles/ -name '*.pdf' -exec bash -c 'handle_pdf "$0"' {} \;
