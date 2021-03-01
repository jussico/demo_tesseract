import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'wildchild.settings') # wildchild/wildchild/settings.py
django.setup()

import sys
from tesserakti.models import TesWord

document_id=sys.argv[1]
print(f'BEGINNING DRAW of id {document_id}')
# print("The arguments are: " , str(sys.argv))
# print(f'saatiin argumentti page_id:{document_id}')

# TODO: hae kaikki tiedot kaikista tauluista ja piirrä.

sql=f'select * from tes_word where document_id={document_id} order by line_id, id limit 20'
print(f"luetaan tietokannasta: {sql}")
for word in TesWord.objects.raw(sql):
    print(word.text, word.vasen, word.top, word.width, word.height)

print(f'ENDING DRAW of id {document_id}')
'''
CREATE TABLE tes_word(
    gid INTEGER UNIQUE AUTO_INCREMENT,
    id INTEGER NOT NULL,
    line_id INTEGER NOT NULL,
    paragraph_id INTEGER NOT NULL,
    block_id INTEGER NOT NULL,
    page_id INTEGER NOT NULL,
    document_id INTEGER NOT NULL,
    vasen INTEGER NOT NULL,
    top INTEGER NOT NULL,
    width INTEGER NOT NULL,
    height INTEGER NOT NULL,
    conf INTEGER NOT NULL,
    text VARCHAR(1000) NOT NULL,
'''
