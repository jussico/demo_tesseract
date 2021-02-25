#!/bin/bash

#tiedosto='output_image/testfiles/39 Geiser 2009.pdf/39 Geiser 2009.pdf-0.png'

# taulukoita
# aika heikkoa, tunnistaa olemattomia alueita ja yksi rivi jää tunnistamatta..
#tiedosto='output_image/testfiles/geb12194-sup-0001-si.pdf/geb12194-sup-0001-si.pdf-0.png'
# heikkoa. pystyyn kirjotettuja tekstejä ei tunnista ollenkaan.
#tiedosto='output_image/testfiles/714 Caro, TM 2003.pdf/714 Caro, TM 2003.pdf-6.png'
# ei hyvä. ei tunnista mitään pystytekstejä..
tiedosto='output_image/testfiles/415 Gagnon,Mario 2000.pdf/415 Gagnon,Mario 2000.pdf-6.png'


gimagereader-gtk "$tiedosto"

