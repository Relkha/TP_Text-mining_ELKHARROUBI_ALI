# Exercice 4 - Clustering de documents (TF-IDF puis K-means)
# Les sacs de mots et les classes ci-dessous sont ceux du tableau du sujet  

documents <- paste0("d", 1:10)
terms <- c(
  "Virus", "Risk", "Natural", "Selection", "Energy", "Mouse",
  "Experiment", "Security", "Hacker", "Data", "Hardware", "Language",
  "Network", "Diplomacy", "Taxes", "Immigration", "Election"
)
counts <- matrix(
  0, nrow = length(terms), ncol = length(documents),
  dimnames = list(terms, documents)
)
entries <- data.frame(
  document = c(
    "d1", "d1", "d2", "d2", "d2", "d3", "d3", "d3",
    "d4", "d4", "d4", "d4", "d4", "d5", "d5", "d6", "d6", "d6",
    "d7", "d8", "d8", "d9", "d9", "d9", "d9", "d10", "d10"
  ),
  term = c(
    "Virus", "Risk", "Natural", "Selection", "Energy", "Mouse", "Virus",
    "Experiment", "Virus", "Risk", "Security", "Hacker", "Data", "Mouse",
    "Hardware", "Data", "Natural", "Language", "Network", "Diplomacy",
    "Taxes", "Risk", "Security", "Data", "Immigration", "Election", "Network"
  ),
  frequency = c(
    3, 2, 2, 2, 2, 1, 3, 2, 2, 2, 3, 2, 2, 2, 3, 3, 2, 2, 3, 2, 3,
    2, 3, 2, 3, 3, 1
  )
)
counts[cbind(match(entries$term, terms), match(entries$document, documents))] <-
  entries$frequency

classes <- c(
  d1 = "Science", d2 = "Science", d3 = "Science",
  d4 = "Computer", d5 = "Computer", d6 = "Computer", d7 = "Computer",
  d8 = "Politics", d9 = "Politics", d10 = "Politics"
)
descriptions <- apply(counts, 2, function(frequencies) {
  present <- frequencies > 0
  paste(
    paste0(terms[present], "(", frequencies[present], ")"),
    collapse = " "
  )
})
document_table <- data.frame(
  document = documents,
  description = unname(descriptions),
  classe = unname(classes[documents])
)
write.csv(document_table, "Résultats/exercice4_documents.csv", row.names = FALSE)
cat("Descriptions sauvegardées dans Résultats/exercice4_documents.csv\n")

# TF-IDF = fréquence brute * log(N / nombre de documents contenant le terme).
n_documents <- ncol(counts)
document_frequency <- rowSums(counts > 0)
idf <- log(n_documents / document_frequency)
tfidf <- t(sweep(counts, 1, idf, "*"))

cat("Poids TF-IDF (lignes = documents, colonnes = mots) :\n")
print(round(tfidf, 3))

set.seed(2026)
clustering <- kmeans(tfidf, centers = 3, nstart = 100)
comparison <- table(classe = classes[rownames(tfidf)], cluster = clustering$cluster)
purity <- sum(apply(comparison, 2, max)) / n_documents

cat("\nComparaison des clusters aux classes réelles :\n")
print(comparison)
cat(sprintf("\nPureté des clusters : %.1f%%\n", 100 * purity))
cat(
  "Les numéros de clusters sont arbitraires. La pureté associe chaque cluster ",
  "à sa classe majoritaire; elle vaut 100% si tous les documents de chaque ",
  "cluster partagent la même classe.\n"
)
 