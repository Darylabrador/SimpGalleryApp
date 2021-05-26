<?php

namespace App\Http\Controllers;

use App\Models\Photo;
use App\Http\Resources\PhotoResource;
use App\Models\Album;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class PhotoController extends Controller
{
    /**
     * Add pic to an album
     * @return \Illuminate\Http\Response
     */
    public function create(Request $request){
        $validator = Validator::make(
            $request->all(),
            [   
                'albumId' => 'required',
                'image'   => 'required|file|mimes:jpg,jpeg,png|max:5000',
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

        if($request->hasFile('image')){
            $file      = $validator->validated()['image'];
            $albumId   = $validator->validated()['albumId'];

            $extension          = $file->getClientOriginalExtension();
            $image              = time() . rand() . '.' . $extension;
            $file->move(public_path('img/albums'), $image);
            $photo              = new Photo();
            $photo->album_id    = $albumId;
            $photo->label       = $image;
            $photo->save();

            return response()->json([
                'success' => true,
                'message' => "Photo ajoutée"
            ]);
        }
    }


    /**
     * Pic list on an album
     *
     * @return \Illuminate\Http\Response
     */
    public function photoList($albumId)
    {
        $photos = Photo::where(['album_id' => $albumId])->get();
        return PhotoResource::collection($photos);
    }


    /**
     * get a pic
     *
     * @return \Illuminate\Http\Response
     */
    public function showOne($photoId)
    {
        $photo = Photo::where('id', $photoId)->first();
        return new PhotoResource($photo);
    }


    /**
     * Destroy a pic 
     *
     * @return \Illuminate\Http\Response
     */
    public function destroy($id){
        $photo = Photo::where('id',$id)->first();
        $photo->delete(); 

        return response()->json([
            'success' => true,
            'message' => "Photo supprimés"
        ]);
        
    }
}
