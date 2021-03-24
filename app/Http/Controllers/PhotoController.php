<?php

namespace App\Http\Controllers;

use App\Models\Photo;
use App\Models\Album;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class PhotoController extends Controller
{
    /**
     * Add pic to an album
     * @return \Illuminate\Http\Response
     */
    public function create(Request $request, $albumId){
        $validator = Validator::make(
            $request->all(),
            [   
                'images'   => "required",
                'images.*' => 'required|file|mimes:jpg,jpeg,png|max:5000',
            ],
            [
                'required' => 'Le champ :attribute est requis',
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

        if($request->hasFile('images')){
            foreach ($request->file('images') as $file) {
                $extension          = $file->getClientOriginalExtension();
                $image              = time() . rand() . '.' . $extension;
                $file->move(public_path('img/albums'), $image);
                $album              = new Album;
                $album->album_id    = $albumId;
                $album->label       = $image;
                $album->save();

                return response()->json([
                    'success' => true,
                    'message' => "Photo(s) ajoutée(s)"
                ]);
            }
            
            return response()->json([
                'success' => true,
                'message' => "Photo ajoutée"
            ]);
        }
    }
}
