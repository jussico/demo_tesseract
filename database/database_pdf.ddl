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
    size INTEGER NOT NULL,
    sha1sum VARCHAR(40) NOT NULL,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, # DEFAULT ei toimi..
    updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP # sama
);

CREATE TABLE document_owner(
    document_id INTEGER NOT NULL REFERENCES document(id),
    owner_id INTEGER NOT NULL REFERENCES users_user(id),
    upload_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, # DEFAULT ei toimi..
    CONSTRAINT UNIQUE (document_id, owner_id)
);

/* -- TODO: jotain tällästä
-- insert {  'create page pictures', 'tesseract' }
CREATE TABLE process_type(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(256) NOT NULL,
    description VARCHAR(1000) NOT NULL,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, # DEFAULT ei toimi..
    updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP # sama
);

CREATE TABLE process(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    process_type_id INTEGER NOT NULL REFERENCES process_type(id),
    state ENUM('created', 'started', 'finished'),
    document_id INTEGER NOT NULL REFERENCES document(id),
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, # DEFAULT ei toimi..
    started TIMESTAMP,
    finished TIMESTAMP
); */
