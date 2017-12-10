import pandas as pd
from urllib.request import urlopen
from bs4 import BeautifulSoup
import re
import time


link_beginning = "http://www.imdb.com/title/"
df = pd.read_csv("the-movies-dataset/movies_metadata.csv")

ratings = []
rating_counts = []
review_counts = []
critics_counts = []

for imdb_id in df.imdb_id:
	link = link_beginning + str(imdb_id)
	html = urlopen(link).read().decode("utf8")
	soup = BeautifulSoup(html)

	div = soup.findAll("div", {"class": "imdbRating"})
	print(div)

	rating = re.search(">(\d.\d)<", str(div)).group(1)
	rating_count = re.search('itemprop="ratingCount">(.*?)<', str(div)).group(1)
	review_count = re.search('itemprop="reviewCount">(\d+) u', str(div)).group(1)
	critics_count = re.search('itemprop="reviewCount">(\d+) c', str(div)).group(1)

	ratings.append(rating)
	rating_counts.append(rating_count)
	review_counts.append(review_count)
	critics_counts.append(critics_count)

	print(ratings)


df["rating"] = rating_counts
df["rating_count"] = rating_counts
df["review_count"] = review_counts
df["critic_count"] = critics_counts
df.to_csv("test.csv")


