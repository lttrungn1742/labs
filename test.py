from urllib.request import urlopen
from bs4 import BeautifulSoup

wiki = "file:///etc/passwd"

page = urlopen(wiki)
soup =  BeautifulSoup(page, "html.parser" ).encode('UTF-8')

print (soup)