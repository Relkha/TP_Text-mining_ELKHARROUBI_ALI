# Exercice 2 - Importance des variables

## Les données et la méthode

Le fichier `spamDataNum.csv` contient 4 601 mails : 1 813 spams (CSpam = 1) et 2 788 non spams (CSpam = 0). Il y a 57 variables X1,...,X57 (des fréquences de mots ou de caractères, et des infos sur les majuscules) et la classe CSpam.

Pour chaque variable X, je calcule les valeurs de l'annexe B :

- n, n1, n2 : le nombre de mails au total, de spams et de non spams
- m, m1, m2 : la moyenne de X au total, chez les spams et chez les non spams
- v : la variance de X (en divisant par n)
- vint = (1/n) * (n1 * (m1 - m)^2 + n2 * (m2 - m)^2)
- imp(X, CSpam) = vint / v

vint mesure à quel point les moyennes des deux classes s'écartent de la moyenne générale. Divisé par v, ça donne la part de la variance de X qui s'explique par la classe. C'est entre 0 et 1 : proche de 0 la variable change pas entre spam et non spam, proche de 1 elle les sépare bien. Dans R j'ai fait une boucle sur les 57 colonnes.

## 1. Valeurs de l'importance

Le graphique (barplot des 57 variables) est dans le code R. Les valeurs vont de presque 0 (par exemple X12) jusqu'à 0,147 (X21). Beaucoup de variables sont en dessous de 0,02.

## 2. Variables les plus importantes

| Variable | Importance | Moyenne chez les spams | Moyenne chez les non spams |
|---|---|---|---|
| X21 | 0,147 | 1,38 | 0,44 |
| X23 ("000") | 0,112 | 0,25 | 0,01 |
| X7 | 0,110 | 0,28 | 0,01 |
| X53 ("$") | 0,105 | 0,17 | 0,01 |
| X19 | 0,075 | 2,26 | 1,27 |
| X16 | 0,069 | 0,52 | 0,07 |
| X17 | 0,069 | 0,29 | 0,05 |
| X25 | 0,066 | 0,02 | 0,90 |
| X57 (nb de majuscules) | 0,062 | 471 | 161 |
| X5 | 0,059 | 0,51 | 0,18 |

X52 ("!") est à égalité avec X5 (0,059) : 0,51 chez les spams contre 0,11.

Explications :

- Presque toutes ces variables sont plus fréquentes dans les spams. Pour X23 ("000") et X53 ("$"), ça fait penser à des sommes d'argent, mais c'est une hypothèse.
- X57 : un spam a environ 3 fois plus de lettres majuscules qu'un non spam (471 contre 161).
- Pour X21, X7, X19, X16, X17 et X5, l'énoncé ne dit pas de quels mots il s'agit. On voit juste qu'ils sont plus fréquents dans les spams, surtout X7 (28 fois plus) et X16 (7 fois plus).
- X25 est l'inverse : 0,90 chez les non spams contre 0,02. Cette variable est un signe de non spam. Ça peut venir d'un biais des données (les mails normaux viennent peut-être d'un seul endroit), mais je peux pas le prouver avec ce qu'on a.
- Aucune variable n'est très importante (maximum 0,147), donc une seule variable ne suffit pas pour séparer spams et non spams.

## Pour l'oral

**Pourquoi on divise par la variance v ?**
Les variables n'ont pas la même échelle : une fréquence est petite (souvent moins de 1) alors que X57 peut valoir plusieurs centaines. En divisant par v, la mesure ne dépend plus de l'échelle, donc on peut comparer les variables entre elles.

**Pourquoi l'importance est entre 0 et 1 ?**
La variance totale de X se décompose en une partie expliquée par la classe (vint) et une partie à l'intérieur des classes. Donc vint est plus petit que v.

**Les limites de cette mesure ?**
Elle regarde chaque variable séparément, pas les combinaisons de variables. Elle compare seulement les moyennes : deux classes pourraient avoir des distributions différentes avec la même moyenne. Et une importance élevée ne veut pas dire que la variable cause le spam, juste qu'elle est liée à la classe.

**Que veut dire X21 (ou X7, X16...) ?**
L'énoncé ne le précise pas (il donne seulement X23, X24, X52, X53 et X55 à X57). Je n'ai que les fréquences, donc je ne peux pas dire de quel mot il s'agit.