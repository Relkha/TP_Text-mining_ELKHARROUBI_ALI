library(tm)
library(wordcloud)

#Exercice 1

#1. Lecture et description
donnees <- read.csv("abcnews-date-text3.csv", stringsAsFactors = FALSE)
str(donnees) #1244184 depeches, 2 variables : publish_date (AAAAMMJJ) et headline_text (titre)
dim(donnees)
head(donnees)
range(donnees$publish_date) #du 19/02/2003 au 31/12/2021
summary(nchar(donnees$headline_text)) #titres de 3 a 70 caracteres, 41 en moyenne
table(substr(donnees$publish_date, 1, 4))

#2. Depeches d'un mois (mars 2019), corpus et nettoyage
mois <- substr(donnees$publish_date, 1, 6)
dmois <- donnees[mois == "201903", ]
nrow(dmois) #3005 depeches

Corpus_mois <- VCorpus(VectorSource(dmois$headline_text))

clean <- tm_map(Corpus_mois, removePunctuation)
clean <- tm_map(clean, content_transformer(tolower))
clean <- tm_map(clean, removeNumbers)
clean <- tm_map(clean, removeWords, stopwords("english"))

content(Corpus_mois[[1]])
content(clean[[1]])

#3. Mots par document avant et apres nettoyage, mots uniques apres nettoyage
nbmotsavant <- sapply(Corpus_mois, function(d) length(words(d)))
nbmotsapres <- sapply(clean, function(d) length(words(d)))

mean(nbmotsavant) #7.75
var(nbmotsavant) #3.86
mean(nbmotsapres) #6.22
var(nbmotsapres) #2.71

dtm <- DocumentTermMatrix(clean)
print(dtm)
m = as.matrix(dtm)
dim(m) #3005 x 6476

nbuniq <- rowSums(m > 0)
mean(nbuniq) #6.09
var(nbuniq) #2.61

#4. Creux et grande dimension
zeros <- sum(m == 0)
total <- prod(dim(dtm))
spa = (zeros/total) * 100
spa #99.9%
ncol(m) #6476 mots differents
mean(nbuniq) #un document utilise 6 mots sur 6476

#5. Wordcloud
Frequences <- colSums(m)
Frequences <- sort(Frequences, decreasing=TRUE)
head(Frequences, 20)

words <- names(Frequences)
wordcloud(words[1:100],
          Frequences[1:100],
          max.words = 100,
          random.order = FALSE)