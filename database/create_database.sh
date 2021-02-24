#!/bin/bash

komento=mysql

set -a
source .env
set +a

echo "env:"
env | grep DATABASE

echo "luodaan kanta."
$komento -u $DATABASE_USER -p"$DATABASE_PASSWORD" $DATABASE_NAME < database/database_common.ddl
$komento -u $DATABASE_USER -p"$DATABASE_PASSWORD" $DATABASE_NAME < database/database_tesseract.ddl

