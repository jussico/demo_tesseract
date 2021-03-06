#!/bin/bash

set -e

source .env

set -a
source tesseract_demo_functions.sh
set +a

# drop and create database.
mysql -e "DROP DATABASE $DATABASE_NAME; CREATE DATABASE $DATABASE_NAME"

# create database schema
bash database/create_database_schema.sh

# create new django project and generate models from database
bash django/create_django_project.sh

# drop and create database.
mysql -e "DROP DATABASE $DATABASE_NAME; CREATE DATABASE $DATABASE_NAME"

# to the create project
cd wildchild

# change created models to managed
sed -i 's/managed = False/managed = True/g' "tesserakti/models.py"
sed -i 's/managed = False/managed = True/g' "pdf/models.py"

# fix some errors in django-created definitions.
sed -i 's/id = models.AutoField(unique=True)/id = models.AutoField(primary_key=True)/g' "tesserakti/models.py"
sed -i 's/_id = models.IntegerField(primary_key=True)/_id = models.IntegerField(db_index=True)/g' "tesserakti/models.py"

# remove all foreign-keys and turn them to just integer-fields.
sed -i 's/\( *\)\(.*\)\( = models.\)\(ForeignKey.*\)/\1\2_id \3IntegerField(db_index=True)/' "tesserakti/models.py"

# remove unique together-definitions ( natural primary key ) TODO: add later manually maybe
sed -i 's/.*unique_together.*//g' "tesserakti/models.py"

# rename tables with tes_ prefix in tesserakti-project
sed -i "s/\(db_table = '\)\(.*$\)/\1tes_\2/g" "tesserakti/models.py" 

# delete table link in pdf-project
sed -i 's/db_table = .*$//g' "pdf/models.py" 

cat "tesserakti/models.py"
cat "pdf/models.py"

# create database schema again from the created django models
python3 manage.py makemigrations
echo "SQLMIGRATE tesserakti:"
python3 manage.py sqlmigrate tesserakti 0001
echo "SQLMIGRATE pdf:"
python3 manage.py sqlmigrate pdf 0001
python3 manage.py migrate
