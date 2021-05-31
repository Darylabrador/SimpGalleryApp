<?php

namespace App\Http\Controllers;

use App\Http\Resources\AccessResource;
use App\Http\Resources\UserResource;
use App\Mail\InvitationMail;
use App\Models\Album;
use App\Models\Invitation;
use App\Models\Notification;
use App\Models\User;
use App\Models\Access;
use App\Http\Resources\AlbumResource;
use App\Mail\CreationCompteMail;
use App\Models\Comment;
use App\Models\Photo;
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
        return AlbumResource::collection($albums);
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

        $accesses   = Access::orderBy('accesses.id', 'desc')
        ->join('albums', 'albums.id', '=', 'accesses.album_id')
        ->where('accesses.user_id', $userId)
        ->where("accesses.isAuthorize", 1)
        ->where("albums.shareToken", "!=", null)
        ->where("albums.share_at", "!=", null)
        ->select('accesses.*')
        ->get();

        return AccessResource::collection($accesses);
    }


    /**
     * get trashed pics
     *
     * @return \Illuminate\Http\Response
     */
    public function getTrash() {
        $albums = Album::onlyTrashed()->all();
        return AlbumResource::collection($albums);
    }


    /*
    |--------------------------------------------------------------------------
    | Autocomplete mail to invite people
    |--------------------------------------------------------------------------
    */

    /**
     * Auto complete
     *
     * @return \Illuminate\Http\Response
     */
    public function autocomplete($value)
    {
        $listMail = User::where("email", "LIKE", "%" . $value . "%")->get();
        return UserResource::collection($listMail);
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
    public function create(Request $request)
    {
        $validator = Validator::make(
            $request->all(),
            [
                'label' => 'required',
                'cover' => 'required|file|mimes:jpg,jpeg,png',
            ],
            [
                'file'  => 'Image non fournis',
                'mimes' => 'Extension invalide',
            ]
        );

        $errors = $validator->errors();
        if (count($errors) != 0) {
            return response()->json([
                'success' => false,
                'message' => $errors->first()
            ]);
        }

        if ($request->hasFile("cover")) {
            $cover          = $validator->validated()['cover'];
            $extension      = $cover->getClientOriginalExtension();
            $image          = time() . rand() . '.' . $extension;
            $cover->move(public_path('img/cover'), $image);
            $album          = new Album;
            $album->cover   = $image;
            $album->label   = $validator->validated()['label'];
            $album->user_id = Auth::id();
            $album->save();

            return response()->json([
                'success' => true,
                'message' => "Album créé"
            ]);
        }
    }


    /**
     * Edit cover
     * @return \Illuminate\Http\Response
     */
    public function editCover(Request $request)
    {
        $validator = Validator::make(
            $request->all(),
            [
                'albumId' => "required",
                'cover'   => 'required|image|mimes:jpg,jpeg,png',
            ],
            [
                'image'  => 'Image non fournis',
                'mimes' => 'Extension invalide',
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
                $oldFilePath = public_path('img') . '/' . $oldImage;
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
    public function share(Request $request)
    {
        $validator = Validator::make(
            $request->all(),
            [
                'albumId' => 'required',
                'target'  => 'required',
                'message' => 'nullable',
                // 'type'    => 'required'
            ],
            [
                'required' => 'Le champ :attribute est requis',
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
        $target  = $validator->validated()['target'];
        $message = $validator->validated()['message'];
        // $type    = $validator->validated()['type'];

        $user = Auth::user();

        if($user->identifiant == $target) {
            return response()->json([
                'success' => false,
                'message' => "L'album vous appartient"
            ]);
        }

        $user         = Auth::user();
        $userIdentity = $user->pseudo;

        if ($message != null) {
            $sendingMessage = $message;
        } else {
            $sendingMessage = "{$userIdentity} vous a invité à rejoindre un de ses albums !";
        }

        $album = Album::where(['id' => $albumId, 'user_id' => $user->id])->first();

        if (!$album) {
            return response()->json([
                'success' => false,
                'message' => "Album inexistant"
            ]);
        }

        if ($album->shareToken == null) {
            $shareToken        = Str::random(20);
            $album->shareToken = $shareToken . $album->id;
            $album->share_at   = now();
            $album->save();
        }

        $userExist       = User::where(['identifiant' => $target])->first();
        $invitationExist = Invitation::where(['album_id' => $albumId, 'target' => $target])->first();

        if (!$invitationExist) {
            if ($userExist) {
                $userAccess = Access::where(['user_id' => $userExist->id, 'album_id' => $albumId])->first();

                if(!$userAccess) {
                    Mail::to($target)->send(new InvitationMail($userExist->pseudo, $sendingMessage, $album->shareToken));
                } else {
                    $userAccess->isAuthorize = 1;
                    $userAccess->save();
                }
            } else {
                $invitation = new Invitation();
                $invitation->target   = $target;
                $invitation->album_id = $albumId;
                $invitation->save();

                Mail::to($target)->send(new CreationCompteMail($sendingMessage, $album->shareToken));
            }

            return response()->json([
                'success' => true,
                'message' => "Invitation envoyée !"
            ]);
        } else {
            return response()->json([
                'success' => false,
                'message' => "Invitation déjà envoyée !"
            ]);
        }




        // if ($userExist) {
        //     $accessAlbumExist = Access::where(['album_id' => $albumId, 'user_id' => $userExist->id])->first();
        //     if (!$accessAlbumExist) {
        //         $accessAlbum = new Access();
        //         $accessAlbum->user_id  = $userExist->id;
        //         $accessAlbum->album_id = $album->id;
        //         $accessAlbum->save();
        //         // $notif = new Notification();
        //         // $notif->label   = "{$userIdentity} vous a invité à rejoindre son album photo";
        //         // $notif->user_id = $userExist->id;
        //         // $notif->save();
        //         Mail::to($target)->send(new InvitationMail($target, $sendingMessage, $shareToken));
        //     }
        // } else {
        //     $invitation            = new Invitation();
        //     $invitation->target    = $target;
        //     $invitation->album_id  = $album->id;
        //     if ($type == 0) {
        //         Mail::to($target)->send(new InvitationMail($target, $sendingMessage, $shareToken));
        //     } else {
        //         // $basic  = new \Nexmo\Client\Credentials\Basic(env('NEXMO_ID', ''), env('NEXMO_PASSWORD', ''));
        //         // $client = new \Nexmo\Client($basic);
        //         // $message = $client->message()->send([
        //         //     // 'to' => '262692023484',
        //         //     'to' => $target,
        //         //     'from' => env('APP_NAME', ''),
        //         //     'text' => $sendingMessage . " " . "Ci-dessous votre clé : \n {$shareToken}"
        //         // ]);
        //         $invitation->isMobile = true;
        //     }
        //     $invitation->save();
        // }
    }


    /**
     * Permit our user to see.
     *
     * @return \Illuminate\Http\Response
     */
    public function join(Request $request)
    {
        $validator = Validator::make(
            $request->all(),
            [
                'shareToken' => 'required',
            ],
            [
                'required' => 'Le champ :attribute est requis',
            ]
        );

        $errors = $validator->errors();
        if (count($errors) != 0) {
            return response()->json([
                'success' => false,
                'message' => $errors->first()
            ]);
        }

        $userId = Auth::id();
        $shareToken = $validator->validated()['shareToken'];
        $album = Album::where(['shareToken' => $shareToken])->first();

        if (!$album) {
            return response()->json([
                'success' => false,
                'message' => "Clé invalide"
            ]);
        }

        if ($shareToken == $album->shareToken) {
            $access = Access::where(['album_id' => $album->id, "user_id" => $userId])->first();
            $access->isAuthorize = true;
            $access->save();

            return response()->json([
                'success' => true,
                'message' => "Vous avez rejoinds l'album"
            ]);
        }
    }


    /**
     * Leave a shared album
     *
     * @return \Illuminate\Http\Response
     */
    public function leave($albumId)
    {
        $userId = Auth::id();
        $accessToAlbum = Access::where(['album_id' => $albumId, 'user_id' => $userId]);
        if ($accessToAlbum) {
            $accessToAlbum->delete();
            return response()->json([
                'success' => true,
                'message' => "Vous avez quitté l'album"
            ]);
        }

        return response()->json([
            'success' => false,
            'message' => "Introuvable"
        ]);
    }


    /**
     * delete a shared album
     *
     * @return \Illuminate\Http\Response
     */
    public function deleteShare($id)
    {
        $accesses = Access::where(["album_id" => $id])->get();

        foreach ($accesses as $access) {
            $access->delete();
        }

        $album = Album::where(['id' => $id, "user_id" => Auth::id()])->first();

        if($album) {
            $album->share_at   = null;
            $album->shareToken = null;
            $album->save();
        }

        return response()->json([
            'success' => true,
            'message' => "L'album n'est plus partager"
        ]);
    }



    /**
     * Destroy an Album (softdelete)
     *
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $album = Album::where('id', $id)->first();

        foreach ($album->photos as $photo) {
            $photo->delete();
        }

        $album->delete();
        return response()->json([
            'success' => true,
            'message' => "Album supprimé"
        ]);
    }


    /**
     * Destroy an Album (hard delete)
     *
     * @return \Illuminate\Http\Response
     */
    public function confirmDelete($id) {
        $album  = Album::onlyTrashed()->where('id',$id)->first();
        $photos = Photo::onlyTrashed()->where('album_id', $album->id)->get();

        foreach ($photos as $photo) {
            $comments = Comment::onlyTrashed()->where('photo_id', $photo->id)->get();
            foreach ($comments as $comment) {
                $comment->forceDelete();
            }
            $photo->forceDelete();
        }
        $album->forceDelete();

        return response()->json([
            'success' => true,
            'message' => "Album supprimer"
        ]);
    }


    /**
     * Restore trash
     *
     * @return \Illuminate\Http\Response
     */
    public function restoreTrash($id) {
        $album  = Album::onlyTrashed()->where('id',$id)->first();
        $photos = Photo::onlyTrashed()->where('album_id', $album->id)->get();

        foreach ($photos as $photo) {
            $comments = Comment::onlyTrashed()->where('photo_id', $photo->id)->get();
            foreach ($comments as $comment) {
                $comment->restore();
            }
            $photo->restore();
        }
        $album->restore();

        return response()->json([
            'success' => true,
            'message' => "Album restaurer"
        ]);
    }
}
