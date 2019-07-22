# Libraries
library(RSelenium)
library(rvest)
library(XML)

# Selenium info
remDr = remoteDriver(remoteServerAddr = "localhost", port = 4444, browserName = "chrome")
remDr$open()

linkDF <- read.csv("patent_link.csv")
linkVec <- linkDF[["link"]]
dfNum <- 6
fileNum <- 1
patent_detailDF <- data.frame(matrix(rep(NA, dfNum), nrow=1))[numeric(0), ]
colnames(patent_detailDF) <- c("jglobalId", "title", "inventor", "inventeCompany", "description", "chemicals")

for(link in linkVec) {
	remDr$navigate(link)
	Sys.sleep(rnorm(1, 6, 2))
	planeHtmlList <- remDr$getPageSource()
	fileNmae <- paste(formatC(fileNum, width = 5, flag = 0), ".html", sep = "")
	write(unlist(planeHtmlList), fileNmae)

	path <- paste(getwd(), fileNmae, sep = "/")
	html <- read_html(path)
	parsed_doc <- htmlParse(html)
	jglobalId <- xpathSApply(doc = parsed_doc , path = "//*[@class='info_number']", xmlValue)
	title <- xpathSApply(doc = parsed_doc , path = "//*[@class='search_detail_topbox_title']", xmlValue)
	inventor <- xpathSApply(doc = parsed_doc , path = "//*[@class='js_tooltip_search'][1]/a", xmlValue)
	inventeCompany <- xpathSApply(doc = parsed_doc , path = "//*[@class='js_tooltip_search'][2]/a", xmlValue)
	description <- xpathSApply(doc = parsed_doc , path = "//*[@class='indent_1em'][1]", xmlValue)
	des_iter <- 2
	chemicals <- ""
	while(1 == 1){
		xpath <- paste("//*[@class='indent_1em'][", des_iter, "]", sep = "")
		nodeValue <- xpathSApply(doc = parsed_doc , path = xpath, xmlValue)
		if(length(nodeValue) == 0) break
		trimedTab <- gsub("\t", "", nodeValue)
		trimedLine <- gsub("\n", "", trimedTab)
		planeValue <- gsub(" ", "", trimedLine)
		chemicals <- paste(chemicals, planeValue)
		des_iter <- des_iter + 1
	}
	tempDF <- data.frame(jglobalId, title, inventor, inventeCompany, description, chemicals)
	patent_detailDF <- rbind(patent_detailDF, tempDF);
	fileNum <- fileNum + 1
}

write.csv(patent_detailDF, "patent_details.csv")


