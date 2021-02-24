-- tesseract tables
\! echo creating tesseract tables

DROP TABLE IF EXISTS tpage;

-- tsv level=1
CREATE TABLE tpage(
    gid INTEGER UNIQUE AUTO_INCREMENT, -- gid=generated id, for easy access
    id INTEGER NOT NULL,
    document_id INTEGER NOT NULL REFERENCES document(id),
    vasen INTEGER NOT NULL, 
    top INTEGER NOT NULL,
    width INTEGER NOT NULL,
    height INTEGER NOT NULL,
    CONSTRAINT PRIMARY KEY pk_tpage (id, document_id)
);

DROP TABLE IF EXISTS tblock;

-- tsv level=2
CREATE TABLE tblock(
    gid INTEGER UNIQUE AUTO_INCREMENT,
    id INTEGER NOT NULL,
    page_id INTEGER NOT NULL REFERENCES tpage(id),
    document_id INTEGER NOT NULL REFERENCES document(id),
    vasen INTEGER NOT NULL,
    top INTEGER NOT NULL,
    width INTEGER NOT NULL,
    height INTEGER NOT NULL,
    CONSTRAINT PRIMARY KEY pk_tblock (id, page_id, document_id)
);

DROP TABLE IF EXISTS tparagraph;

-- tsv level=3
CREATE TABLE tparagraph(
    gid INTEGER UNIQUE AUTO_INCREMENT,
    id INTEGER NOT NULL,
    block_id INTEGER NOT NULL REFERENCES tblock(id),
    page_id INTEGER NOT NULL REFERENCES tpage(id),
    document_id INTEGER NOT NULL REFERENCES document(id),
    vasen INTEGER NOT NULL,
    top INTEGER NOT NULL,
    width INTEGER NOT NULL,
    height INTEGER NOT NULL,
    CONSTRAINT PRIMARY KEY pk_tparagraph (id, block_id, page_id, document_id)
);

DROP TABLE IF EXISTS tline;

-- tsv level=4
CREATE TABLE tline(
    gid INTEGER UNIQUE AUTO_INCREMENT,
    id INTEGER NOT NULL,
    paragraph_id INTEGER NOT NULL REFERENCES tparagraph(id),
    block_id INTEGER NOT NULL REFERENCES tblock(id),
    page_id INTEGER NOT NULL REFERENCES tpage(id),
    document_id INTEGER NOT NULL REFERENCES document(id),
    vasen INTEGER NOT NULL,
    top INTEGER NOT NULL,
    width INTEGER NOT NULL,
    height INTEGER NOT NULL,
    CONSTRAINT PRIMARY KEY pk_tline (id, block_id, page_id, document_id)
);

DROP TABLE IF EXISTS tword;

-- tsv level=5
CREATE TABLE tword(
    gid INTEGER UNIQUE AUTO_INCREMENT,
    id INTEGER NOT NULL,
    line_id INTEGER NOT NULL REFERENCES tline(id),
    paragraph_id INTEGER NOT NULL REFERENCES tparagraph(id),
    block_id INTEGER NOT NULL REFERENCES tblock(id),
    page_id INTEGER NOT NULL REFERENCES tpage(id),
    document_id INTEGER NOT NULL REFERENCES document(id),
    vasen INTEGER NOT NULL,
    top INTEGER NOT NULL,
    width INTEGER NOT NULL,
    height INTEGER NOT NULL,
    conf INTEGER NOT NULL,
    text VARCHAR(1000) NOT NULL,
    CONSTRAINT PRIMARY KEY pk_tline (id, block_id, page_id, document_id)
);

