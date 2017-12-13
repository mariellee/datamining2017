import pandas as pd
from urllib.request import urlopen
from bs4 import BeautifulSoup
import re
import threading
import time
import urllib

class Scraper(threading.Thread):
	def __init__(self, i_start, i_end, filename):
		super(Scraper, self).__init__()
		self.i_start = i_start
		self.i_end = i_end
		self.filename = filename

	def run(self):
		self.df = pd.DataFrame(columns=["imdb_id", 'rating', 'rating_count', 'review_count', 'critics_count'])
		try:
			self.scrape()
		finally:

			self.df.to_csv(self.filename + ".csv")

	def scrape(self):
		link_beginning = "http://www.imdb.com/title/"
		metaData = pd.read_csv("the-movies-dataset/movies_metadata.csv", error_bad_lines=False, index_col=False, dtype='unicode')
		imdb_ids = metaData.imdb_id

		for i in range(len(imdb_ids)):
			i += self.i_start
			if i >= self.i_end:
				raise RuntimeError("End reached")
			print(i)
			imdb_id = str(imdb_ids[i])
			if imdb_id == 0 or imdb_id == "" or imdb_id is None or imdb_id == "nan":
				self.df.loc[i] = ["", "", "", "", ""]
			else:
				link = link_beginning + imdb_id + '/'
				print(link)
				try:
					html = urlopen(link).read()
				except urllib.error.HTTPError:
					self.df.loc[i] = ["", "", "", "", ""]

				soup = BeautifulSoup(html, "html.parser")
				div = soup.findAll("div", {"class": "imdbRating"})

				try:
					rating = re.search(">(\d.\d)<", str(div)).group(1)
					rating_count = re.search('itemprop="ratingCount">(.*?)<', str(div)).group(1)
				except AttributeError:
					rating = ""
					rating_count = ""
				try:
					review_count = re.search('itemprop="reviewCount">(.*?) u', str(div)).group(1)
				except AttributeError:
					review_count = ""
				try:
					critics_count = re.search('itemprop="reviewCount">(.*?) c', str(div)).group(1)
				except AttributeError:
					critics_count = ""

				self.df.loc[i] = [imdb_id, rating, rating_count.replace(',', ''), review_count.replace(',', ''), critics_count.replace('.','')]


scraper1 = Scraper(0, 15000, "imdb_data")
scraper1.start()
time.sleep(1.5)
scraper2 = Scraper(15000, 30000, "idmb_data2")
scraper2.start()
time.sleep(1.5)
scraper3 = Scraper(30000, 50000, "imdb_data3")
scraper3.start()
"""
time.sleep(1.5)
scraper4 = Scraper(28000, 37000, "imdb_data4")
scraper4.start()
time.sleep(5)
scraper5 = Scraper(37000, 50000, "imdb_data5")
scraper5.start()
"""

