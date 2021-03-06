-- tesseract tables
\! echo creating tesseract tables

DROP TABLE IF EXISTS tes_word;
DROP TABLE IF EXISTS tes_line;
DROP TABLE IF EXISTS tes_paragraph;
DROP TABLE IF EXISTS tes_block;
DROP TABLE IF EXISTS tes_page;

-- tsv level=1
CREATE TABLE page(
    id INTEGER UNIQUE AUTO_INCREMENT, -- id=generated id, for easy access
    page_id INTEGER NOT NULL,
    document_id INTEGER NOT NULL,
    vasen INTEGER NOT NULL, 
    top INTEGER NOT NULL,
    width INTEGER NOT NULL,
    height INTEGER NOT NULL,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PRIMARY KEY pk_tpage (page_id, document_id),
    CONSTRAINT FOREIGN KEY (document_id) REFERENCES document(id),
    INDEX (page_id),
    INDEX (document_id)
);

-- tsv level=2
CREATE TABLE block(
    id INTEGER UNIQUE AUTO_INCREMENT,
    block_id INTEGER NOT NULL,
    page_id INTEGER NOT NULL,
    document_id INTEGER NOT NULL,
    vasen INTEGER NOT NULL,
    top INTEGER NOT NULL,
    width INTEGER NOT NULL,
    height INTEGER NOT NULL,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,    
    CONSTRAINT PRIMARY KEY pk_tblock (block_id, page_id, document_id),
    CONSTRAINT FOREIGN KEY (page_id, document_id) REFERENCES page(page_id, document_id)
);

-- tsv level=3
CREATE TABLE paragraph(
    id INTEGER UNIQUE AUTO_INCREMENT,
    paragraph_id INTEGER NOT NULL,
    block_id INTEGER NOT NULL,
    page_id INTEGER NOT NULL,
    document_id INTEGER NOT NULL,
    vasen INTEGER NOT NULL,
    top INTEGER NOT NULL,
    width INTEGER NOT NULL,
    height INTEGER NOT NULL,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,    
    CONSTRAINT PRIMARY KEY pk_tparagraph (paragraph_id, block_id, page_id, document_id),
    CONSTRAINT FOREIGN KEY (block_id, page_id, document_id) REFERENCES block(block_id, page_id, document_id)
);

-- tsv_sv level=4
CREATE TABLE `line`(
    id INTEGER UNIQUE AUTO_INCREMENT,
    line_id INTEGER NOT NULL,
    paragraph_id INTEGER NOT NULL,
    block_id INTEGER NOT NULL,
    page_id INTEGER NOT NULL,
    document_id INTEGER NOT NULL,
    vasen INTEGER NOT NULL,
    top INTEGER NOT NULL,
    width INTEGER NOT NULL,
    height INTEGER NOT NULL,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,    
    CONSTRAINT PRIMARY KEY pk_tline (line_id, paragraph_id, block_id, page_id, document_id),
    CONSTRAINT FOREIGN KEY (paragraph_id, block_id, page_id, document_id) REFERENCES paragraph(paragraph_id, block_id, page_id, document_id)
);

-- tsv level=5
CREATE TABLE word(
    id INTEGER UNIQUE AUTO_INCREMENT,
    word_id INTEGER NOT NULL,
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
    text VARCHAR(200) NOT NULL,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,    
    CONSTRAINT PRIMARY KEY pk_tline (word_id, line_id, paragraph_id, block_id, page_id, document_id),
    CONSTRAINT FOREIGN KEY (line_id, paragraph_id, block_id, page_id, document_id) REFERENCES `line`(line_id, paragraph_id, block_id, page_id, document_id)
);

