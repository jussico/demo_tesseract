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

# add index to all id-fields
sed -i 's/_id = models.IntegerField()/_id = models.IntegerField(db_index=True)/g' "tesserakti/models.py"

# also add index to all non-id integer-fields. ( maybe useful )
sed -i 's/ = models.IntegerField()/ = models.IntegerField(db_index=True)/g' "tesserakti/models.py"

# index for text-field ( = word )
sed -i 's/models.CharField(max_length=200)/models.CharField(max_length=200, db_index=True)/g' "tesserakti/models.py"

# rename tables with tes_ prefix in tesserakti-project
sed -i "s/\(db_table = '\)\(.*$\)/\1tes_\2/g" "tesserakti/models.py" 

# set DateTimeFields to current date

sed -i 's/from django.db import models/from django.db import models\nfrom django.utils import timezone\nimport pytz/g' "tesserakti/models.py" 
sed -i 's/from django.db import models/from django.db import models\nfrom django.utils import timezone\nimport pytz/g' "pdf/models.py" 
sed -i 's/models.DateTimeField()/models.DateTimeField(default=timezone.now)/g' "tesserakti/models.py" 
sed -i 's/models.DateTimeField()/models.DateTimeField(default=timezone.now)/g' "pdf/models.py" 

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
