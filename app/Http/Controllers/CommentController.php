<?php

namespace App\Http\Controllers;

use App\Http\Resources\CommentResource;
use App\Models\Comment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class CommentController extends Controller
{
     /**
     * Add a comment to a pic
     * @return \Illuminate\Http\Response
     */
    public function create(Request $request, $albumId){
        $validator = Validator::make(
            $request->all(),
            [   
                'photoId'   => "required",
                'comment'   => "required",
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
        $user       = Auth::user();
        $loggedId   = $user->id;
        
        $comment            = new Comment;
        $comment->user_id   = $loggedId;
        $comment->photo_id  = $validator->validated()['photoId'];
        $comment->comment   = $validator->validated()['comment'];
        $comment->save();
        

        return response()->json([
            'success' => true,
            'message' => "Commentaire ajouté"
        ]);
        
    }
    /**
     * Comment list for a pic
     *
     * @return \Illuminate\Http\Response
     */
    public function list($photoId)
    {
        $comments = Comment::where('photo_id', $photoId)->get();
        return CommentResource::collection($comments);
    }

    /**
     * Delete all comment from a pic 
     *
     * @return \Illuminate\Http\Response
     */
    public function delete($photoId)
    {
        $comments = Comment::where('photo_id', $photoId)->get();
        $comments->delete();

        return response()->json([
            'success' => true,
            'message' => "Commentaires supprimés"
        ]);
    }
    
}
