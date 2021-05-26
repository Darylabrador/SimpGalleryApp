<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Invitation à créer un compte</title>
</head>
<body>
    <h4 style="text-align: center; width: 100%;">
        Bonjour
    </h4>

    <p>
        Nous sommes heureux de vous informer qu'une surprise vous attends !  <br>
        Mais avant tout, veuillez vous créer un compte afin de voir l'album partager et créer les votres !
    </p>

    <p>
        {{ $sendingMessage }} <br>
        Afin de pouvoir de confirmer votre entrer veuillez saisir cette clé dans les paramètres des albums : <br>
        {{ $shareToken }}
    </p>

    <p> 
        Cordialement, <br>
        L'équipe de SimpGalleryApp
    </p>
</body>
</html>