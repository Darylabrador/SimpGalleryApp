<?php

namespace App\Http\Resources;

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
        return[ 
            "id"            => $this->id,
            "label"         => $this->label,
            "comments"      => CommentResource::collection($this->comments)
            // "reaction"      => ReactionResource::collection($this->reaction),
        ];
    }
}
