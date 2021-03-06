#!/usr/bin/python3

import os
os.environ['OMP_THREAD_LIMIT'] = '1'    # ACTUALLY WORKS. MUST BE SET BEFORE TESSERACT IMPORTS.
# TODO: not needed? 
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

document_id=sys.argv[1]
image_file=sys.argv[2]
page_id=sys.argv[3]

# print("The arguments are: " , str(sys.argv))
# print(f'saatiin argumentt document_id:{document_id}')
# print(f'saatiin argumentti image_file:{image_file}')
# print(f'saatiin argumentti page_id:{page_id}')

env_path = Path('.') / '.env'
load_dotenv(dotenv_path=env_path, verbose=True)

connection = pymysql.connect(host=os.getenv("DATABASE_HOST"),
                         user=os.getenv("DATABASE_USER"),
                         password=os.getenv("DATABASE_PASSWORD"),
                         db=os.getenv("DATABASE_NAME")
                         )
cursor=connection.cursor()

data=tesserakti.image_to_data(image_file, output_type=Output.DATAFRAME, config="--dpi 600 -l eng")

data.fillna(value="", inplace=True) # replace NaN words with "" TODO: drop these? or something? TODO: tsekkaa

common_columns="vasen, top, width, height, created"

from datetime import datetime
aikaleima = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

# korvataan kaikissa tesseractin antama sivunumero joka on aina 1 koska se tulkitsee yhtä kuvatiedostoa kerrallaan.
def persist_page(row):
    sql = f"INSERT INTO tes_page (page_id, document_id, {common_columns}) VALUES ({'%s,'*(7-1)}%s)"
    values = (page_id, document_id, row.left, row.top, row.width, row.height, aikaleima)
    cursor.execute(sql, values)

def persist_block(row):
    sql = f"INSERT INTO tes_block (block_id, page_id, document_id, {common_columns}) VALUES ({'%s,'*(8-1)}%s)"
    values = (row.block_num, page_id, document_id, row.left, row.top, row.width, row.height, aikaleima)
    cursor.execute(sql, values)

def persist_paragraph(row):
    sql = f"INSERT INTO tes_paragraph (paragraph_id, block_id, page_id, document_id, {common_columns}) VALUES ({'%s,'*(9-1)}%s)"
    values = (row.par_num, row.block_num, page_id, document_id, row.left, row.top, row.width, row.height, aikaleima)
    cursor.execute(sql, values)

def persist_line(row):
    sql = f"INSERT INTO tes_line (line_id, paragraph_id, block_id, page_id, document_id, {common_columns}) VALUES ({'%s,'*(10-1)}%s)"
    values = (row.line_num, row.par_num, row.block_num, page_id, document_id, row.left, row.top, row.width, row.height, aikaleima)
    cursor.execute(sql, values)

def persist_word(row):
    sql = f"INSERT INTO tes_word (text, conf, word_id, line_id, paragraph_id, block_id, page_id, document_id, {common_columns}) VALUES ({'%s,'*(13-1)}%s)"
    values = (row.text, row.conf, row.word_num, row.line_num, row.par_num, row.block_num, page_id, document_id, row.left, row.top, row.width, row.height, aikaleima)
    cursor.execute(sql, values)

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

connection.commit()
connection.close()

print(f"tesseract text and structures recognized from '{image_file}' and persisted to database done.")
