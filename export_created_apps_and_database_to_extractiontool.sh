#!/bin/bash

set -e

# get this demo-project variables ( DATABASE_NAME, OTHER_PROJECT )
source .env 
# save database name now.
DATABASE_TO_DUMP_FROM=$DATABASE_NAME

# OTHER_PROJECT is extractiontool/ absolute path.

# copy app folders
cp -ar wildchild/tesserakti "$OTHER_PROJECT"
cp -ar wildchild/pdf "$OTHER_PROJECT"

# add apps to settings-file
cd "$OTHER_PROJECT"

# check if apps are installed or not and install if not.
tiedosto=project/settings.py
tunniste=\
"INSTALLED_APPS = \[\n\
    'django.contrib.admin',\n\
"
korvaaja=\
"\
INSTALLED_APPS = \[\n\
    'tesserakti',\n\
    'pdf',\n\
    'django.contrib.admin',\n\
"
sed -z -i "s/$tunniste/$korvaaja/g" $tiedosto
grep -A 10 "INSTALLED_APPS" $tiedosto 

# get other project variables ( DATABASE_NAME )
source .env

# create database tables for other project
python3 manage.py makemigrations
python3 manage.py migrate

mysqldump $DATABASE_TO_DUMP_FROM pdf_document tes_page tes_block tes_paragraph tes_line tes_word > dumppi.txt

mysql $DATABASE_NAME < dumppi.txt
