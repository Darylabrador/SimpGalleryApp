<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Notification inscription</title>
</head>
<body>
    <h4 style="text-align: center; width: 100%;">
        Bienvenue {{ $identity }}
    </h4>
    <p> 
        Nous sommes heureux de vous accueillir parmi nous !
    </p>

    <p>
        Avant de pouvoir vous connecter et voir les albums qui vous sont partager, il faut cliquer sur le lien ci-dessous afin de confirmer votre email ! <br>
        <a href="{{ $url }}"> {{ $url }} </a>
    </p>

    <p> 
        Cordialement, <br>
        L'équipe de SimpGalleryApp
    </p>
</body>
</html>