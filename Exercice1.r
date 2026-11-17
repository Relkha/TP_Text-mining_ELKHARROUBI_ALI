library(tm)
library(wordcloud)

#Exercice 1

#1. Lecture et description
donnees <- read.csv("data/abcnews-date-text3.csv", stringsAsFactors = FALSE)
str(donnees)
dim(donnees)
head(donnees)
range(donnees$publish_date)
summary(nchar(donnees$headline_text))
table(substr(donnees$publish_date, 1, 4))

#Reponse Q1 : le fichier contient 1244184 depeches de l'ABC (Australie), du 19/02/2003 au 31/12/2021.
#Il y a 2 variables : publish_date (la date, AAAAMMJJ) et headline_text (le titre, deja en minuscules).
#Les titres sont courts (41 caracteres en moyenne) et il n'y a pas de titre vide.

#2. mars 2019, corpus et nettoyage
mois <- substr(donnees$publish_date, 1, 6)
dmois <- donnees[mois == "201903", ]
nrow(dmois)

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

mean(nbmotsavant)
var(nbmotsavant)
mean(nbmotsapres)
var(nbmotsapres)

dtm <- DocumentTermMatrix(clean)
print(dtm)
m <- as.matrix(dtm)
dim(m)

nbuniq <- rowSums(m > 0)
mean(nbuniq)
var(nbuniq)

#Reponse Q3 : le nettoyage enleve environ 1.5 mot par titre (surtout des stopwords). Les titres sont courts donc
#il y a presque pas de mots repetes dans un titre : 6.09 mots uniques pour 6.22 mots.
#(la matrice document-terme ignore les mots de moins de 3 lettres)

#4. Creux et grande dimension
zeros <- sum(m == 0)
total <- prod(dim(dtm))
spa <- (zeros/total) * 100
spa
ncol(m)
mean(nbuniq)

#Reponse Q4 : la matrice fait 3005 documents x 6476 mots. Chaque mot est une variable donc on est en grande
#dimension (beaucoup plus de variables que de documents). Mais un titre utilise seulement 6 mots sur 6476, tout
#le reste vaut 0 : 99.9% de zeros, la matrice est creuse. Le vocabulaire grandit avec le nombre de documents
#alors qu'un document reste court.

#5. Wordcloud
Frequences <- colSums(m)
Frequences <- sort(Frequences, decreasing=TRUE)
head(Frequences, 20)

words <- names(Frequences)
wordcloud(words[1:100],
          Frequences[1:100],
          max.words = 100,
          random.order = FALSE)

#Reponse Q5 : mots les plus frequents : nsw, election, says, christchurch, new, police. On retrouve l'actualite
#de mars 2019 (elections en Nouvelle-Galles du Sud, attentat de Christchurch, brexit).