# PagePal Bot Documentation

**PagePal** is a Telegram bot that helps users find book recommendations, view previews, and manage their reading list using the **Google Books API**.

## Key Features:
- **/start**: Sends a welcome message.
- **/help**: Lists available commands.
- **/book**: Prompts for a genre, then returns a CSV file with book details.
- **/preview**: Asks for a book name, then sends a preview link.
- **/list**: Adds a book to the reading list.
- **/reading_list**: Allows users to add, delete, or view the reading list in `.docx` format.

## GoogleBooksAPI Class

The **GoogleBooksAPI** class is responsible for interacting with the Google Books API to fetch book details and manage the reading list for the PagePal bot.

### Functions:
1. **`get_books_genre(genre, max_res=10)`**:
   - Fetches books of a given genre from the Google Books API.
   - Returns a list of dictionaries containing book details like title, authors, publisher, and more.
   - Status code is returned to ensure API request success.

2. **`get_preview_link(book_name)`**:
   - Fetches the preview link for a specific book based on its name.
   - Returns the preview URL if available, or a message if not.

3. **`convert_books_to_csv(books, genre)`**:
   - Converts the list of books into a CSV file with columns for each book detail.
   - Saves the file with the genre name for easy access.

This class is the backbone of the PagePal bot, enabling users to search for books by genre, view previews, and download the results in CSV format.

## Bot endpoint handler
This is the main entry point where the bot's endpoints are handled.

### Functions:
1. **`send_welcome`**
    - Sends a welcome message when the user starts interacting with the bot.

2. **`send_help`**
    - Provides a detailed list of commands and their descriptions for user assistance.

3. **`send_books`**
    - Prompts the user for a genre and fetches a list of books from the Google Books API, sending back the list in CSV format.

4. **`send_preview`**
    - Prompts the user to enter a book name and retrieves the preview link for the selected book, if available.

5. **`send_list`**
    - Prompts the user to input a book name and adds it to the bot's reading list.

6. **`send_reading_list`**
    - Displays options to:
        - Add a book to the reading list.
        - Delete a book from the reading list.
        - View the reading list in a downloadable `.docx` format.

7. **`handle_button`**
    - Manages button interactions for adding, deleting, or viewing books in the reading list.

8. **`process_genre`**
    - Fetches and sends a list of books based on the genre entered by the user, in CSV format.

9. **`process_preview`**
    - Retrieves and sends the preview link for a book entered by the user.

10. **`process_book_name`**
    - Adds the entered book name to the reading list and prompts the user to manage the list.

## Usage:
To run the bot:
1. Ensure you have a valid `config.json` file with the necessary Telegram bot keys.
2. Install necessary dependencies listed in the `requirements.txt`.
3. Start the bot by running the `run.py`.