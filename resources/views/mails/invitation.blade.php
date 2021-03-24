<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Notification invitation</title>
</head>
<body>
    <h4 style="text-align: center; width: 100%;">
        Hey {{ $identity }} !
    </h4>
    
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