# find_a_doc

L'application pour le sécretariat du cabinet d'un petit nombre de médecins

## Démarrage

### Cloner le projet
```
git clone https://github.com/tomaszslabicki/find_a_doc
```

### Récupérer les dependances
```
flutter pub get
```

### Lancer l'application
```
flutter run
```

## Quelques explications
L'application permet de visualiser les rendez-vous pris chez chacun des docteurs.
Le premier écran est l'ecran d'acueil.
Sur la deuxième page nous pouvons choisir le médecin.
La troisième page nous permet de voir la liste de tous les rendez-vous pris pour le médecin en question.
La liste des rendez-vous est tout à fait scrollable.
Un click sur le ListTile permet d'afficher un SimpleDialog avec les détails du rendez-vous, le retour se fait par une petite flèche.

## Choix techniques
Nous avons choisi de créer simplement quelques fichiers, pas de structure REDUX, vu le nombre de fonctionalité.
La partie calandrier qui ne fonctionne pas pour l'instant a été commentée (fichier 'calandrier.dart')


A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
