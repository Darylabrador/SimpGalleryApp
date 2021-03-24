<?php

namespace Database\Factories;

use App\Models\Notification;
use Illuminate\Database\Eloquent\Factories\Factory;

class NotificationFactory extends Factory
{
    /**
     * The name of the factory's corresponding model.
     *
     * @var string
     */
    protected $model = Notification::class;

    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition()
    {
        $users =\App\Models\User::pluck('id')->toArray();
        return [
            //
            'user_id' => $this->faker->randomElement($users),
            'label' => $this->faker->text(),
            'isRead' =>$this->faker->boolean($chanceOfGettingTrue = 50),
        ];
    }
}
