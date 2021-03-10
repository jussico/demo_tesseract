-- tesseract tables
\! echo creating tesseract tables

DROP TABLE IF EXISTS tes_word;
DROP TABLE IF EXISTS tes_line;
DROP TABLE IF EXISTS tes_paragraph;
DROP TABLE IF EXISTS tes_block;
DROP TABLE IF EXISTS tes_page;

-- tsv level=1
CREATE TABLE page(
    id INTEGER PRIMARY KEY AUTO_INCREMENT, -- id=generated id, for easy access
    page_id INTEGER NOT NULL,
    document_id INTEGER NOT NULL,
    vasen INTEGER NOT NULL, 
    top INTEGER NOT NULL,
    width INTEGER NOT NULL,
    height INTEGER NOT NULL,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT UNIQUE pk_tpage (page_id, document_id)
    -- django generates foreign keys wrong and removes _id from names which is all wrong..
    /* ,
    CONSTRAINT FOREIGN KEY (document_id) REFERENCES document(id) */
    -- django just ignores INDEX-definitions..
    /* INDEX (page_id), 
    INDEX (document_id),
    INDEX (vasen),
    INDEX (top),
    INDEX (width),
    INDEX (height) */
);

-- tsv level=2
CREATE TABLE block(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    block_id INTEGER NOT NULL,
    page_id INTEGER NOT NULL,
    document_id INTEGER NOT NULL,
    vasen INTEGER NOT NULL,
    top INTEGER NOT NULL,
    width INTEGER NOT NULL,
    height INTEGER NOT NULL,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,    
    CONSTRAINT UNIQUE pk_tblock (block_id, page_id, document_id)
    /* ,
    CONSTRAINT FOREIGN KEY (page_id, document_id) REFERENCES page(page_id, document_id) */
);

-- tsv level=3
CREATE TABLE paragraph(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    paragraph_id INTEGER NOT NULL,
    block_id INTEGER NOT NULL,
    page_id INTEGER NOT NULL,
    document_id INTEGER NOT NULL,
    vasen INTEGER NOT NULL,
    top INTEGER NOT NULL,
    width INTEGER NOT NULL,
    height INTEGER NOT NULL,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,    
    CONSTRAINT UNIQUE pk_tparagraph (paragraph_id, block_id, page_id, document_id)
    /* ,
    CONSTRAINT FOREIGN KEY (block_id, page_id, document_id) REFERENCES block(block_id, page_id, document_id) */
);

-- tsv_sv level=4
CREATE TABLE `line`(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
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
    CONSTRAINT UNIQUE pk_tline (line_id, paragraph_id, block_id, page_id, document_id)
    /* ,
    CONSTRAINT FOREIGN KEY (paragraph_id, block_id, page_id, document_id) REFERENCES paragraph(paragraph_id, block_id, page_id, document_id) */
);

-- tsv level=5
CREATE TABLE word(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
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
    CONSTRAINT UNIQUE pk_tline (word_id, line_id, paragraph_id, block_id, page_id, document_id)
    /* ,
    CONSTRAINT FOREIGN KEY (line_id, paragraph_id, block_id, page_id, document_id) REFERENCES `line`(line_id, paragraph_id, block_id, page_id, document_id) */
);

-- ALTER TABLE COMMANDS TO ADD TO MANUALLY CRAFTED MIGRATION-FILE:
/* ALTER TABLE tes_page ADD CONSTRAINT FOREIGN KEY tes_page (document_id) REFERENCES pdf_document (id) ;
ALTER TABLE tes_block ADD CONSTRAINT FOREIGN KEY tes_block (page_id, document_id) REFERENCES tes_page(page_id, document_id);
ALTER TABLE tes_paragraph ADD CONSTRAINT FOREIGN KEY (block_id, page_id, document_id) REFERENCES tes_block(block_id, page_id, document_id);
ALTER TABLE tes_line ADD CONSTRAINT FOREIGN KEY (paragraph_id, block_id, page_id, document_id) REFERENCES tes_paragraph(paragraph_id, block_id, page_id, document_id);
ALTER TABLE tes_word ADD CONSTRAINT FOREIGN KEY (line_id, paragraph_id, block_id, page_id, document_id) REFERENCES tes_line(line_id, paragraph_id, block_id, page_id, document_id); */
