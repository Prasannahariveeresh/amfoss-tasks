# My Favourite Task: Pirate's Dilemma

I was super excited to solve this task specifically because this is a tricky task and made me brainstorm to come up with an idea. I have broken down the code and my approach here as a blog post.

## Adding a Command Line Interface with `click`

To make the scraper more accessible and user-friendly, We were asked to use Command Line Interface (CLI) using Python's `click` library. This will allow the user to add parameters while running the application from their terminal, providing options such as language filters, output directories, and hashing.

### CLI Structure

The CLI should accept multiple parameters, which include:
- **`file_path`**: The path to the video file for which subtitles are needed.
- **`-l/--language`**: Filters subtitles by language (default is English).
- **`-o/--output`**: Specifies the output folder where the subtitles will be saved.
- **`-s/--file-size`**: An optional flag to filter subtitles by movie file size.
- **`-h/--match-by-hash`**: An optional flag that enables matching subtitles by the movie hash.
- **`-b/--batch-download`**: Enables batch mode, where subtitles are downloaded for multiple movies in a directory instead of a single file.

Now let us initialize those parameters in `run.py`

```python
import os
import sys
import utils
import click
import requests

@click.command()
@click.argument('file_path')
@click.option('-l', '--language', default='en', help='Filter subtitles by language.')
@click.option('-o', '--output', default='.', help='Specify the output folder for the subtitles.')
@click.option('-s', '--file-size', is_flag=True, help='Filter subtitles by movie file size.')
@click.option('-h', '--match-by-hash', is_flag=True, help='Match subtitles by movie hash.')
@click.option('-b', '--batch-download', is_flag=True, help='Enable batch mode.')
```

### CLI Flow

This flow is managed by `HashAlgorithm` and `OpenSubtitles`. The `HashAlgorithm` contains functions required for hashing and `Opensubtitles` contains functions for scraping and downloading the subtitles. Now let's initialize these classes.

```python
import os
import re
import struct
import tempfile
import requests

from bs4 import BeautifulSoup
from urllib.parse import urlparse

class HashAlgorithm(object):
    def __init__(self):
       self.__64k = 65536
       self.__longlong_format_char = 'q'
       self.__byte_size = struct.calcsize(self.__longlong_format_char)

class OpenSubtitles(object):
    def __init__(self):
       self.search_url = 'https://www.opensubtitles.org/en/search/sublanguageid-{lang}/imdbid-{imdb_id}'
       self.download_url = 'https://www.opensubtitles.org/en/subtitleserve/sub/{sub_id}'
```

- **IMDb ID Lookup**: When the user provides a file path, the CLI extracts the movie name from the file name (e.g., `inception.mp4` will search for the movie "Inception") and then fetches the IMDb ID from the IMDb websites search page, this function uses three different approaches to make sure that the data is scraped and the data is fetched with headers to make sure that the request is not a robot. All these are taken care of in the `imdb_id()` function from the `OpenSubtitles` class. Let us create a function named `imdb_id()` under the `OpenSubtitles` class
```python
class OpenSubtitles(object):
    ...

    def imdb_id(self, title):
        url = f"http://www.imdb.com/find?s=all&q={requests.utils.quote(title)}"

        headers = {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36'
        }

        response = requests.get(url, headers=headers)
        response.raise_for_status()

        soup = BeautifulSoup(response.text, 'html.parser')

        # Method 1
        movie_element = soup.select('a.ipc-metadata-list-summary-item__t[role="button"]')
        movie_element = [el for el in movie_element if '/title/' in el.get('href', '')]

        # Method 2
        if not movie_element:
            movie_element = soup.select('a[role="button"][tabindex="0"]')
            movie_element = [el for el in movie_element if '/title/' in el.get('href', '')]

        # Method 3
        if not movie_element:
            movie_element = soup.find_all('a', class_=lambda x: x and 'ipc-metadata-list-summary-item' in x)
            movie_element = [el for el in movie_element if '/title/' in el.get('href', '')]

        if movie_element:
            link = movie_element[0].get('href')
            imdb_title = movie_element[0].get_text(strip=True)
        else:
            raise Exception('Movie element not found')

        if not link or not imdb_title or "tt" not in link:
            raise Exception('Invalid movie link')

        match = re.search(r'/title/(tt\d+)/?', link)
        if not match:
            raise Exception('ID not found')

        imdb_id = match.group(1)
        return imdb_title, imdb_id

    ...
```


