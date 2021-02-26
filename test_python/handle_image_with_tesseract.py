#!/usr/bin/python3

import os
os.environ['OMP_THREAD_LIMIT'] = '1'    # TODO: toimiiko? tarvii olla ennen tesseract importteja?
# os.environ["OMP_NUM_THREADS"]= '1'
# os.environ["OMP_THREAD_LIMIT"] = '1'
# os.environ["MKL_NUM_THREADS"] = '1'
# os.environ["NUMEXPR_NUM_THREADS"] = '1'
# os.environ["OMP_NUM_THREADS"] = '1'
# os.environ["PAPERLESS_AVX2_AVAILABLE"]="false"
# os.environ["OCR_THREADS"] = '1'

import sys
import pytesseract as tesserakti
from pytesseract import*
from dotenv import load_dotenv
from pathlib import Path 
import pymysql

image_file=sys.argv[1]
page_id=sys.argv[2]

# print(f'saatiin argumentti:{image_file}')
# print(f'saatiin argumentti:{page_id}')

env_path = Path('.') / '.env'
load_dotenv(dotenv_path=env_path, verbose=True)

# print(f'minä olen {os.getenv("USER")}')

# create database connection
connection = pymysql.connect(host=os.getenv("DATABASE_HOST"),
                         user=os.getenv("DATABASE_USER"),
                         password=os.getenv("DATABASE_PASSWORD"),
                         db=os.getenv("DATABASE_NAME"))
cursor=connection.cursor()

def persist_document(image_file):
    sql = f"INSERT INTO document ( filename ) VALUES (%s)"
    values = (image_file)
    cursor.execute(sql, values)
    new_id=cursor.lastrowid
    connection.commit()
    return new_id

document_id = persist_document(image_file)


# TODO: dpi, language, OMP_THREAD_LIMIT

tesserakti.OMP_THREAD_LIMIT=1   # TODO: testaa

data=tesserakti.image_to_data(image_file, output_type=Output.DATAFRAME, config="--dpi 600 -l eng") 

data.fillna(value="", inplace=True) # replace NaN words with "" TODO: drop these? or something?

# print(repr(data))

common_columns="vasen, top, width, height"

def persist_page(row):
    sql = f"INSERT INTO tes_page (id, document_id, {common_columns}) VALUES ({'%s,'*(6-1)}%s)"
    values = (page_id, document_id, row.left, row.top, row.width, row.height)
    cursor.execute(sql, values)
    connection.commit()

def persist_block(row):
    sql = f"INSERT INTO tes_block (id, page_id, document_id, {common_columns}) VALUES ({'%s,'*(7-1)}%s)"
    values = (row.block_num, page_id, document_id, row.left, row.top, row.width, row.height)
    cursor.execute(sql, values)
    connection.commit()

def persist_paragraph(row):
    sql = f"INSERT INTO tes_paragraph (id, block_id, page_id, document_id, {common_columns}) VALUES ({'%s,'*(8-1)}%s)"
    values = (row.par_num, row.block_num, page_id, document_id, row.left, row.top, row.width, row.height)
    cursor.execute(sql, values)
    connection.commit()

def persist_line(row):
    sql = f"INSERT INTO tes_line (id, paragraph_id, block_id, page_id, document_id, {common_columns}) VALUES ({'%s,'*(9-1)}%s)"
    values = (row.line_num, row.par_num, row.block_num, page_id, document_id, row.left, row.top, row.width, row.height)
    cursor.execute(sql, values)
    connection.commit()

def persist_word(row):
    sql = f"INSERT INTO tes_word (text, conf, id, line_id, paragraph_id, block_id, page_id, document_id, {common_columns}) VALUES ({'%s,'*(12-1)}%s)"
    values = (row.text, row.conf, row.word_num, row.line_num, row.par_num, row.block_num, page_id, document_id, row.left, row.top, row.width, row.height)
    cursor.execute(sql, values)
    connection.commit()

for row in data.itertuples(index = True, name ='Area'): 
    tyyppi=row.level
    if (tyyppi == 1):
        persist_page(row)
    if (tyyppi == 2):
        persist_block(row)
    if (tyyppi == 3):
        persist_paragraph(row)
    if (tyyppi == 4):
        persist_line(row)
    if (tyyppi == 5):
        persist_word(row)

connection.close()

print("DONE.")
