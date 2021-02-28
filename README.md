Tesseract OCR demo
==================

* convert .pdf files to images.
* recognize text and structure from converted images with tesseract and write results to database.  
TODO:
* load data from database.
* draw tesseract-recognized words and structures to images.

Usage
=====

Ubuntu 20.04  

0. copy .env-example to .env and set variable values ( or get one from extractiontool/ as it has the same variables )

1. bash 0_install_and_setup_tools.sh  

2. bash 1_create_database.sh 
 
3. copy some pdf-files to testfiles/  

4. ( to run single pdfs modify and run: bash 1_test_some_files.sh )  

5. to run all pdf files run bash 2_convert_all_pdfs.sh  

