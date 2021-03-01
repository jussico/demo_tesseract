Tesseract OCR demo
==================

* convert .pdf files to images.
* recognize text and structure from converted images with tesseract and write results to database.  
* load data from database.  
TODO:
* draw tesseract-recognized words and structures to images.
* test some text analysis library and save results to database and draw these too.

Usage
=====

Ubuntu 20.04  

0. copy .env-example to .env and set variable values ( or get one from extractiontool/ as it has the same variables )

1. bash 0_install_and_setup_tools.sh  

2. copy some pdf-files to testfiles/  

3. ( to run single pdfs modify and run: bash 1_test_some_files.sh )  

4. to run all pdf files run bash 2_convert_all_pdfs.sh  

