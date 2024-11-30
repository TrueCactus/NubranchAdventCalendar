
# Calendrier de l'Avent Interactif

Une application Shiny interactive qui simule un calendrier de l'Avent numérique. Les utilisateurs peuvent ouvrir des cases jour après jour pour découvrir des surprises sous forme de textes et d'images.

## Shiny Assistant

Cette application a été réalisée avec **Shiny Assistant** de Posit. L'objectif était d'explorer l'outil et de comprendre ses capacités. Il permet de créer facilement de petites applications Shiny en offrant une interface simple et intuitive.

### Les points positifs :
- **Visualisation en temps réel** : L'application se construit sous vos yeux, ce qui permet de voir immédiatement le résultat de vos modifications.
- **Simplicité d'utilisation** : Idéale pour les projets rapides ou les prototypes.

### Les points à améliorer :
- **Fourniture excessive de CSS** : J'ai eu l'impression que l'outil génère davantage de code CSS par défaut, plutôt que d'exploiter les fonctions ou les bibliothèques natives de Shiny, ce qui peut parfois limiter la personnalisation ou la flexibilité de l'application.

## 🎄 Caractéristiques

- Interface utilisateur intuitive avec design festif de Noël
- Cases sous forme de cadeaux avec rubans décoratifs
- Animation des cases au survol
- Affichage modal pour le contenu de chaque jour
- Responsive design (s'adapte aux mobiles et tablettes)
- Système de gestion des dates pour déverrouiller les cases progressivement

## 📋 Prérequis

Pour faire fonctionner l'application, vous aurez besoin de :

- R (version recommandée : ≥ 4.0.0)
- Les packages R suivants :
  - shiny
  - bslib
  - lubridate

## 📁 Structure des fichiers

```
calendrier-avent/
├── app.R              # Application principale
├── adventCaseText.R   # Fichier contenant les textes pour chaque jour
├── ADVENTCASEIMG/     # Dossier contenant les images
│   ├── case1.jpg
│   ├── case2.jpg
│   └── ...
└── README.md
```

## 🚀 Installation et démarrage

1. Clonez ce dépôt ou téléchargez les fichiers.
2. Assurez-vous que tous les packages requis sont installés :
   ```r
   install.packages(c("shiny", "bslib", "lubridate"))
   ```
3. Placez vos images dans le dossier `ADVENTCASEIMG/`.
4. Modifiez le fichier `adventCaseText.R` avec vos textes personnalisés.
5. Lancez l'application :
   ```r
   shiny::runApp("chemin/vers/calendrier-avent")
   ```

## 📝 Personnalisation

### Images
Les images doivent être nommées selon le format : `caseX.jpg` ou `caseX_Y.jpg`.
- X = numéro du jour (1-24)
- Y = numéro de l'image si plusieurs images pour un même jour

Formats supportés : jpg, jpeg, png, webp.

### Textes
Modifiez le fichier `adventCaseText.R` en suivant le format :

```r
case1 <- "Texte pour le jour 1"
case2 <- "Texte pour le jour 2"
# etc...
```

## 🎮 Utilisation

- **En production** : les cases se déverrouillent automatiquement selon la date réelle.
- **En test** : utilisez le sélecteur de jour en haut de l'application pour simuler différentes dates.
- Cliquez sur une case déverrouillée pour voir son contenu.
- Les cases verrouillées apparaissent grisées et ne peuvent pas être ouvertes.

## 🛠 Fonctionnalités techniques

- Design responsive avec Bootstrap.
- Animation CSS personnalisée pour les cases.
- Gestion dynamique du contenu modal.
- Mélange aléatoire des positions des cases.
- Système de cache pour optimiser le chargement des images.

## 📱 Compatibilité

- Fonctionne sur tous les navigateurs modernes.
- Interface adaptative pour desktop, tablette et mobile.
- Optimisé pour différentes tailles d'écran.

## 🌊🐚 Nudibranches

Ce Calendrier de l'Avent est aussi l'occasion de découvrir les **nudibranches**, des invertébrés marins que j'affectionne énormément. Ce sont des mollusques d'une grande diversité, que ce soit par leurs couleurs, leurs formes ou leurs caractéristiques !

## 🤝 Remerciements

Merci Shiny Assistant et Chat GPT. 😜
