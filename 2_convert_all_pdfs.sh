#!/bin/bash

set -e

bash clean.sh

bash convert_pdfs_in_path.sh testfiles/
