"""Exercice 5 - Classifieur bayésien multinomial pour classif.xlsx.

Format attendu : une ligne par mot, une colonne de mot (première colonne),
puis une colonne de fréquences par catégorie (5 colonnes).
Dépendances : pandas et openpyxl.
"""

from collections import Counter
from pathlib import Path
import math
import re
import sys

try:
    import pandas as pd
except ModuleNotFoundError as exc:
    raise SystemExit(
        "Dépendance manquante : installez les paquets 'pandas' et 'openpyxl' avant d'exécuter ce script."
    ) from exc


base_dir = Path(__file__).resolve().parent
candidates = [
    Path(sys.argv[1]) if len(sys.argv) > 1 else None,
    base_dir / "data" / "classif.xlsx",
    Path.cwd() / "data" / "classif.xlsx",
    Path("/data/classif.xlsx"),
]
INPUT = next((candidate for candidate in candidates if candidate is not None and candidate.is_file()), None)
if INPUT is None:
    expected = "\n".join(str(candidate) for candidate in candidates if candidate is not None)
    raise SystemExit(f"Fichier introuvable. Vérifiez le chemin du fichier Excel. Chemins testés :\n{expected}")

table = pd.read_excel(INPUT)
if table.shape[1] < 3:
    raise SystemExit(
        "Le classeur doit contenir une colonne de mots et au moins deux colonnes de catégories."
    )

word_column = table.columns[0]
category_columns = list(table.columns[1:])
if len(category_columns) != 5:
    raise SystemExit(
        "Le classeur doit contenir exactement 5 colonnes de catégories après la colonne de mots."
    )
table = table.dropna(subset=[word_column]).copy()
table[word_column] = table[word_column].astype(str).str.strip().str.casefold()
table = table[table[word_column] != ""]
for category in category_columns:
    table[category] = pd.to_numeric(table[category], errors="raise").fillna(0)
    if (table[category] < 0).any():
        raise SystemExit(f"Les fréquences de {category} ne peuvent pas être négatives.")

table = table.groupby(word_column, as_index=True)[category_columns].sum()
vocabulary = list(table.index)
if not vocabulary or any(table[category].sum() <= 0 for category in category_columns):
    raise SystemExit("Chaque catégorie doit avoir au moins une fréquence de mot positive.")

# P(classe) = 1/5 selon l'hypothèse d'équiprobabilité.
class_prior = {category: 1 / len(category_columns) for category in category_columns}

# Lissage de Laplace : évite une probabilité nulle pour un mot non observé.
alpha = 1.0
conditional_probability: dict[str, dict[str, float]] = {}
for category in category_columns:
    total = float(table[category].sum())
    denominator = total + alpha * len(vocabulary)
    conditional_probability[category] = {
        word: (float(table.loc[word, category]) + alpha) / denominator
        for word in vocabulary
    }

print("A priori équiprobables :", class_prior)
print(f"Taille du vocabulaire : {len(vocabulary)}")
print("\nExemples de probabilités conditionnelles P(mot | catégorie) :")
print(
    pd.DataFrame(conditional_probability).head(10).round(5).to_string()
)
print(
    "Modèle : argmax_c [log P(c) + somme_w n(w,d) log P(w|c)], "
    "avec lissage de Laplace alpha=1."
)


def classify(document: str) -> tuple[str, dict[str, float]]:
    words = re.findall(r"[A-Za-zÀ-ÖØ-öø-ÿ']+", document.lower())
    counts = Counter(word for word in words if word in conditional_probability[category_columns[0]])
    if not counts:
        raise ValueError("Le document ne contient aucun mot connu du vocabulaire.")

    scores = {}
    for category in category_columns:
        score = math.log(class_prior[category])
        for word, frequency in counts.items():
            score += frequency * math.log(conditional_probability[category][word])
        scores[category] = score
    prediction = max(category_columns, key=lambda category: scores[category])
    return prediction, scores


# Cinq exemples synthétiques : les trois mots les plus fréquents de chaque classe.
for category in category_columns:
    other_categories = [name for name in category_columns if name != category]

    def contrast(word: str) -> float:
        own = math.log(conditional_probability[category][word])
        others = [
            math.log(conditional_probability[other][word])
            for other in other_categories
        ]
        return own - sum(others) / len(others)

    example_words = sorted(vocabulary, key=contrast, reverse=True)[:3]
    example = " ".join(example_words)
    predicted, scores = classify(example)
    print(f"\nExemple ({category}) : {example}")
    print(f"Classe prédite : {predicted}")
    print("Scores logarithmiques :", {key: round(value, 3) for key, value in scores.items()})

print(
    "\nPour un nouveau texte, tokenizez-le, comptez ses mots du vocabulaire, "
    "puis choisissez la catégorie de score maximal."
)
