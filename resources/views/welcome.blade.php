<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <title>SimpGalleryApp</title>

        <!-- Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700&display=swap" rel="stylesheet">
        <link href="{{asset ('css/app.css')}}" rel="stylesheet" />
        <link href="{{asset ('css/welcome.css')}}" rel="stylesheet" />
        <link href="{{asset ('css/style.css')}}" rel="stylesheet" />

    </head>
    <body>
        <div class="container col-md-8">
            <div class="row d-flex justify-content-between mt-2 col-md">
                <div class="col-4">
                    <h1>SimpGalleryApp</h1>
                </div>
                <div class="col-3">
                    <a href="{{asset ('apk/app-release.apk')}}"><input class="telecharger" type="button" value="Télecharger"></a>
                </div>
            </div>

            <div class="container row d1 my-5">
                <div class="col-md telephone">
                    <img src="images/image1.PNG" alt="SimpGalleryApp" >
                </div>
                <div class="col-md text text-center text-sm-left d-flex flex-column justify-content-center">
                    <h1>
                        Une application de partage photo !
                    </h1>
                    <p>
                        partager vos meilleurs moment avec vos amies grâce à l'application SimpGalleryApp,
                        Vous pourrais aimer, commenter leur plus belle photo !
                        Ne perdez plus de vue vos amies.
                    </p>
                </div>
            </div>

            

            <div class=" container D2 text-center">
                <h1 class="text-center">L'application en detail</h1>

                <div class="container row d1 my-5">
                    <div class="col-md telephone">
                        <img src="images/image2.PNG" alt="partage photo" class=" img-thumbnail">
                    </div>
                    <div class="col-md text text-center text-sm-center d-flex flex-column justify-content-center">
                        <p>
                            Avec SimpGalleryApp vous pouvez partager vos photos avec les amies que vous choisissez.
                        </p>
                    </div>
                </div>

                <div class="container row d1 my-5">
                    <div class="col-md text text-center text-sm-center d-flex flex-column justify-content-center">
                        <p>
                            Vous pouvez aussi donner votre avis sur leur photo. 
                        </p>
                    </div>
                    <div class="col-md telephone">
                        <img src="images/image3.PNG" alt="partage photo" class=" img-thumbnail">
                    </div>
                </div>

                <div class="container row d1 my-5">
                    <div class="col-md telephone">
                        <img src="images/image4.PNG" alt="partage photo" class=" img-thumbnail">
                    </div>
                    <div class="col-md text text-center text-sm-center d-flex flex-column justify-content-center">
                        <p>
                            Grâce à SimpGalleryApp vous pouvez créé autant d'album que vous voulez pour ne plus égarer vos photos.
                        </p>
                    </div>
                    
                </div>
            </div> </br>

            <div class="elem3">
                <div class=" container D3 p-3 d-flex justify-content-center ">
                    <a href="{{asset('apk/app-release.apk')}}"><input class="telecharge" type="button" value="Télecharger"></a>
                </div>
            </div>

        </div>


        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.min.js" integrity="sha384-+YQ4JLhjyBLPDQt//I+STsc9iw4uQqACwlvpslubQzn4u2UU2UFM80nGisd026JF" crossorigin="anonymous"></script>
   
    </body>
    <footer class="w-100  h-100 text-center bg-dark">
        <p>© SimpGalleryApp</p>
    </footer>
</html>
