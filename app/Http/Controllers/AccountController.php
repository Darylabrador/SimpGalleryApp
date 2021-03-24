<?php

namespace App\Http\Controllers;

use App\Mail\ChangePassword;
use DateTime;
use Carbon\Carbon;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;
use App\Mail\DeleteAccountMail;
use App\Mail\ForgottenPassword;

class AccountController extends Controller
{
    /**
     * Update user profil.
     *
     * @return \Illuminate\Http\Response
     */
    public function updateProfil(Request $request) {
        $validator = Validator::make(
            $request->all(),
            [
                'pseudo'          => 'required',
                'email'           => 'required',
                'password'        => 'nullable',
                'passwordConfirm' => 'nullable',
                'profilPic'       => 'nullable',
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

        $pseudo             = $validator->validated()['pseudo'];
        $email              = $validator->validated()['email'];
        $password           = $validator->validated()['password'];
        $passwordConfirm    = $validator->validated()['passwordConfirm'];
        $userExist          = User::where(["email" => $email])->first();

        if(!$userExist) {
            return response()->json([
                'success' => false,
                'message' => "Compte introuvable"
            ]);
        }

        if($password != null) {
            if ($password != $passwordConfirm) {
                return response()->json([
                    "success" => false,
                    "message" => "Les mots de passe ne sont pas identique"
                ]);
            }
        }

        $userExist->pseudo      = $pseudo;
        $userExist->email       = $email;
        $userExist->password    = Hash::make($password);

        if ($request->hasFile('profilPic')) {
            $oldImage = $userExist->profilPic;

            if ($oldImage != null && $oldImage != "profils/default.png") {
                $oldFilePath = public_path('img') . '/' . $oldImage;
                unlink($oldFilePath);
            }

            $imageUploaded  = $validator->validated()['profilPic'];
            $extension      = $imageUploaded->getClientOriginalExtension();
            $image          = time() . rand() . '.' . $extension;
            $imageUploaded->move(public_path('img/profils'), $image);
            $userExist->profilPic = $image;
        }

        $userExist->save();
        return response()->json([
            'success' => true,
            'message' => 'Mise à jour effectuée'
        ]);
    }

    /**
     * Handle request for forgotten password.
     *
     * @return \Illuminate\Http\Response
     */
    public function forgottenPassRequest(Request $request)
    {
        $validator = Validator::make(
            $request->all(),
            [
                'email'           => 'required',
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

        $email  = $validator->validated()['email'];
        $user   = User::where(['email' => $email])->first();

        if ($user) {
            $resetToken =  Str::random(20);
            $user->resetToken = $resetToken;
            $user->save();

            return response()->json([
                "success"    => true,
                "resetToken" => $resetToken
            ]);
        }

        return response()->json([
            'success' => false,
            'message' => "Vous ne pouvez pas effectuer cette action"
        ]);
    }



    /**
     * Handle user reset password.
     *
     * @return \Illuminate\Http\Response
     */
    public function resetPassword(Request $request)
    {
        $validator = Validator::make(
            $request->all(),
            [
                'resetToken'        => 'required',
                'password'          => 'required',
                'passwordConfirm'   => 'required',
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

        $resetToken       = $validator->validated()['resetToken'];
        $password         = $validator->validated()['password'];
        $passwordConfirm  = $validator->validated()['passwordConfirm'];

        $user = User::where(["resetToken" => $resetToken])->first();
        
        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => "Token invalide"
            ]);
        }

        if ($password != $passwordConfirm) {
            return response()->json([
                'success' => false,
                'message' => "Les mots de passe ne sont pas identique"
            ]);
        }

        $user->resetToken = null;
        $user->password   = Hash::make($password);
        $user->save();

        return response()->json([
            'success' => true,
            'message' => "Mise à jour effectuée"
        ]);
    }


    /**
     * Handle delete account request.
     *
     * @return \Illuminate\Http\Response
     */
    public function deleteAccount(Request $request) {
        $validator = Validator::make(
            $request->all(),
            [
                'password'          => 'required',
                'passwordConfirm'   => 'required',
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

        $password         = $validator->validated()['password'];
        $passwordConfirm  = $validator->validated()['passwordConfirm'];
        $userId = Auth::id();

        if ($password != $passwordConfirm) {
            return response()->json([
                'success' => false,
                'message' => "Les mots de passe ne sont pas identique"
            ]);
        }

        Auth::user()->tokens->each(function ($token, $key) {
            $token->delete();
        });

        User::destroy($userId);
        
        return response()->json([
            'success' => true,
            'message' => "Compte supprimer"
        ]);
    }
}
