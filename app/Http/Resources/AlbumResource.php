<?php

namespace App\Http\Resources;

use App\Models\Photo;
use DateTime;
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

        $shareAt = new DateTime($this->share_at);
        $shareAtFormated = $shareAt->format('d-m-Y H:i:s');
        
        return[ 
            "id"              => $this->id,
            "label"           => $this->label,
            "cover"           => $this->cover,
            "shareAt"         => $this->share_at != null ? $shareAtFormated : "x",
            'counterPhoto'    => Photo::where(['album_id' => $this->id])->count(),
            "owner"           => new UserResource($this->user)
        ];
    }
}
