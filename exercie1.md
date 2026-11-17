# Exercice 1 - Description d'un corpus

## 1. Contenu du fichier

Le fichier contient 1 244 184 dépêches de l'ABC (un média australien) et 2 colonnes :

- `publish_date` : la date de publication, écrite sous la forme AAAAMMJJ (par exemple 20030219)
- `headline_text` : le titre de la dépêche, déjà en minuscules

Les dépêches vont du 19 février 2003 au 31 décembre 2021. Il n'y a pas de titre vide. Un titre est court : 41 caractères en moyenne, entre 3 et 70. Le nombre de dépêches par année change pas mal, de 91 928 en 2013 à 17 926 en 2021.

## 2. Corpus d'un mois

J'ai pris mars 2019, ce qui fait 3 005 dépêches. Pour les sélectionner j'ai gardé les 6 premiers chiffres de la date (AAAAMM), puis j'ai créé le corpus avec `VCorpus(VectorSource(...))`.

Pour nettoyer, j'ai enlevé la ponctuation, mis en minuscules, enlevé les chiffres et enlevé les stopwords anglais. Par exemple le titre "abc news quiz march 1" devient "abc news quiz march".

## 3. Nombre de mots par document

| | Moyenne | Variance |
|---|---|---|
| Mots par document avant nettoyage | 7,75 | 3,86 |
| Mots par document après nettoyage | 6,22 | 2,71 |
| Mots uniques par document après nettoyage | 6,09 | 2,61 |

Le nettoyage enlève environ 1,5 mot par titre (les stopwords surtout). Les titres étant courts, il y a presque pas de mots répétés dans un même titre, donc le nombre de mots uniques (6,09) est très proche du nombre de mots (6,22). Pour les mots uniques j'ai utilisé la matrice document-terme, qui ignore les mots de moins de 3 lettres.

## 4. Données creuses et de grande dimension

Ici la matrice document-terme fait 3 005 lignes (les documents) et 6 476 colonnes (les mots différents). Chaque mot est une variable, donc on est en grande dimension : il y a plus de variables que de documents.

Mais un titre contient seulement 6 mots en moyenne, donc il utilise 6 colonnes sur 6 476. Tout le reste vaut 0. Au total il y a 99,9 % de zéros dans la matrice, donc elle est creuse. C'est normal : le vocabulaire grandit avec le nombre de documents, alors qu'un document reste petit. Ça pose problème pour les algorithmes (distances peu informatives, beaucoup de mémoire pour rien).

## 5. Nuage de mots

Le nuage de mots est fait avec les 100 mots les plus fréquents (voir le code R). Les plus fréquents sont `nsw` (93), `election` (82), `says` (76), `christchurch` (75), `new` (74) et `police` (74). On retrouve les gros sujets de mars 2019 : les élections en Nouvelle-Galles du Sud, l'attentat de Christchurch, le Brexit, des cyclones, Trump. Les mots comme `says` ou `new` sont très fréquents mais disent pas grand-chose, c'est typique des titres de presse.