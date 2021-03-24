<?php

namespace App\Http\Controllers;

use DateTime;
use Carbon\Carbon;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;
use App\Mail\RegisterMail;
use App\Models\Invitation;

class AuthController extends Controller
{
    /**
     * Handle user connection.
     *
     * @return \Illuminate\Http\Response
     */
    public function connection(Request $request)
    {
        $validator = Validator::make(
            $request->all(),
            [
                'email'    => 'required',
                'password' => 'required',
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

        $email      = $validator->validated()['email'];
        $password   = $validator->validated()['password'];
        $userExist  = User::where(["email" => $email])->first();

        if (!$userExist || !Hash::check($password, $userExist->password)) {
            return response()->json([
                'success' => false,
                'message' => "Adresse email ou mot de passe incorrecte"
            ]);
        }

        $token = $userExist->createToken('AuthToken')->accessToken;
        return response()->json([
            "success" => true,
            "message" => "Vous êtes connecté !",
            "token"   => $token
        ]);
    }


    /**
     * Handle create user's account.
     *
     * @return \Illuminate\Http\Response
     */
    public function register(Request $request)
    {
        $validator = Validator::make(
            $request->all(),
            [
                'email'           => 'required|unique:users',
                'password'        => 'required',
                'passwordConfirm' => 'required',
            ],
            [
                'required' => 'Le champ :attribute est requis',
                'unique'   => 'Adresse email existe déjà'
            ]
        );

        $errors = $validator->errors();

        if (count($errors) != 0) {
            return response()->json([
                'success' => false,
                'message' => $errors->first()
            ]);
        }

        $email             = $validator->validated()['email'];
        $password          = $validator->validated()['password'];
        $passwordConfirm   = $validator->validated()['passwordConfirm'];

        if ($password != $passwordConfirm) {
            return response()->json([
                "success" => false,
                "message" => "Les mots de passe ne sont pas identique"
            ]);
        }

        $verifyToken       = Str::random(20);
        $part1             = Str::random(4);
        $part2             = Str::random(4);
    
        
        $invitationList = Invitation::where(['email' => $email])->get();
        
        if(count($invitationList) == 0) {
            $user              = new User();
            $user->pseudo      = "user" . $part1 . "X" . $part2;
            $user->email       = $email;
            $user->password    = Hash::make($password);
            $user->verifyToken = $verifyToken;
            $user->save();

            Mail::to($email)->send(new RegisterMail($email, $verifyToken));
            return response()->json([
                "success" => true,
                "message" => "Vous devez confirmer votre adresse mail"
            ]);
        } 

        $createdUser = User::create([
            "pseudo"      => "user" . $part1 . "X" . $part2,
            "email"       => $email,
            "password"    => Hash::make($password),
            "verifyToken" => $verifyToken,
            "verify_at"   => now(),
        ]);

        foreach ($invitationList as $invitation) {
            $newInvitation = new Invitation();
            $newInvitation->album_id = $invitation->album_id;
            $newInvitation->user_id  = $createdUser->id;
            $newInvitation->save();
        }

        return response()->json([
            "success" => true,
            "message" => "Bienvenue sur SimpGalleryApp"
        ]);
    }


    /**
     * Verify mail
     *
     *  @return \Illuminate\Http\Response
     */
    public function verifymail(Request $request)
    {
        $validator = Validator::make(
            $request->all(),
            [
                'verifyToken' => 'required',
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

        $verifyToken  = $validator->validated()['verifyToken'];
        $userExist = User::where(['verifyToken' => $verifyToken])->first();

        if (!$userExist) {
            return response()->json([
                "success" => false,
                "message" => "Jeton invalide"
            ]);
        }

        if ($userExist->verified_at != null) {
            return response()->json([
                "success" => false,
                "message" => "Adresse mail déjà vérifier"
            ]);
        }

        $userExist->verified_at = now();
        $userExist->save();

        return response()->json([
            "success" => true,
            "message" => "Adresse mail vérifier avec succès"
        ]);
    }


    /**
     * Handle disconnect request.
     *
     * @return \Illuminate\Http\Response
     */
    public function logout()
    {
        Auth::user()->tokens->each(function ($token, $key) {
            $token->delete();
        });
        return response()->json([
            'success' => true,
            "message" => "Vous êtes déconnecté !",
        ]);
    }
}