- **Hash Matching**: If the user opts for hash matching with the `--match-by-hash` flag, the program calculates the hash using the `hash_size_File_url()` method from the `HashAlgorithm` class. This hash is calculated by `filehash = filesize + 64bit sum of the first and last 64k of the file` and then used to narrow down subtitle results.
```python
class HashAlgorithm(object):

	def __init__(self):
		self.__64k = 65536
		self.__longlong_format_char = 'q'
		self.__byte_size = struct.calcsize(self.__longlong_format_char)

	def temp_file(self):
		file = tempfile.NamedTemporaryFile()
		filename = file.name
		return filename

	def is_local(self, _str):
		if os.path.exists(_str):
			return True
		elif urlparse(_str).scheme in ['', 'file']:
			return True
		return False

	def hash_size_File_url(self, filepath):

		#https://trac.opensubtitles.org/projects/opensubtitles/wiki/HashSourceCodes
		#filehash = filesize + 64bit sum of the first and last 64k of the file

		name = filepath
		if self.is_local(filepath):
			local_file = True
		else:
			local_file = False

		if local_file == False:
			f = None
			url = name

			response = requests.head(url)
			filesize = int(response.headers['content-length'])

			if filesize < self.__64k * 2:
				try: filesize = int(str(response.headers['content-range']).split('/')[1])
				except: pass


			first_64kb = self.temp_file()
			last_64kb = self.temp_file()

			headers = {"Range": 'bytes=0-%s' % (str(self.__64k -1 ))}
			r = requests.get(url, headers=headers)
			with open(first_64kb, 'wb') as f:
				for chunk in r.iter_content(chunk_size=1024):
					if chunk: # filter out keep-alive new chunks
						f.write(chunk)

			if filesize > 0:
				headers = {"Range": 'bytes=%s-%s' % (filesize - self.__64k, filesize-1)}
			else:
				f.close()
				os.remove(first_64kb)
				return "SizeError", 0

			try:
				r = requests.get(url, headers=headers)
				with open(last_64kb, 'wb') as f:
					for chunk in r.iter_content(chunk_size=1024):
						if chunk:
							f.write(chunk)
			except:
				f.close()
				if os.path.exists(last_64kb):
					os.remove(last_64kb)
				if os.path.exists(first_64kb):
					os.remove(first_64kb)
				return 'IOError', 0
			f = open(first_64kb, 'rb')

		try:
			longlongformat = '<q'  # little-endian long long
			bytesize = struct.calcsize(longlongformat)

			if local_file:
				f = open(name, "rb")
				filesize = os.path.getsize(name)
			hash = filesize

			if filesize < self.__64k * 2:
				f.close()
				if local_file == False:
					os.remove(last_64kb)
					os.remove(first_64kb)
				return "SizeError", 0

			range_value = self.__64k / self.__byte_size
			range_value = round(range_value)

			for x in range(range_value):
				buffer = f.read(bytesize)
				(l_value,)= struct.unpack(longlongformat, buffer)
				hash += l_value
				hash = hash & 0xFFFFFFFFFFFFFFFF #to remain as 64bit number

			if local_file:
				f.seek(max(0,filesize - self.__64k),0)
			else:
				f.close()
				f = open(last_64kb, 'rb')
			for x in range(range_value):
				buffer = f.read(bytesize)
				(l_value,)= struct.unpack(longlongformat, buffer)
				hash += l_value
				hash = hash & 0xFFFFFFFFFFFFFFFF

			f.close()
			if local_file == False:
				os.remove(last_64kb)
				os.remove(first_64kb)
			returnedhash =  "%016x" % hash
			return returnedhash, filesize

		except(IOError):
			if local_file == False:
				os.remove(last_64kb)
				os.remove(first_64kb)
			return 'IOError', 0

```

- **Subtitles Scraping**: The available subtitles are scraped from OpenSubtitles using the `scrape_subtitles()` method, and they are filtered by language if the user specifies a language with the `--language` option.
```python
class OpenSubtitles(object):
 ...

    def scrape_subtitles(self, imdb_id, hash_value=None, lang=None):

        self.search_url = self.search_url.format(lang=lang, imdb_id=imdb_id)
        if hash_value:
            self.search_url += f'/hash-{hash_value}'
            response = requests.get(self.search_url)
            soup = BeautifulSoup(response.content, 'html.parser')

            subtitles = []
        for item in soup.select('.bnone'):
            title = item.text.strip()
            href = item['href']
            subtitles.append({'title': title, 'link': href})

        return subtitles

 ...
```

