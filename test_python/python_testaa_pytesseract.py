#!/usr/bin/python3

# import PIL.Image as kuva # kuulemma huono, saattaa sotkea kuvan
import pytesseract as tesserakti
import os

def image_to_txt(filename):
    txt = tesserakti.image_to_string(filename)
    # txt = tesserakti.image_to_string(kuva.open(filename))
    return txt

def image_to_pdf(filename):
    pdf = tesserakti.image_to_pdf_or_hocr(filename, extension='pdf')
    # pdf = tesserakti.image_to_pdf_or_hocr(kuva.open(filename), extension='pdf')
    return pdf

def image_to_hocr(filename):
    hocr = tesserakti.image_to_pdf_or_hocr(filename, extension='hocr')
    # hocr = tesserakti.image_to_pdf_or_hocr(kuva.open(filename), extension='hocr')
    return hocr

def image_to_osd(filename):
    osd = tesserakti.image_to_osd(filename)
    # osd = tesserakti.image_to_osd(kuva.open(filename)) 
    return osd

def image_to_data(filename):    # same as .tsv format
    data = tesserakti.image_to_data(filename)
    # data = tesserakti.image_to_data(kuva.open(filename)) 
    return data

def image_to_boxes(filename):
    boxes = tesserakti.image_to_boxes(filename)
    # boxes = tesserakti.image_to_boxes(kuva.open(filename)) 
    return boxes

def image_to_alto_xml(filename):
    alto_xml = tesserakti.image_to_alto_xml(filename)
    # alto_xml = tesserakti.image_to_alto_xml(kuva.open(filename)) 
    return alto_xml

def bytes_to_file(bitit, new_filename):
    f = open(new_filename, "w+b")
    f.write(bytearray(bitit))
    f.close()

image_file='output_image/testfiles/39 Geiser 2009.pdf/39 Geiser 2009.pdf-0.png'
output_path='out_pytesseract';

# txt
print('txt:\n' + image_to_txt('output_image/testfiles/39 Geiser 2009.pdf/39 Geiser 2009.pdf-0.png'))

# pdf
pdf=image_to_pdf(image_file)
print(f'writing {output_path}/{image_file}.pdf')
bytes_to_file(pdf, f"{output_path}/{os.path.basename(image_file)}.pdf")

# hocr
hocr=image_to_hocr(image_file)
print(f'writing {output_path}/{image_file}.hocr')
bytes_to_file(hocr, f"{output_path}/{os.path.basename(image_file)}.hocr")

# osd
osd=image_to_osd(image_file)
print('osd:\n' + osd)

# data
data=image_to_data(image_file)
print('data:\n' + data)

# boxes
boxes=image_to_boxes(image_file)
print('boxes:\n' + boxes)

# alto_xml
alto_xml=image_to_alto_xml(image_file)
# # print('alto_xml:\n' + repr(alto_xml))
print(f'writing {output_path}/{image_file}.xml')
bytes_to_file(alto_xml, f"{output_path}/{os.path.basename(image_file)}.xml")

print("DONE.")
