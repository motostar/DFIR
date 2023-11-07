import mmh3
import requests
import os
import sys
import codecs
import time
import xlsxwriter
import urllib.parse as urlparse
from shodan import Shodan

#set initial row for writing data
row = 1

#initialize shodan api session
api = Shodan('rX7ew1bQ7R5j7MdhCHklFYgEK8jXwHul')

#list of urls to search
urls = ['https://www.bankofamerica.com/favicon.ico', 'https://www.pfizer.com/sites/default/files/custom-favicon/favicon.ico.png']


#writes headers in xlsx workbook
def writeHeaders(workbook):
	worksheet = workbook.add_worksheet("Results")
	worksheet.write(0, 0, "Source Domain")
	worksheet.write(0, 1, "IP Address")
	worksheet.write(0, 2, "Port")
	worksheet.write(0, 3, "HTTP")
	worksheet.write(0, 4, "Domains")
	worksheet.write(0, 5, "Hostnames")
	worksheet.write(0, 6, "Organization")
	worksheet.write(0, 7, "Location")


	return workbook

#writes data to xlsx workbook
def writeData(workbook, results, base_url):
	worksheet = workbook.get_worksheet_by_name("Results")
	global row
	for result in results:
		worksheet.write(row, 0, base_url)
		worksheet.write(row, 1, result['ip_str'])
		worksheet.write(row, 2, result['port'])
		worksheet.write(row, 3, result['data'].split('\n')[0][:-1])
		worksheet.write(row, 4, ', '.join(result['domains']))
		worksheet.write(row, 5, ', '.join(result['hostnames']))
		worksheet.write(row, 6, result['org'])
		worksheet.write(row, 7, result['location']['city'] + ", " + result['location']['country_name'])

		row += 1
	worksheet.autofilter("A1:H" + str(row))
	return workbook

#creates a filename with current time
timestr = time.strftime("%Y%m%d-%H%M%S")
fileName = "ShodanResults-{}.xlsx".format(timestr)
workbook = xlsxwriter.Workbook(
	fileName
)

#write headers
workbook = writeHeaders(workbook)

#goes through each url in list
for url in urls:

	#gets hash of favicon
	response = requests.get(url)
	favicon = codecs.encode(response.content,"base64")
	hash = mmh3.hash(favicon)

	try:	
		# Search Shodan
		results = api.search('http.favicon.hash:{}'.format(hash))
		base_url = urlparse.urlparse(url).hostname

		# Shows the number of results
		print('Results found for {}: {}'.format(base_url, results['total']))

		#writes data to xlsx workbook
		workbook = writeData(workbook, results['matches'], base_url)

	#if anything fails
	except Exception as e:
		exc_type, exc_obj, exc_tb = sys.exc_info()
		fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
		print(exc_type, fname, exc_tb.tb_lineno)
workbook.close()
