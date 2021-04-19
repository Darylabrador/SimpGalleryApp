# Serveur de données

La conception et le développement de ce projet s'est effectué dans le cadre de la formation de Simplon. Celui-ci s'est effectué en groupe de 4 :

- Daryl ABRADOR
- Abel BARET
- Fredy INCHATI DAOU
- Loganarden NAMINZO

## Objectif

Le but est la création et le partage d'album photo sur invitation sécurisé envoyé par mail (ou par notification pour des utilisateurs ayant déjà un compte).

## Technologies

On utilise ici les technologies suivantes :

- Laravel v8 (API)
- Blade + Bootstrap + css (site vitrine)

## Initialisation du projet

Après avoir fait un git clone de ce projet, vous devez effectué les actions suivantes : 

- composer install
- npm install
- npm run dev
- php artisan passport:install --force

Pour lancer les seeders

- php artisan migrate:fresh --seed

## Contenu du .env

Vous devez éditer les informations suivantes dans votre .env :

Les valeurs des variables DB_ dépendent de votre environnement.

- APP_NAME=SimpGalleryApp
- APP_DEBUG=false
- DB_DATABASE=simpgalleryapp
- DB_USERNAME=root
- DB_PASSWORD=
- QUEUE_CONNECTION=database

Pour la suite, vous devez avoir un compte mailtrap (developpement) ou utiliser des informations d'un compte email réel (production) :

- MAIL_MAILER=smtp
- MAIL_HOST=smtp.mailtrap.io
- MAIL_PORT=2525
- MAIL_USERNAME=
- MAIL_PASSWORD=
- MAIL_ENCRYPTION=
- MAIL_FROM_ADDRESS=contact@simpgalleryapp.com

Pour le lancement des SMS :

- NEXMO_ID=
- NEXMO_PASSWORD=

## Lancement du projet 

En mode développment vous devez utiliser les commandes suivantes : 

- php artisan serve
- php artisan queue:work (lancement des tâches de fond - jobs)

En mode production la commande suivante doit être actif en permanence :

- php artisan queue:work

## Spécificité .env

Pour que le .env soit pris en compte sans avoir d'erreur, on utilise flutter_dotenv. Nous avons deux possibilités d'ignorer l'erreur "safety" :

- Dans android studio --> run > edit configurations > dans "additional run args" on rajoute "--no-sound-null-safety
- Depuis votre IDE    --> flutter run --no-sound-null-safety

## Liens utiles

- <a href="https://github.com/Darylabrador/SimpGalleryApp"> Application mobile flutter </a>
- <a href="https://github.com/Darylabrador/SimpGalleryApp/tree/ressource"> Conception du projet </a>
- <a href="https://github.com/Darylabrador/SimpGalleryApp/tree/server"> Backend </a>