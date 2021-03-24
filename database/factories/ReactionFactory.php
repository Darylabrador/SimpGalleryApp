<?php

namespace Database\Factories;

use App\Models\Reaction;
use Illuminate\Database\Eloquent\Factories\Factory;

class ReactionFactory extends Factory
{
    /**
     * The name of the factory's corresponding model.
     *
     * @var string
     */
    protected $model = Reaction::class;

    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition()
    {   
        $users =\App\Models\User::pluck('id')->toArray();
        $photos =\App\Models\Photo::pluck('id')->toArray();
        $reactionTypes =\App\Models\ReactionType::pluck('id')->toArray();
        return [
            //
            'user_id' => $this->faker->randomElement($users),
            'photo_id' => $this->faker->randomElement($photos),
            'reaction_type_id' => $this->faker->randomElement($reactionTypes),
        ];
    }
}
