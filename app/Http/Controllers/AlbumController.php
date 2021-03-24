<?php

namespace App\Http\Controllers;

use App\Models\Album;
use App\Models\Invitation;
use App\Models\Notification;
use App\Models\User;
use App\Models\Access;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;

class AlbumController extends Controller
{


    /*
    |--------------------------------------------------------------------------
    | Get infos
    |--------------------------------------------------------------------------
    */



    /**
     * User Album list
     *
     * @return \Illuminate\Http\Response
     */
    public function myAlbumList()
    {
        $loggedUser = Auth::user();
        $userId = $loggedUser->id;

        $albums = Album::where('user_id', $userId)->get();

        return AlbumRessources::collection($albums);
    }



    /**
     * User Album  limit to two Album
     *
     * @return \Illuminate\Http\Response
     */
    public function myAlbumLimit()
    {
        $loggedUser = Auth::user();
        $userId = $loggedUser->id;

        $albums = Album::where('user_id', $userId)->limit(2)->get();

        return AlbumRessources::collection($albums);
    }


    /**
     * Album share to user
     *
     * @return \Illuminate\Http\Response
     */
    public function shareAlbumList()
    {
        $loggedUser = Auth::user();
        $userId     = $loggedUser->id;
        $accesses     = Access::where('user_id', $userId)->get();
        $albumId    = [];
        foreach ($accesses as $key => $access) {
            # code...
        }
        $albums = Album::where('user_id', $userId)->get();

        return AlbumRessources::collection($albums);
    }


    /**
     * User Album  limit to two Album
     *
     * @return \Illuminate\Http\Response
     */
    public function myAlbumLimit()
    {
        $loggedUser = Auth::user();
        $userId = $loggedUser->id;

        $albums = Album::where('user_id', $userId)->limit(2)->get();

        return AlbumRessources::collection($albums);
    }

    
    /*
    |--------------------------------------------------------------------------
    | Actions
    |--------------------------------------------------------------------------
    */

    /**
     * Create an album
     * @return \Illuminate\Http\Response
     */
    public function create(Request $request){
        $validator = Validator::make(
            $request->all(),
            [   
                'label' => 'required',
                'cover' => 'required|file|mimes:jpg,jpeg,png|max:5000',
            ],
            [
                'file'  => 'Image non fournis',
                'mimes' => 'Extension invalide',
                'max'   => '5Mb maximum'
            ]
        );
        $errors = $validator->errors();
            if (count($errors) != 0) {
                return response()->json([
                    'success' => false,
                    'message' => $errors->first()
                ]);
            }

            $errors = $validator->errors();
            if (count($errors) != 0) {
                return response()->json([
                    'success' => false,
                    'message' => $errors->first()
                ]);
            }

            $cover          = $validator->validated()['cover'];
            $extension      = $cover->getClientOriginalExtension();
            $image          = time() . rand() . '.' . $extension;
            $cover->move(public_path('img/cover'), $image);
            $album          = new Album;
            $album->cover   = $image;
            $album->label   = $validator->validated()['label'];
            $album->save();

            return response()->json([
                'success' => true,
                'message' => "Album créé"
            ]);
    }


    /**
     * Edit cover
     * @return \Illuminate\Http\Response
     */
    public function editCover(Request $request) {
        $validator = Validator::make(
            $request->all(),
            [
                'albumId' => "required",
                'cover'   => 'required|file|mimes:jpg,jpeg,png|max:5000',
            ],
            [
                'file'  => 'Image non fournis',
                'mimes' => 'Extension invalide',
                'max'   => '5Mb maximum'
            ]
        );

        $errors = $validator->errors();
        if (count($errors) != 0) {
            return response()->json([
                'success' => false,
                'message' => $errors->first()
            ]);
        }

        $albumId    = $validator->validated()['albumId'];

        $album = Album::where(['id' => $albumId])->first();

        if ($request->hasFile('cover')) {
            $oldImage = $album->cover;

            if ($oldImage != null) {
                $oldFilePath = public_path('img/cover') . '/' . $oldImage;
                unlink($oldFilePath);
            }

            $cover          = $validator->validated()['cover'];
            $extension      = $cover->getClientOriginalExtension();
            $image          = time() . rand() . '.' . $extension;
            $cover->move(public_path('img/cover'), $image);
            $album->cover = $image;
        }

        $album->save();
        return response()->json([
            'success' => true,
            'message' => "Mise à jour effectuée"
        ]);
    }


    /**
     * Share album to users or futur users.
     *
     * @return \Illuminate\Http\Response
     */
    public function share(Request $request) {
        $validator = Validator::make(
            $request->all(),
            [
                'albumId' => 'required',
                'mails'   => 'required|array',
                'mails.*' => 'required|email',
                'message' => 'nullable',
            ],
            [
                'required' => 'Le champ :attribute est requis',
                'array'    => 'Format invalide',
                'email'    => 'Contenue invalide',
            ]
        );

        $errors = $validator->errors();
        if (count($errors) != 0) {
            return response()->json([
                'success' => false,
                'message' => $errors->first()
            ]);
        }

        $sendingMessage = "";
        $albumId = $validator->validated()['albumId'];
        $mails   = $validator->validated()['mails'];
        $message = $validator->validated()['message'];

        $user         = Auth::user();
        $userIdentity = $user->pseudo;

        if($message != null) {
            $sendingMessage = $message;
        } else {
            $sendingMessage = "{$userIdentity} vous a invité à rejoindre un de ses albums !";
        }

        $album = Album::where(['id' => $albumId, 'user_id' => $user->id])->first();

        if(!$album) {
            return response()->json([
                'success' => false,
                'message' => "Album inexistant"
            ]);
        }

        
        foreach ($mails as $mail) {
            $userExist = User::where(['email' => $mail])->first();
            if($userExist) {
                $accessAlbum = new Access();
                $accessAlbum->user_id  = $userExist->id;
                $accessAlbum->album_id = $album->id;
                $accessAlbum->save();

                $notif = new Notification();
                $notif->label   = "{$userIdentity} vous a invité à rejoindre son album photo";
                $notif->user_id = $userExist->id;
                $notif->save();
            } else {

            }
        }
    }
}