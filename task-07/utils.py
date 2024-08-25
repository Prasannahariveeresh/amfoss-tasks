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
			import requests

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

class OpenSubtitles(object):

	def __init__(self):
		self.search_url = 'https://www.opensubtitles.org/en/search/sublanguageid-{lang}/imdbid-{imdb_id}'
		self.download_url = 'https://www.opensubtitles.org/en/subtitleserve/sub/{sub_id}'

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