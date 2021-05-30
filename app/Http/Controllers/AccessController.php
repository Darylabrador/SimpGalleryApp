<?php

namespace App\Http\Controllers;

use App\Http\Resources\AccessUserResource;
use App\Models\Access;
use App\Models\Album;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;

class AccessController extends Controller
{
    /**
     * Participant list
     *
     * @return \Illuminate\Http\Response
     */
    public function listParticipants($id) {
        $userId = Auth::id();
        
        $accesses   = Access::orderBy('accesses.id', 'desc')
        ->join('albums', 'albums.id', '=', 'accesses.album_id')
        ->where('accesses.album_id', $id)
        ->where('albums.user_id', $userId)
        ->where("accesses.isAuthorize", 1)
        ->where("albums.shareToken", "!=", null)
        ->where("albums.share_at", "!=", null)
        ->select('accesses.*')
        ->get();

        return AccessUserResource::collection($accesses);
    }


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
            $accessExist = Access::where(["album_id" => $albumShare->id, "user_id" => $userId])->first();

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
                $accessExist->isAuthorize = 1;
                $accessExist->save();

                return response()->json([
                    "success" => true,
                    "message" => "Vous avez rejoinds l'album"
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
     * Remove access for 1 or more user
     *
     * @return \Illuminate\Http\Response
     */
    public function deleteSingleParticipant(Request $request, $id) {
        $validator = Validator::make(
            $request->all(),
            [
                'userInfos'  => 'required',
                'userInfos.*'  => 'required',
            ],
            [
                'required'     => 'Le champ :attribute est requis',
            ]
        );

        $errors = $validator->errors();
        if (count($errors) != 0) {
            return response()->json([
                "success"  => false,
                "message"  => $errors->first(),
            ]);
        }

        $userInfos     = $validator->validated()['userInfos'];
        
        foreach ($userInfos as $userId) {
            $userAccess = Access::where(["album_id" => $id, "user_id" => $userId])->first();
            $userAccess->isAuthorize = 0;
            $userAccess->save(); 
        }

        $userAccessCount = Access::where(["album_id" => $id, "isAuthorize" => 1])->count();

        if($userAccessCount == 0) {
            $album = Album::where(['id' => $id])->first();
            $album->share_at   = null;
            $album->shareToken = null;
            $album->save();
        }
        
        return response()->json([
            "success"   => true,
            "message"  => "Mise à jour effectuée"
        ]);
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
