# wtl::install_packages("wordcloud2")
library(wordcloud2)

wc = wordcloud2(demoFreq, size = 2)
str(wc)
htmlwidgets::saveWidget(wc, "wordcloud.html", selfcontained = TRUE)
