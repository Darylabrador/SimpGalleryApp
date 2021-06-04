<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="{{ asset('css/bootstrap.min.css') }}">
    <link rel="stylesheet" href="{{ asset('css/font-awesome.min.css') }}">
    <link rel="stylesheet" href="{{ asset('css/owl.carousel.css') }}">
    <link rel="stylesheet" href="{{ asset('css/owl.theme.css') }}">
    <link rel="stylesheet" href="{{ asset('css/nivo-lightbox/nivo-lightbox.css') }}">
    <link rel="stylesheet" href="{{ asset('css/nivo-lightbox/nivo-lightbox-theme.css') }}">
    <link rel="stylesheet" href="{{ asset('css/animate.css') }}">
    <link rel="stylesheet" href="{{ asset('css/style.css') }}">
    <script src="js/modernizr.custom.js"></script>
    <title>SimpGalleryApp</title>
</head>

<body>

    <a href="#header" id="back-to-top" class="top"><i class="fa fa-chevron-up"></i></a>
    <section id="header" class="header">
        <div class="top-bar">
            <div class="container">
                <div class="navigation" id="navigation-scroll">
                        <div class="row">
                            <div class="col-md-11 col-xs-10">
                                <a href="index.html"><span id="logo">SimpGalleryApp</a>
                            </div>
                            <div class="col-md-1 col-xs-2">
                                <p class="nav-button">
                                    <button id="trigger-overlay" type="button">
           
                                    </button>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        <div class="container">
            <div class="starting">
                <div class="row">
                    <div class="col-md-6">
                        <img src="{{ asset('images/mobile_intro.png') }}" alt="LUCY" class="wow flipInY animated animated">
                    </div>
                    <div class="col-md-6">
                        <div class="banner-text">
                             <h2 class="animation-box wow bounceIn animated"><strong class="strong">Une application de  partage photo !</strong><br>
                            </h2>
                            <p>
                                Partagez vos meilleurs moment avec vos amies grâce à l'application SimpGalleryApp, Vous pourrais aimer, commenter leur plus belle photo ! Ne perdez plus de vue vos amies.                             </p>
                            <a href="{{ asset('apk/app-release.apk') }}" class="btn btn-download wow animated fadeInLeft">
                            <i class="fa fa-android pull-left"></i>
                            <strong>Télécharger</strong>
                            <br/>Maintenant </a> 
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <div class="overlay overlay-hugeinc">
        <button type="button" class="overlay-close">Close</button>
    </div>

    <script src="{{ asset('js/jquery-1.11.2.min.js') }}"></script>
    <script src="{{ asset('js/wow.min.js') }}"></script>
    <script src="{{ asset('js/owl-carousel.js') }}"></script>
    <script src="{{ asset('js/nivo-lightbox.min.js') }}"></script>
    <script src="{{ asset('js/smoothscroll.js') }}"></script>
    <script src="{{ asset('js/bootstrap.min.js') }}"></script>
    <script src="{{ asset('js/classie.js') }}"></script>
    <script src="{{ asset('js/script.js') }}"></script>
    <script>
        new WOW().init();
    </script>
    <script>
        $(document).ready(function(){
            $(".hideit").click(function(){
                $(".overlay").hide();
            });
            $("#trigger-overlay").click(function(){
                $(".overlay").show();
            });
        });
    </script>
    <script>
        $(document).ready(function(){

          var kawa = $('.top-bar');
          var back = $('#back-to-top');
          function scroll() {
             if ($(window).scrollTop() > 700) {
                kawa.addClass('fixed');
                back.addClass('show-top');

             } else {
                kawa.removeClass('fixed');
                back.removeClass('show-top');
             }
          }

          document.onscroll = scroll;
        });
    </script>
    <!--HHHHHHHHHHHH        Smooth Scrooling     HHHHHHHHHHHHHHHH-->
    <script>
        $(function() {
          $('a[href*=#]:not([href=#])').click(function() {
            if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
              var target = $(this.hash);
              target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
              if (target.length) {
                $('html,body').animate({
                  scrollTop: target.offset().top
                }, 1000);
                return false;
              }
            }
          });
        });
    </script>
</body>
</html>