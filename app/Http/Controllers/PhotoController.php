<?php

namespace App\Http\Controllers;

use App\Models\Photo;
use App\Models\Album;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class PhotoController extends Controller
{
    public function create(Request $request, $albumId){
        
            $validator = Validator::make(
                $request->all(),
                [   
                    'images.*' => 'required|file|mimes:jpg,jpeg,png|max:5000',
                ],
                [
                    'file'  => 'Image non fournis',
                    'mimes' => 'Extension invalide',
                    'max'   => '5Mb maximum'
                ]
            );

            foreach ($validator->validated()['images'] as $key => $pic) {
                
                $extension          = $pic->getClientOriginalExtension();
                $image              = time() . rand() . '.' . $extension;
                $pic->move(public_path('img/albums'), $image);
                $album              = new Album;
                $album->album_id    = $albumId;
                $album->label       = $image;
                $album->save();

                return response()->json([
                    'success' => true,
                    'message' => "Mise à jour effectuée"
                ]);
            }
        
    }
}
