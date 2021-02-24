-- common tables
\! echo creating common tables

DROP TABLE IF EXISTS tword;
DROP TABLE IF EXISTS tline;
DROP TABLE IF EXISTS tparagraph;
DROP TABLE IF EXISTS tblock;
DROP TABLE IF EXISTS tpage;

DROP TABLE IF EXISTS document;

CREATE TABLE document(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    filename VARCHAR(1000) NOT NULL,
    sha1sum VARCHAR(40)
);
