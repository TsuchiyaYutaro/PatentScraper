# INPUT ###############################

target_year <- "2017"
target_word <- "農薬"

# Set a limit to pages scraped
max_page <- 3

#######################################

# Libraries
library(RSelenium)
library(rvest)
library(XML)

# Selenium info
remDr = remoteDriver(remoteServerAddr = "localhost", port = 4444, browserName = "chrome")
remDr$open()

iterater <- 1
patent_linkDF <- data.frame(matrix(rep(NA, 2), nrow=1))[numeric(0), ]
colnames(patent_linkDF) <- c("title", "link")

while(iterater <=  max_page){
	url <- paste('https://jglobal.jst.go.jp/search/patents#{"category":"3","keyword":"', target_word,'","page":', iterater, ',"order":"down AY","words":[{"groupId":"AY","displayVal":"', target_year,'","searchVal":"', target_year,'"}],"limit":20}', sep='')
	remDr$navigate(url)
	Sys.sleep(rnorm(1, 6, 2))
	planeHtmlList <- remDr$getPageSource()
	fileNmae <- paste(formatC(iterater, width = 5, flag = 0), ".html", sep = "")
	write(unlist(planeHtmlList), fileNmae)

	path <- paste(getwd(), fileNmae, sep = "/")
	html <- read_html(path)
	parsed_doc <- htmlParse(html)
	title <- xpathSApply(doc = parsed_doc , path = "//a[@href]", xmlValue)
	link <- xpathSApply(doc = parsed_doc , path = "//a[@href]", xmlGetAttr, "href")
	tempDF <- data.frame(title, link)
	patent_page_linkDF <- tempDF[-c(1,2, nrow(tempDF)), ]
	patent_linkDF <- rbind(patent_linkDF, patent_page_linkDF);
	iterater <- iterater + 1
}
 
write.csv(patent_linkDF, "patent_links.csv")