- **Download Subtitle**: The function `download_subtitle()` downloads the given subtitle file from OpenSubtitles and saves it locally. It constructs the download URL using the `subtitle_id`, creates the output directory if it doesn't exist, and streams the subtitle file in chunks to save memory. The file is saved as a ZIP under the name `subtitle-{movie_id}.zip`.
```python
class OpenSubtitles(object):
    ...

    def download_subtitle(self, movie_id, subtitle_id, output_path):
        download_link = self.download_url.format(sub_id=subtitle_id)
        subtitle_filename = os.path.join(output_path, f"subtitle-{movie_id}.zip")

        with requests.get(download_link, stream=True) as r:
            r.raise_for_status()
            if not os.path.exists(output_path):
                os.mkdir(output_path)

            with open(subtitle_filename.strip(), 'wb') as f:
                for chunk in r.iter_content(chunk_size=8192):
                    f.write(chunk)

            print(f"Downloaded: {subtitle_filename}")

    ...
```

- **Batch Mode**: If batch mode is enabled with the `--batch-download` flag, the program automatically downloads subtitles for all movies in the specified directory. Without batch mode, the user is presented with a list of available subtitles and prompted to choose one to download.

### Connecting the dots

As we have all the required tasks as blocks separately, we are supposed to put it all together and make it a functional application, this is done in `run.py`. First, we are supposed to initialize the `OpenSubtitles` and `HashAlgorithm` from the `utils.py` file. After this, we are supposed to extract the IMDb ID from the file name which is the movie name.

`run.py`
```python
def cli(file_path, language, output, file_size, match_by_hash, batch_download):
    mp4_file = file_path

    open_sub = utils.OpenSubtitles()
    hash_algo = utils.HashAlgorithm()

    try:
        imdb_name, imdb_id = open_sub.imdb_id(mp4_file.split('/')[-1].split('.')[0])
    except Exception as ex:
        print("Invalid file name")
        sys.exit(-1)

    if not imdb_id:
        click.echo("IMDb ID not found in the filename.")
        return
```
Now we are supposed to scrape the subtitles with the IMDb ID, file hash (if hash mode is enabled hash will be generated from `HashAlgorithm`'s `hash_size_File_url` function) and language, this is handled by `OpenSubtitles`'s `scrape_subtitles` function. The scraped subtitles will list the available subtitles for users to pick.

```python
def cli(file_path, language, output, file_size, match_by_hash, batch_download):

    ...

    file_hash, _ = hash_algo.hash_size_File_url(mp4_file) if match_by_hash else None
    subtitles = open_sub.scrape_subtitles(imdb_id, file_hash, language)

    if not subtitles:
        click.echo("No subtitles found.")
        return

    ...
```
Next, if batch download is enabled we are supposed to download all the files, else we should download the user's selected subtitle.
```python
def cli(file_path, language, output, file_size, match_by_hash, batch_download):

    ...

    if not batch_download:
        click.echo("Available subtitles:")
        for i, sub in enumerate(subtitles, 1):
            click.echo(f"{i}: {sub['title']}")

        choice = click.prompt("Choose a subtitle to download", type=int)
        selected_sub = subtitles[choice - 1]

        subtitle_id = selected_sub['link'].split('/')[-2]
        open_sub.download_subtitle(imdb_name, subtitle_id, output)

    else:
        for i, sub in enumerate(subtitles, 1):
            subtitle_id = sub['link'].split('/')[-2]
            open_sub.download_subtitle(imdb_name, subtitle_id, os.path.join(output, f'{i}: {sub["title"]}'))

if __name__ == '__main__':
    cli()
```

### Usage method

**Without Batch Mode**:

```
python run.py -l eng  -o ./output --match-by-hash ./inputs/plan-9-from-outer-space.mpeg4la
```

**With Batch Mode**:

```
python run.py -l eng -b -o ./output --match-by-hash ./inputs/plan-9-from-outer-space.mpeg4la
```