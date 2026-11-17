#Exercice 2

donnees <- read.csv("data/spamDataNum.csv")
str(donnees)

classe <- donnees$CSpam
n <- nrow(donnees)
n1 <- sum(classe == 1)
n2 <- sum(classe == 0)

#1. Importance de chaque variable X1,...,X57
imp <- c()
for (j in 1:57){
  x <- donnees[, j]
  m <- mean(x)
  m1 <- mean(x[classe == 1])
  m2 <- mean(x[classe == 0])
  v <- mean((x - m)^2)
  vint <- (1 / n) * (n1 * (m1 - m)^2 + n2 * (m2 - m)^2)
  imp[j] <- vint / v
}
names(imp) <- names(donnees)[1:57]
round(imp, 3)

barplot(imp, las = 2, cex.names = 0.6, main = "Importance des variables")

#2. Variables les plus importantes
tri <- sort(imp, decreasing = TRUE)
round(head(tri, 10), 3)
barplot(head(tri, 10), main = "10 variables les plus importantes")

noms <- names(head(tri, 10))
spam <- round(colMeans(donnees[classe == 1, noms]), 2)
nonspam <- round(colMeans(donnees[classe == 0, noms]), 2)
rbind(spam, nonspam)

#Reponse Q2 : les variables les plus importantes sont X21 (0.147), X23 (0.112), X7 (0.110), X53 (0.105),
#X19 (0.075), X16 et X17 (0.069), X25 (0.066), X57 (0.062), et X5 et X52 a egalite (0.059).
#L'importance, c'est la part de la variance de la variable qui s'explique par la classe. Plus elle est grande,
#plus la moyenne de la variable change entre spam et non spam.
#Le tableau des moyennes (spam contre non spam) montre que presque toutes ces variables sont plus frequentes dans les spams :
#- X23 ("000") : 0.25 contre 0.01 et X53 ("$") : 0.17 contre 0.01, ca fait penser a des sommes d'argent
#- X52 ("!") : 0.51 contre 0.11
#- X57 (nombre de lettres majuscules) : 471 contre 161, un spam a environ 3 fois plus de majuscules
#- X21 : 1.38 contre 0.44, X7 : 0.28 contre 0.01, X19 : 2.26 contre 1.27, X16 : 0.52 contre 0.07,
#  X17 : 0.29 contre 0.05 et X5 : 0.51 contre 0.18. L'enonce ne dit pas quels mots c'est, on voit juste qu'ils sont
#  plus frequents dans les spams, surtout X7 (28 fois plus) et X16 (7 fois plus).
#Pour X23, X53, X52 et X57 les explications (argent, ton qui insiste) sont des hypotheses, les donnees ne donnent que des frequences.
#X25 c'est l'inverse : 0.90 dans les non spams contre 0.02 dans les spams. Cette variable est un signe de non spam,
#peut-etre un biais des donnees (les mails normaux viennent peut-etre d'un seul endroit ou d'une seule personne).
#Aucune variable n'est vraiment tres importante (max 0.147), donc une seule variable ne suffit pas pour separer spam et non spam.