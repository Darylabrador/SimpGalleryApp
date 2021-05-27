<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class AlbumResource extends JsonResource
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
            "cover"         => $this->cover,
            "owner"         => new UserResource($this->user)
        ];
    }
}
