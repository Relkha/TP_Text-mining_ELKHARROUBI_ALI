# Exercice 5 — Classification bayésienne de documents (Python)

Script associé :
[Exercice5_classification_bayesienne.py](./Exercice5_classification_bayesienne.py)

## Objectif

À partir du vocabulaire et des fréquences de `classif.xlsx`, construire un
classifieur bayésien multinomial pour prédire l'une des cinq catégories
d'éducation.

## Données et exécution

Le classeur doit contenir une ligne par mot, une première colonne avec les
mots, puis cinq colonnes de fréquences. Le fichier fourni présente les
catégories :

- `Unqualified`;
- `LowEducationI`;
- `LowEducationII`;
- `HighEducationI`;
- `HighEducationII`.

La première cellule d'en-tête (colonne des mots) est vide dans le classeur;
`pandas` la lit donc comme une colonne sans nom. Le script traite toujours la
première colonne comme le vocabulaire et exige exactement cinq colonnes de
catégories.

Installation et lancement :

```bash
python3 -m pip install pandas openpyxl
python3 Exercice5_classification_bayesienne.py
```

Un chemin de classeur différent peut être fourni en argument :

```bash
python3 Exercice5_classification_bayesienne.py chemin/vers/classif.xlsx
```

## Probabilités et classifieur

### Probabilités a priori

L'énoncé suppose les classes équiprobables. Pour les cinq catégories :

\[
P(c)=\frac{1}{5}=0{,}2.
\]

### Probabilités conditionnelles

Le classeur contient les fréquences de mots par catégorie. Pour éviter qu'un
mot absent d'une catégorie donne une probabilité nulle, le script utilise un
lissage de Laplace avec \(\alpha=1\) :

\[
P(w\mid c)=
\frac{n_{w,c}+\alpha}{N_c+\alpha |V|},
\]

où \(n_{w,c}\) est la fréquence du mot \(w\) dans la catégorie \(c\), \(N_c\)
est le total des fréquences de cette catégorie et \(|V|\) la taille du
vocabulaire. Les premières probabilités conditionnelles calculées sont
affichées dans la console.

### Décision pour un document

Pour un document représenté par les comptes \(n(w,d)\), le classifieur choisit
la classe maximisant :

\[
\hat c=\arg\max_c\left[
\log P(c)+\sum_{w\in d} n(w,d)\log P(w\mid c)
\right].
\]

Le calcul en logarithmes évite les problèmes de sous-débordement liés au
produit de nombreuses petites probabilités. Les mots hors vocabulaire sont
ignorés; si aucun mot connu ne reste, le script signale une erreur.

## Cinq exemples

Le script crée cinq exemples synthétiques, un par catégorie. Pour chaque
catégorie, il choisit trois mots qui la distinguent le mieux des autres selon
les probabilités conditionnelles, puis affiche la classe prédite et les
scores.

Avec le classeur fourni, les cinq exemples générés sont classés dans leur
catégorie d'origine :

| Catégorie d'origine | Exemple généré | Prédiction |
|---|---|---|
| Unqualified | `finance unemployment money` | Unqualified |
| LowEducationI | `employment unemployment work` | LowEducationI |
| LowEducationII | `employment finance war` | LowEducationII |
| HighEducationI | `financial illness selfishness` | HighEducationI |
| HighEducationII | `economic situation financial` | HighEducationII |

Ces exemples sont construits à partir du même tableau que celui utilisé pour
calculer les probabilités; ils illustrent le calcul mais ne constituent pas
une évaluation indépendante de la performance sur de nouveaux documents.
