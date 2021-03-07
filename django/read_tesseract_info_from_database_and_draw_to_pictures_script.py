import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'wildchild.settings') # wildchild/wildchild/settings.py
django.setup()

import sys
from tesserakti.models import Word, Page, Block, Paragraph, Line
from pdf.models import Document, DocumentOwner
from shutil import copy
import cv2

document_id=sys.argv[1]
print(f'BEGINNING DRAW of id {document_id}')
# print("The arguments are: " , str(sys.argv))

# figure out file prefix.
dokumentti = Document.objects.get(id=document_id)
tiedosto_prefix=f'media_files/pdf/{dokumentti.sha1sum}/page_png/{dokumentti.filename}'

# insert line to document_owner table
downer = DocumentOwner(document_id=dokumentti.id, owner_id=1)
downer.save()

# draw blocks
sql=f'select * from pdf_document where pdf_document.id={document_id}'
for dokumentti in Document.objects.raw(sql).iterator():
    sql2=f'select * from tes_page where \
        document_id={document_id} order by page_id'
    for sivu in Page.objects.raw(sql2).iterator():
        sql_word=f'select * from tes_block where \
            document_id={document_id} and \
            page_id={sivu.page_id} \
                order by block_id'
        tiedosto_final=f"../{tiedosto_prefix}-{sivu.page_id}.png"
        tiedosto_final_new_copy=f"../{tiedosto_prefix}-{sivu.page_id}-tesseract-6-blocks.png"
        copy(tiedosto_final, tiedosto_final_new_copy)
        new_image = cv2.imread(f'{tiedosto_final_new_copy}')
        for alue in Block.objects.raw(sql_word).iterator():
            draw_color= (255, 0, 255)# BGR, Blue-Green-Red
            cv2.rectangle(new_image, 
                    (alue.vasen, alue.top), 
                    (alue.vasen + alue.width, alue.top + alue.height), 
                    draw_color, 2) 
        cv2.imwrite(tiedosto_final_new_copy, new_image)

# draw paragraphs
sql=f'select * from pdf_document where pdf_document.id={document_id}'
for dokumentti in Document.objects.raw(sql).iterator():
    sql2=f'select * from tes_page where \
        document_id={document_id} order by page_id'
    for sivu in Page.objects.raw(sql2).iterator():
        sql_word=f'select * from tes_paragraph where \
            document_id={document_id} and \
            page_id={sivu.page_id} \
                order by paragraph_id'
        tiedosto_final=f"../{tiedosto_prefix}-{sivu.page_id}.png"
        tiedosto_final_new_copy=f"../{tiedosto_prefix}-{sivu.page_id}-tesseract-3-paragraphs.png"
        copy(tiedosto_final, tiedosto_final_new_copy)
        new_image = cv2.imread(f'{tiedosto_final_new_copy}')
        for alue in Paragraph.objects.raw(sql_word).iterator():
            draw_color= (255, 0, 0)# BGR, Blue-Green-Red# loop all pages
            cv2.rectangle(new_image, 
                    (alue.vasen, alue.top), 
                    (alue.vasen + alue.width, alue.top + alue.height), 
                    draw_color, 2) 
        cv2.imwrite(tiedosto_final_new_copy, new_image)

# draw lines
sql=f'select * from pdf_document where pdf_document.id={document_id}'
for dokumentti in Document.objects.raw(sql).iterator():
    sql2=f'select * from tes_page where \
        document_id={document_id} order by page_id'
    for sivu in Page.objects.raw(sql2).iterator():
        sql_word=f'select * from tes_line where \
            document_id={document_id} and \
            page_id={sivu.page_id} \
                order by line_id'
        tiedosto_final=f"../{tiedosto_prefix}-{sivu.page_id}.png"
        tiedosto_final_new_copy=f"../{tiedosto_prefix}-{sivu.page_id}-tesseract-2-lines.png"
        copy(tiedosto_final, tiedosto_final_new_copy)
        new_image = cv2.imread(f'{tiedosto_final_new_copy}')
        for alue in Line.objects.raw(sql_word).iterator():
            draw_color= (0, 255, 0)# BGR, Blue-Green-Red
            cv2.rectangle(new_image, 
                    (alue.vasen, alue.top), 
                    (alue.vasen + alue.width, alue.top + alue.height), 
                    draw_color, 2) 
        cv2.imwrite(tiedosto_final_new_copy, new_image)

# draw words
sql=f'select * from pdf_document where pdf_document.id={document_id}'
for dokumentti in Document.objects.raw(sql).iterator():
    sql2=f'select * from tes_page where \
        document_id={document_id} order by page_id'
    for sivu in Page.objects.raw(sql2).iterator():
        sql_word=f'select * from tes_word where \
            document_id={document_id} and \
            page_id={sivu.page_id} \
                order by word_id'
        tiedosto_final=f"../{tiedosto_prefix}-{sivu.page_id}.png"
        tiedosto_final_new_copy=f"../{tiedosto_prefix}-{sivu.page_id}-tesseract-1-words.png"
        copy(tiedosto_final, tiedosto_final_new_copy)
        new_image = cv2.imread(f'{tiedosto_final_new_copy}')
        for alue in Word.objects.raw(sql_word).iterator():
            draw_color= (0, 0, 255)# BGR, Blue-Green-Red
            cv2.rectangle(new_image, 
                    (alue.vasen, alue.top), 
                    (alue.vasen + alue.width, alue.top + alue.height), 
                    draw_color, 2) 
        cv2.imwrite(tiedosto_final_new_copy, new_image)

print(f'ENDING DRAW of id {document_id}')
