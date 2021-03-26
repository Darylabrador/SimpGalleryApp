# Client mobile

La conception et le développement de ce projet s'est effectué dans le cadre de la formation de Simplon. Celui-ci s'est effectué en groupe de 4 :

- Daryl ABRADOR
- Abel BARET
- Fredy INCHATI DAOU
- Loganarden NAMINZO

## Objectif

Le but est la création et le partage d'album photo sur invitation sécurisé envoyé par mail (ou par notification pour des utilisateurs ayant déjà un compte).

## Technologie

On utilise ici la technologie suivante :

- Flutter

## Initialisation du projet

Une fois que que le SDK est installé, cette ligne de commande permettra de s'assurrer que les dépendances nécessaires au bon fonctionnement de l'application sont bien installés

- flutter pub get

Après avoir fait un git clone de ce projet, vous devez effectué l'action suivante afin d'avoir l'application mobile en mode debug :

- flutter run

Dans un second terminal lancer la commande suivante pour tenir compte des changements pour chaque models :

- flutter pub run build_runner watch *(si besoin seulement)*

### V1

Dans la version actuelle il faut modifier le lien vers l'API laravel dans "lib/screens/auth/registration.dart" pour pouvoir faire le test de l'inscription

## Liens utiles

- [Application mobile flutter]("https://github.com/Darylabrador/SimpGalleryApp")
- [Conception du projet]("https://github.com/Darylabrador/SimpGalleryApp/tree/ressource")
- [Backend]("https://github.com/Darylabrador/SimpGalleryApp/tree/server")
