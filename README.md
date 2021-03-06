Tesseract OCR demo with django
==============================

* create database from .ddl files.
* create new django project.
* create new django apps.
* generate django models from database.
* fix django generated models.
* delete original database.
* generate database again from generated models witd django migrate commands.
* loop .pdf files
    * convert .pdf files to images.
    * using tesseract recognize text and structure from converted images and write results to database.  
* inside generated django project loop all rows in the pdf_document database table. ( Document in the pdf app ).
    * read data from database using django models. ( Block, Paragraph, Line, Word in the tesserakti app ).
    * draw tesseract-recognized words and structures to images.  

TODO:  
* use some text analysis library and/or own algorithm to recognize some words and save results to database. for this, create new tables/models. loop all and draw these too.

Usage
=====

Ubuntu 20.04  

0. copy .env-example to .env and set variable values ( or get one from extractiontool/ as it has the same variables )

1. bash 0_install_and_setup_tools.sh  

2. copy all your pdf-files to testfiles/ and some smaller set to some_files/

3. to test some files run: bash 1_test_some_files.sh

4. to test all files run: bash 2_convert_all_pdfs.sh  

