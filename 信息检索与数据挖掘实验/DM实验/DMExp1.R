# from task1 to task6

## init
library("tm")
data("crude")

## load reuters dataset
reut21578 <- system.file("texts", "crude", package = "tm")
reuters <- VCorpus(DirSource(reut21578, mode = "binary"),readerControl = list(reader = readReut21578XMLasPlain))

## transform
reutersTrans <- tm_map(reuters, stripWhitespace)
reutersTrans <- tm_map(reutersTrans, content_transformer(tolower))
reutersTrans <- tm_map(reutersTrans, removeWords, stopwords("english"))
reutersTrans <- tm_map(reutersTrans, stemDocument)

## generate term-document matrix (task 2)
tdm <- TermDocumentMatrix(reuters)
tdmTrans <- TermDocumentMatrix(reutersTrans)

## generate term PDF (task 3)
tdmMat <- as.matrix(tdm)
freqs <- rowSums(tdmMat)
pdfVec <- freqs / sum(freqs)
jpeg(file="E:\\pdf.jpg")
barplot(pdfVec,xlab='words',ylab='probability',main='pdf', names.arg=names(pdfVec),col='blue')
dev.off()
tdmFrame <- data.frame(tdmMat)
write.csv(tdmFrame, file="E:\\wordDocument.csv")
sortedFreq <- sort(freqs, decreasing=TRUE)
print(sortedFreq[1])
print(sortedFreq[1] * 1)
print(sortedFreq[2])
print(sortedFreq[2] * 2)
print(sortedFreq[3])
print(sortedFreq[3] * 3)

## word cloud (task 4)
library("wordcloud")
jpeg(file="E:\\wordcloud.jpg")
wordcloud(names(freqs),freqs,scale=c(4,.5),min.freq=3,max.words=100,random.order=TRUE, random.color=FALSE, rot.per=.1,colors="black",ordered.colors=FALSE,use.r.layout=FALSE)
dev.off()

## tf matrix (task 5)
library(matlab)
tf <- as.matrix(tdm)
loc <- find(tf > 0)
tf[loc] = 1 + log(tf[loc], 10)
tfFrame <- data.frame(tf)
write.csv(tfFrame, file="E:\\tf.csv")

## tf-idf matrix (task 6)
tfidfMat <- as.matrix(tdm)
loc <- find(tfidfMat > 0)
tfidfMat[loc] <- 1
idf <- log(20 / rowSums(tfidfMat), 10)
tfidf <- tf * tfidfMat
tfidfFrame <- data.frame(tfidf)
write.csv(tfidfFrame, file="E:\\tf-idf.csv")

## transform reuters (task 7)
tdmTransMat <- as.matrix(tdmTrans)
tdmTransFrame <- data.frame(tdmTransMat)
write.csv(tdmTransFrame, file="E:\\wordDocumentTrans.csv")
print(sortedFreq[1:10])

## bool query (task 8)
result <- tdmTransMat['price',] * tdmTransMat['oil',]
print(find(result > 0))

## vector space query (task 9)
norm <- sqrt(colSums(tdmTransMat^2))
L2Mat <- t(t(tdmTransMat) / norm)
vsResult <- L2Mat['price',] * 1/sqrt(2) +  L2Mat['oil',] * 1/sqrt(2)
print(sort(vsResult, decreasing=TRUE))

## BIM model query (task 10)
dftPrice <- length(find(tdmTransMat['price',] > 0))
utPrice <- dftPrice / 20
ptPrice <- 1/3 + 1/2 * utPrice
ctPrice <- log(ptPrice / (1-ptPrice), 10) + log(1/utPrice, 10)

dftOil <- length(find(tdmTransMat['oil',] > 0))
utOil <- dftOil / 20
ptOil <- 1/3 + 1/2 * utOil
print(utOil)
print(ptOil)
ctOil <- log(ptOil / (1-ptOil), 10) + log(1/utOil, 10)

loc <- find(tdmTransMat > 0)
tdmTransMat[loc] <- 1
rsv <- tdmTransMat['price',] * ctPrice + tdmTransMat['oil', ] * ctOil
print(sort(rsv, decreasing=TRUE))