# urllib2 used so that we cane get a website.
import urllib2

# sys used for arguments
import sys

# BeautifulSoup used for xml / html parsing.
from BeautifulSoup import BeautifulSoup

# What's the URL?
quote_page = "https://launchpad.net/ubuntu/+ppas?name_filter=vlc"

# Let's read that motherfucker!
page = urllib2.urlopen(quote_page)

# Soup.  I don't even understand this.  Note to self -> begin to understand.
soup = BeautifulSoup(page)

# We're going to keep this list open for each line in the soup for-loop below.
list_of_tds = []

# Find each <tr> row that has the 'ppa_batch_row' class.
for row in soup.findAll('tr', attrs={'class': 'ppa_batch_row'}):
	list_of_tds.append(row.find('a'))

# This is a list of, well, slightly cleaned search results. It's used below.
list_of_slightly_cleaned_results = []

# This is the first page of available PPAs.
totally_clean_list_of_names = []

# Get the ppa name so that we can append it to the end of https://launchpad.net/ubuntu/+ppas?name_filter=
for item in list_of_tds:
	test = str(item)
	test2 = test.split('">')
	for item2 in test2:
		if "</a>" in item2:
			list_of_slightly_cleaned_results.append(item2)

# This will return the name of each PPA!
for slightly_cleaned_result in list_of_slightly_cleaned_results:
	stringed_version_of_the_slightly_cleaned_result = str(slightly_cleaned_result)
	cleaned_names_but_with_blanks = stringed_version_of_the_slightly_cleaned_result.split("</a>")
	for name in cleaned_names_but_with_blanks:
		if len(name) > 0:
			totally_clean_list_of_names.append(name)

# Create the counter for PPAs so that we can have a nice number to select.
ppa_counter = 0

# For each PPA in ppa_result, print it and then figure out how many spaces to add to it.
for ppa_result in totally_clean_list_of_names:
	ppa_counter += 1
	ppa_counter_string = str(ppa_counter)
	if ppa_counter < 10:
		print(ppa_counter_string + "   " + ppa_result)
	elif ppa_counter < 99:
		print(ppa_counter_string + "  " + ppa_result) 















## TO DO! ARGUMENTS! + clean up comments.  Also, how do I find the hrefs of each ppa name?
