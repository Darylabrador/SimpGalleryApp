<?php

namespace Database\Factories;

use App\Models\Invitation;
use Illuminate\Database\Eloquent\Factories\Factory;

class InvitationFactory extends Factory
{
    /**
     * The name of the factory's corresponding model.
     *
     * @var string
     */
    protected $model = Invitation::class;

    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition()
    {
        $albums =\App\Models\Album::pluck('id')->toArray();
        return [
            //
            'email' => $this->faker->safeEmail,
            'album_id' => $this->faker->randomElement($albums),
        ];
    }
}
