import tkinter as tk
from tkinter import messagebox, ttk
import mysql.connector

# Connect to the MySQL Database
def connect_db():
    return mysql.connector.connect(
        host="localhost",  # Change if not localhost
        user="your_mysql_user",  # Replace with your MySQL username
        password="your_mysql_password",  # Replace with your MySQL password
        database="LibraryDB"
    )

# Fetch all books
def fetch_books():
    conn = connect_db()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM Books")
    rows = cursor.fetchall()
    conn.close()
    return rows

# Borrow Book Functionality
def borrow_book():
    member_id = entry_member_id.get()
    book_id = entry_book_id.get()
    
    if not member_id or not book_id:
        messagebox.showerror("Input Error", "Please enter both MemberID and BookID")
        return

    conn = connect_db()
    cursor = conn.cursor()
    try:
        cursor.execute(
            "INSERT INTO Transactions (MemberID, BookID, BorrowDate, DueDate) VALUES (%s, %s, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY))",
            (member_id, book_id)
        )
        cursor.execute(
            "UPDATE Books SET QuantityAvailable = QuantityAvailable - 1 WHERE BookID = %s",
            (book_id,)
        )
        conn.commit()
        messagebox.showinfo("Success", "Book borrowed successfully!")
    except Exception as e:
        messagebox.showerror("Error", str(e))
    conn.close()

# Build UI
root = tk.Tk()
root.title("Library Management System")

# MemberID Input
tk.Label(root, text="Member ID").grid(row=0, column=0)
entry_member_id = tk.Entry(root)
entry_member_id.grid(row=0, column=1)

# BookID Input
tk.Label(root, text="Book ID").grid(row=1, column=0)
entry_book_id = tk.Entry(root)
entry_book_id.grid(row=1, column=1)

# Borrow Book Button
borrow_button = tk.Button(root, text="Borrow Book", command=borrow_book)
borrow_button.grid(row=2, column=0, columnspan=2)

# Show Books Table
books_table = ttk.Treeview(root, columns=("ID", "Title", "Author", "Publisher", "Year", "Genre", "Quantity"), show='headings')
books_table.grid(row=3, column=0, columnspan=2)
for col in books_table["columns"]:
    books_table.heading(col, text=col)

# Populate Books Table
books = fetch_books()
for book in books:
    books_table.insert("", "end", values=book)

root.mainloop()
