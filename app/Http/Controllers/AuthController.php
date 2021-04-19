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
use App\Models\Access;
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
                'identifiant' => 'required',
                'password'    => 'required',
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

        $identifiant   = $validator->validated()['identifiant'];
        $password      = $validator->validated()['password'];
        $userExist     = User::where(["identifiant" => $identifiant])->first();

        if (!$userExist || !Hash::check($password, $userExist->password)) {
            return response()->json([
                'success' => false,
                'message' => "Identifiant ou mot de passe incorrecte"
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
                'identifiant'     => 'required|unique:users',
                'password'        => 'required',
                'passwordConfirm' => 'required',
            ],
            [
                'required' => 'Le champ :attribute est requis',
                'unique'   => 'Identifiant existe deja'
            ]
        );

        $errors = $validator->errors();

        if (count($errors) != 0) {
            return $errors->first() ;
        }

        $identifiant       = $validator->validated()['identifiant'];
        $password          = $validator->validated()['password'];
        $passwordConfirm   = $validator->validated()['passwordConfirm'];

        if ($password != $passwordConfirm) {
            return "Les mots de passe ne sont pas identique";
        }

        $verifyToken       = Str::random(20);
        $part1             = Str::random(4);
        $part2             = Str::random(4);
    
        $invitationList = Invitation::where(['target' => $identifiant])->get();
        
        if(count($invitationList) == 0) {
            $user              = new User();
            $user->pseudo      = "user" . $part1 . "X" . $part2;
            $user->identifiant = $identifiant;
            $user->password    = Hash::make($password);
            $user->verifyToken = $verifyToken;
            $user->isMobile    = 0;
            $user->save();

            Mail::to($identifiant)->send(new RegisterMail($identifiant, $verifyToken));
            return  "Vous devez confirmer votre adresse mail";
        } 

        $createdUser = User::create([
            "pseudo"      => "user" . $part1 . "X" . $part2,
            "identifiant" => $identifiant,
            "password"    => Hash::make($password),
            "verifyToken" => $verifyToken,
            "isMobile"    => $invitationList[0]->isMobile,
            "verify_at"   => now(),
        ]);

        foreach ($invitationList as $invitation) {
            $newAccess = new Access();
            $newAccess->album_id = $invitation->album_id;
            $newAccess->user_id  = $createdUser->id;
            $newAccess->save();
        }

        return "Bienvenue sur SimpGalleryApp";
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
            return  $errors->first();
        }

        $verifyToken  = $validator->validated()['verifyToken'];
        $userExist = User::where(['verifyToken' => $verifyToken])->first();

        if (!$userExist) {
            return "Jeton invalide";
        }

        if ($userExist->verified_at != null) {
            return "Adresse mail déjà verifier";
        }

        $userExist->verified_at = now();
        $userExist->save();

        return  "Adresse mail verifier avec succes";
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
        return "Vous êtes déconnecté !";
    }
}
