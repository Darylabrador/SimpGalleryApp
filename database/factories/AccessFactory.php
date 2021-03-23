<?php

namespace Database\Factories;

use App\Models\Access;
use Illuminate\Database\Eloquent\Factories\Factory;

class AccessFactory extends Factory
{
    /**
     * The name of the factory's corresponding model.
     *
     * @var string
     */
    protected $model = Access::class;

    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition()
    {
        $users =\App\Models\User::pluck('id')->toArray();
        $albums =\App\Models\Album::pluck('id')->toArray();
        
        return [
            //
            'user_id' => $this->faker->randomElement($users),
            'album_id' => $this->faker->randomElement($albums),
        ];
    }
}
