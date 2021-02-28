-- common tables
\! echo creating common tables

DROP TABLE IF EXISTS tes_word;
DROP TABLE IF EXISTS tes_line;
DROP TABLE IF EXISTS tes_paragraph;
DROP TABLE IF EXISTS tes_block;
DROP TABLE IF EXISTS tes_page;

DROP TABLE IF EXISTS document;

CREATE TABLE document(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    filename VARCHAR(1000) NOT NULL,
    sha1sum VARCHAR(40)
);
