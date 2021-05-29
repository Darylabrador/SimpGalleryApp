<?php

namespace App\Http\Controllers;

use App\Models\Access;
use App\Models\Album;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;

class AccessController extends Controller
{
    /**
     * Join album
     *
     * @return \Illuminate\Http\Response
     */
    public function checkAccess(Request $request)
    {
        $validator = Validator::make(
            $request->all(),
            [
                'jeton'          => 'required',
            ],
            [
                'required' => 'Le champ :attribute est requis',
            ]
        );

        $errors = $validator->errors();
        if (count($errors) != 0) {
            return response()->json([
                "success"  => false,
                "message"  => $errors->first(),
            ]);
        }

        $userId    = Auth::id();
        $jeton     = $validator->validated()['jeton'];
        
        $albumShare = Album::where(["shareToken" => $jeton])->where("share_at", "!=", null)->first();

        if ($albumShare) {
            $accessExist = Access::where(["album_id" => $albumShare, "user_id" => $userId])->first();

            if (!$accessExist) {
                $newAccess              = new Access();
                $newAccess->album_id    = $albumShare->id;
                $newAccess->user_id     = $userId;
                $newAccess->isAuthorize = 1;
                $newAccess->save();

                return response()->json([
                    "success" => true,
                    "message" => "Vous avez rejoinds l'album"
                ]);
            } else {
                return response()->json([
                    "success" => false,
                    "message" => "Vous avez déjà rejoinds l'album"
                ]);
            }
        } else {
            return response()->json([
                "success" => false,
                "message" => "Album non partager"
            ]);
        }
    }
    
    
    /**
     * Leave shared album
     *
     * @return \Illuminate\Http\Response
     */
    public function leaveAlbumShare($id) {
        $shareAccess = Access::where(["id" => $id])->first();

        if(!$shareAccess) {
            return response()->json([
                "success" => false,
                "message" => "Access inexistant"
            ]);
        }

        $shareAccess->delete();

        return response()->json([
            "success" => true,
            "message" => "Vous avez quitter l'album"
        ]);
    }
}
