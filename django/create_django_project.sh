#!/bin/bash

set -e

# https://docs.djangoproject.com/en/3.1/intro/tutorial01/

sudo apt install python-is-python3

source tesseract_demo_functions.sh
source .env

alku=$(pwd)

# delete previous installs
rm -rf "./$CREATED_DJANGO_PROJECT"

# create new project
$(django-admin startproject "$CREATED_DJANGO_PROJECT")

cd $CREATED_DJANGO_PROJECT

# create app
CREATED_APP_NAME="tesserakti"
python manage.py startapp "$CREATED_APP_NAME"

# set up database
tiedosto=$CREATED_DJANGO_PROJECT/settings.py
sed -i "s/'ENGINE': 'django.db.backends.sqlite3'/'ENGINE': 'django.db.backends.mysql'/" $tiedosto
sed -i "s/\
        'NAME': BASE_DIR \/ 'db.sqlite3',/\
        'HOST': '${DATABASE_HOST}',\n\
        'PORT': '${DATABASE_PORT}',\n\
        'NAME': '${DATABASE_NAME}',\n\
        'USER': '${DATABASE_USER}',\n\
        'PASSWORD': '${DATABASE_PASSWORD}',\n\
        'TEST': {\n\
            'NAME': 'mytestdatabase',\n\
        },\n\
/" $tiedosto
blue "${tiedosto}:" && cat $tiedosto | grep -A 12 DATABASES 

# set timezone
sed -i "s/TIME_ZONE = 'UTC'/TIME_ZONE = 'Europe\/Helsinki'/" $tiedosto
blue "${tiedosto}:" && cat $tiedosto | grep TIME_ZONE

# create django models for tesseract-tables
echo "overwriting empty $$CREATED_APP_NAME/models.py with tesseract-tables models."
python3 manage.py inspectdb > "$CREATED_APP_NAME/models.py"
echo "$CREATED_DJANGO_PROJECT/$CREATED_APP_NAME/models.py:"
cat "$CREATED_APP_NAME/models.py"

# add app to INSTALLED_APPS
tiedosto=$CREATED_DJANGO_PROJECT/settings.py
sed -i "s/\
INSTALLED_APPS = \[/\
INSTALLED_APPS = \[\n\
    'tesserakti',/" $tiedosto
blue "${tiedosto}:" && cat $tiedosto | grep -A 8 INSTALLED_APPS

# copy script to run in this django project root.
cp "${alku}/django/read_tesseract_info_from_database_and_draw_to_pictures_script.py" "scripti.py"
tiedosto=scripti.py
blue "${tiedosto}:" && cat $tiedosto
