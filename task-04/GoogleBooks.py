import json
import requests
import pandas as pd

class GoogleBooksAPI(object):

    def __init__(self):
        self.reading_list = list()

        fp = open('config.json', 'r')
        self.__config = json.load(fp)
    
    def get_books_genre(self, genre, max_res=10):
        resp = requests.get(
            self.__config['google_books_endpoints']['books_by_genre'].format(genre=genre, max_results=max_res)
        )

        books = list()

        if resp.status_code == 200:
            data = resp.json()

            for item in data.get('items', []):
                book = item.get('volumeInfo', {})

                book_info = dict()
                book_info['Title'] = book.get('title', 'N/A')
                book_info['Authors'] = ', '.join(book.get('authors', []))
                book_info['Publisher'] = book.get('publisher', 'N/A')
                book_info['Published Date'] = book.get('publishedDate', 'N/A')
                book_info['Description'] = book.get('description', 'N/A')
                book_info['Page Count'] = book.get('pageCount', 'N/A')
                book_info['Categories'] = ', '.join(book.get('categories', []))
                book_info['Average Rating'] = book.get('averageRating', 'N/A')
                book_info['Ratings Count'] = book.get('ratingsCount', 'N/A')
                book_info['Language'] = book.get('language', 'N/A')

                books.append(book_info)

        return books, resp.status_code

    def get_preview_link(self, book_name):
        resp = requests.get(
            self.__config['google_books_endpoints']['book_name_url'].format(book_name=book_name)
        )

        preview_link = ""

        if resp.status_code == 200:
            data = resp.json()

            if 'items' in data and len(data['items']) > 0:
                book_info = data['items'][0]['volumeInfo']
                preview_link = book_info.get('previewLink', 'No preview available')

        return preview_link, resp.status_code

    def convert_books_to_csv(self, books, genre):
        books_df = pd.DataFrame(books)
        books_df.to_csv(f'{genre}_books.csv', index=False)

        return f'{genre}_books.csv'

if __name__ == '__main__':
    gb_api = GoogleBooksAPI('')
    books, code = gb_api.get_books_genre('Crime')
    prev_link, code = gb_api.get_preview_link(books[0]['Title'])
    print(prev_link, code)
