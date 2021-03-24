<?php

namespace App\Http\Controllers;

use App\Models\Album;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;

class AlbumController extends Controller
{
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

        $loggedUser = Auth::user();
        $userId = $loggedUser->id;

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
*Edit cover
*Illuminate\Http\Request
*/
public function editCover(Request $request,$albumId) {
    $validator = Validator::make(
        $request->all(),
        [
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

    

    $album     = Album::whereId($albumId)->first();
    $oldImage = $album->cover;
    
    
        $oldFilePath = public_path('images') . '/' . $oldImage;
        unlink($oldFilePath);
    

    $cover    = $validator->validated()['cover'];
    $extension      = $cover->getClientOriginalExtension();
    $image          = time() . rand() . '.' . $extension;
    $cover->move(public_path('images/profils'), $image);
    $album->cover = $image;
    $album->save();

    return response()->json([
        'success' => true,
        'message' => "Mise à jour effectuée"
    ]);
}
  
}
