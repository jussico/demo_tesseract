-- tesseract tables
\! echo creating tesseract tables

DROP TABLE IF EXISTS tes_word;
DROP TABLE IF EXISTS tes_line;
DROP TABLE IF EXISTS tes_paragraph;
DROP TABLE IF EXISTS tes_block;
DROP TABLE IF EXISTS tes_page;

DROP TABLE IF EXISTS tes_page;

-- tsv level=1
CREATE TABLE tes_page(
    gid INTEGER UNIQUE AUTO_INCREMENT, -- gid=generated id, for easy access
    id INTEGER NOT NULL,
    document_id INTEGER NOT NULL,
    vasen INTEGER NOT NULL, 
    top INTEGER NOT NULL,
    width INTEGER NOT NULL,
    height INTEGER NOT NULL,
    CONSTRAINT PRIMARY KEY pk_tpage (id, document_id),
    CONSTRAINT FOREIGN KEY (document_id) REFERENCES document(id)
);

DROP TABLE IF EXISTS tes_block;

-- tsv level=2
CREATE TABLE tes_block(
    gid INTEGER UNIQUE AUTO_INCREMENT,
    id INTEGER NOT NULL,
    page_id INTEGER NOT NULL,
    document_id INTEGER NOT NULL,
    vasen INTEGER NOT NULL,
    tes_op INTEGER NOT NULL,
    width INTEGER NOT NULL,
    height INTEGER NOT NULL,
    CONSTRAINT PRIMARY KEY pk_tblock (id, page_id, document_id),
    CONSTRAINT FOREIGN KEY (page_id) REFERENCES tes_page(id),
    CONSTRAINT FOREIGN KEY (document_id) REFERENCES document(id)
);

DROP TABLE IF EXISTS tes_paragraph;

-- tsv level=3
CREATE TABLE tes_paragraph(
    gid INTEGER UNIQUE AUTO_INCREMENT,
    id INTEGER NOT NULL,
    block_id INTEGER NOT NULL,
    page_id INTEGER NOT NULL,
    document_id INTEGER NOT NULL,
    vasen INTEGER NOT NULL,
    top INTEGER NOT NULL,
    width INTEGER NOT NULL,
    height INTEGER NOT NULL,
    CONSTRAINT PRIMARY KEY pk_tparagraph (id, block_id, page_id, document_id),
    CONSTRAINT FOREIGN KEY (block_id) REFERENCES tes_block(id),
    CONSTRAINT FOREIGN KEY (page_id) REFERENCES tes_page(id),
    CONSTRAINT FOREIGN KEY (document_id) REFERENCES document(id)
);

DROP TABLE IF EXISTS tes_line;

-- tsv_sv level=4
CREATE TABLE tes_line(
    gid INTEGER UNIQUE AUTO_INCREMENT,
    id INTEGER NOT NULL,
    paragraph_id INTEGER NOT NULL,
    block_id INTEGER NOT NULL,
    page_id INTEGER NOT NULL,
    document_id INTEGER NOT NULL,
    vasen INTEGER NOT NULL,
    top INTEGER NOT NULL,
    width INTEGER NOT NULL,
    height INTEGER NOT NULL,
    CONSTRAINT PRIMARY KEY pk_tline (id, block_id, page_id, document_id),
    CONSTRAINT FOREIGN KEY (paragraph_id) REFERENCES tes_paragraph(id),
    CONSTRAINT FOREIGN KEY (block_id) REFERENCES tes_block(id),
    CONSTRAINT FOREIGN KEY (page_id) REFERENCES tes_page(id),
    CONSTRAINT FOREIGN KEY (document_id) REFERENCES document(id)
);

DROP TABLE IF EXISTS tes_word;

-- tsv level=5
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
    CONSTRAINT PRIMARY KEY pk_tline (id, block_id, page_id, document_id),
    CONSTRAINT FOREIGN KEY (line_id) REFERENCES tes_line(id),
    CONSTRAINT FOREIGN KEY (paragraph_id) REFERENCES tes_paragraph(id),
    CONSTRAINT FOREIGN KEY (block_id) REFERENCES tes_block(id),
    CONSTRAINT FOREIGN KEY (page_id) REFERENCES tes_page(id),
    CONSTRAINT FOREIGN KEY (document_id) REFERENCES document(id)
);

