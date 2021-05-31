<?php

namespace App\Http\Resources;

use App\Models\Comment;
use Illuminate\Http\Resources\Json\JsonResource;

class PhotoResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array
     */
    public function toArray($request)
    {
        $comments = Comment::orderBy("id", "desc")->where('photo_id', $this->id)->get();
        
        return[ 
            "id"            => $this->id,
            "label"         => $this->label,
            "comments"      => CommentResource::collection($comments)
            // "reaction"      => ReactionResource::collection($this->reaction),
        ];
    }
}
