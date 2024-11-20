DROP DATABASE IF EXISTS bookstore;
CREATE DATABASE bookstore;
USE bookstore;

CREATE TABLE author
(
    id         INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    birth_date DATE        NOT NULL
);

CREATE TABLE language
(
    id   INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE book
(
    isbn             CHAR(13) PRIMARY KEY,
    title            VARCHAR(100)   NOT NULL,
    language_id      INT            NOT NULL,
    price            DECIMAL(10, 2) NOT NULL,
    publication_date DATE           NOT NULL,
    author_id        INT            NOT NULL,
    FOREIGN KEY (language_id) REFERENCES language (id),
    FOREIGN KEY (author_id) REFERENCES author (id)
);

CREATE TABLE bookstore
(
    id   INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL
);

CREATE TABLE inventory
(
    store_id INT           NOT NULL,
    isbn     CHAR(13)      NOT NULL,
    amount   INT DEFAULT 0 NOT NULL,
    PRIMARY KEY (store_id, isbn),
    FOREIGN KEY (store_id) REFERENCES bookstore (id),
    FOREIGN KEY (isbn) REFERENCES book (isbn)
);

INSERT INTO author (first_name, last_name, birth_date)
VALUES ('J.R.R', 'Tolkien', '1892-01-3'),
       ('J.K', 'Rowling', '1965-07-31'),
       ('Harper', 'Lee', '1926-04-28');

INSERT INTO language (name)
VALUES ('English'),
       ('Swedish'),
       ('French');

INSERT INTO book (isbn, title, language_id, price, publication_date, author_id)
VALUES ('9781485915560', 'Lord of the Rings', 1, 300.00, '1954-07-29', 1),
       ('9780505702067', 'Harry Potter 1', 3, 250.00, '1997-06-26', 2),
       ('9780505702066', 'To kill a mockingbird', 2, 200.00, '1960-07-11', 3);

INSERT INTO bookstore (name, city)
VALUES ('Malmö Bokhandel', 'Malmö'),
       ('Akademibokhandeln', 'Stockholm');

INSERT INTO inventory (store_id, isbn, amount)
VALUES (1, '9781485915560', 10),
       (1, '9780505702067', 5),
       (2, '9781485915560', 8),
       (2, '9780505702067', 3),
       (2, '9780505702066', 19);

CREATE VIEW total_author_book_value AS
SELECT CONCAT(a.first_name, ' ', a.last_name)       AS name,
       TIMESTAMPDIFF(YEAR, a.birth_date, CURDATE()) AS age,
       COUNT(DISTINCT b.isbn)                       AS book_title_count,
       SUM(b.price * i.amount)                      AS inventory_value
FROM author a
         LEFT JOIN book b ON a.id = b.author_id
         LEFT JOIN inventory i ON b.isbn = i.isbn
GROUP BY a.id;

-- Creating users, dev and web
CREATE USER 'dev_user'@'localhost' IDENTIFIED BY 'devUserPw';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, DROP
    ON bookstore.*
    TO 'dev_user'@'localhost';
REVOKE CREATE USER, DROP
    ON *.*
    FROM 'dev_user'@'localhost';

CREATE USER 'web_user'@'localhost' IDENTIFIED BY 'webUserPw';
GRANT SELECT, INSERT, UPDATE, DELETE
    ON bookstore.*
    TO 'web_user'@'localhost';
REVOKE CREATE, DROP, CREATE USER
    ON *.*
    FROM 'web_user'@'localhost';

-- Select the view
SELECT *
FROM total_author_book_value;

SHOW GRANTS FOR 'dev_user'@'localhost';
SHOW GRANTS FOR 'web_user'@'localhost';






