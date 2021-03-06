#!/usr/bin/python3
import os
import sys
import pytesseract as tesserakti
from pytesseract import*
from dotenv import load_dotenv
from pathlib import Path 
import pymysql

pdf_path=sys.argv[1]

print(f"@START OF PERSIST INITIAL DOCUMENTS.")

print("The arguments are: " , str(sys.argv))
print(f'saatiin argumentti pdf_path:{pdf_path}')

env_path = Path('.') / '.env'
load_dotenv(dotenv_path=env_path, verbose=True)

connection = pymysql.connect(host=os.getenv("DATABASE_HOST"),
                         user=os.getenv("DATABASE_USER"),
                         password=os.getenv("DATABASE_PASSWORD"),
                         db=os.getenv("DATABASE_NAME")
                         )
cursor=connection.cursor()

def persist_document(pdf_filename, koko, summaluku):
    from datetime import datetime
    aikaleima = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    sql = f"INSERT INTO pdf_document ( filename, size, sha1sum, created, updated ) VALUES (%s, %s, %s, %s, %s)"
    values = (pdf_filename, koko, summaluku, aikaleima, aikaleima)
    cursor.execute(sql, values)
    new_id=cursor.lastrowid
    return new_id

# parse filename
pdf_filename=os.path.basename(pdf_path)

# find out sha1sum
import subprocess
command_result = subprocess.run(['sha1sum', f"{pdf_path}"], stdout=subprocess.PIPE)
summaluku=command_result.stdout.decode('utf-8').split()[0]
# find out filesize
command_result = subprocess.run(['stat', '--printf=%s',f"{pdf_path}"], stdout=subprocess.PIPE)
koko=int(command_result.stdout.decode('utf-8'))

print(f'pdf_filename: {pdf_filename} koko:{koko} summaluku:{summaluku}')
document_id = persist_document(pdf_filename, koko, summaluku)
uusi_hakemisto=f'media_files/pdf/{summaluku}'
os.makedirs(uusi_hakemisto, exist_ok=True)
print(f'luotiin uusi hakemisto: {uusi_hakemisto}')
from shutil import copy
copy(pdf_path, f'{uusi_hakemisto}/{pdf_filename}')
print(f'kopioitiin pdf uuteen hakemistoon.')

connection.commit()
connection.close()

print(f"@END OF PERSIST INITIAL DOCUMENTS.")
