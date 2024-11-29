CREATE DATABASE LibraryDB;
USE LibraryDB;

CREATE TABLE Books (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(255) NOT NULL,
    Publisher VARCHAR(255),
    YearPublished INT,
    Genre VARCHAR(100),
    QuantityAvailable INT NOT NULL
);

CREATE TABLE Members (
    MemberID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255),
    Phone VARCHAR(20),
    DateJoined DATE
);

CREATE TABLE Transactions (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    MemberID INT,
    BookID INT,
    BorrowDate DATE,
    DueDate DATE,
    ReturnDate DATE,
    Fine DECIMAL(10, 2),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

INSERT INTO Books (Title, Author, Publisher, YearPublished, Genre, QuantityAvailable)
VALUES 
('The Great Gatsby', 'F. Scott Fitzgerald', 'Scribner', 1925, 'Fiction', 3),
('To Kill a Mockingbird', 'Harper Lee', 'J.B. Lippincott & Co.', 1960, 'Fiction', 5),
('1984', 'George Orwell', 'Secker & Warburg', 1949, 'Dystopian', 4);

INSERT INTO Members (Name, Email, Phone, DateJoined)
VALUES 
('Alice Johnson', 'alice@example.com', '123-456-7890', '2023-01-15'),
('Bob Smith', 'bob@example.com', '987-654-3210', '2023-03-20');
INSERT INTO Transactions (MemberID, BookID, BorrowDate, DueDate)
VALUES (1, 1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY));

UPDATE Books
SET QuantityAvailable = QuantityAvailable - 1
WHERE BookID = 1;
UPDATE Transactions
SET ReturnDate = CURDATE(), 
    Fine = CASE 
            WHEN CURDATE() > DueDate THEN DATEDIFF(CURDATE(), DueDate) * 0.5
            ELSE 0 
           END
WHERE TransactionID = 1;

UPDATE Books
SET QuantityAvailable = QuantityAvailable + 1
WHERE BookID = 1;
UPDATE Transactions
SET ReturnDate = CURDATE(), 
    Fine = CASE 
            WHEN CURDATE() > DueDate THEN DATEDIFF(CURDATE(), DueDate) * 0.5
            ELSE 0 
           END
WHERE TransactionID = 1;

UPDATE Books
SET QuantityAvailable = QuantityAvailable + 1
WHERE BookID = 1;
SELECT Transactions.TransactionID, Members.Name, Books.Title, Transactions.BorrowDate, Transactions.DueDate
FROM Transactions
JOIN Members ON Transactions.MemberID = Members.MemberID
JOIN Books ON Transactions.BookID = Books.BookID
WHERE Transactions.ReturnDate IS NULL;
SELECT Members.Name, Books.Title, Transactions.DueDate, Transactions.Fine
FROM Transactions
JOIN Members ON Transactions.MemberID = Members.MemberID
JOIN Books ON Transactions.BookID = Books.BookID
WHERE Transactions.ReturnDate IS NULL AND Transactions.DueDate < CURDATE();
