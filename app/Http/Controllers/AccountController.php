<?php

namespace App\Http\Controllers;

use App\Http\Resources\UserResource;
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
use App\Mail\ChangePassword;
use Illuminate\Support\Facades\Log;

class AccountController extends Controller
{

    /**
     * Get user account informations.
     *
     * @return \Illuminate\Http\Response
     */
    public function accountInformations() {
        $user = User::where(['id' => Auth::id()])->first();
        return new  UserResource($user);
    }


    /**
     * Update user profil.
     *
     * @return \Illuminate\Http\Response
     */
    public function updateProfil(Request $request) {
        $validator = Validator::make(
            $request->all(),
            [
                'pseudo'          => 'required|unique:users',
                'password'        => 'nullable',
                'passwordConfirm' => 'nullable',
            ],
            [
                'required' => 'Le champ :attribute est requis',
                'unique' => 'Pseudo existe déjà'
            ]
        );

        $errors = $validator->errors();
        if (count($errors) != 0) {
            return response()->json([
                "success"  => false,
                "message"  => $errors->first(),
            ]);
        }


        $pseudo             = $validator->validated()['pseudo'];
        $password           = $validator->validated()['password'];
        $passwordConfirm    = $validator->validated()['passwordConfirm'];

        $userId     = Auth::id();
        $userExist  = User::where(["id" => $userId])->first();

        if(!$userExist) {
            return response()->json([
                "success"  => false,
                "message"  => "Compte introuvable",
            ]);
        }

        if($password != "") {
            if ($password != $passwordConfirm) {
                return response()->json([
                    "success"  => false,
                    "message"  => "Les mots de passe ne sont pas identique",
                ]);
            } else {
                $userExist->password    = Hash::make($password);
            }
        }

        $userExist->pseudo      = $pseudo;
        $userExist->save();

        return response()->json([
            "success"  => true,
            "pseudo"   => $userExist->pseudo,
            "message"  => "Mise à jour effectuée",
        ]);
    }


    /**
     * Handle request for forgotten password.
     *
     * @return \Illuminate\Http\Response
     */
    public function updateAvatarImage(Request $request) {
        $validator = Validator::make(
            $request->all(),
            [
                'profilPic'       => 'nullable|sometimes|image',
            ],
            [
                'required' => 'Le champ :attribute est requis',
                'image' => "Ce n'est pas une image"
            ]
        );

        $errors = $validator->errors();
        if (count($errors) != 0) {
            return response()->json([
                "success"  => false,
                "message"  => $errors->first(),
            ]);
        }

        $userId     = Auth::id();
        $userExist  = User::where(["id" => $userId])->first();

        if(!$userExist) {
            return response()->json([
                "success"  => false,
                "message"  => "Compte introuvable",
            ]);
        }


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
            "success"  => true,
            "message"  => "Mise à jour effectuée",
            "avatar"   => $userExist->profilPic
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
                'identifiant'           => 'required',
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

        $identifiant  = $validator->validated()['identifiant'];
        $user   = User::where(['identifiant' => $identifiant])->first();

        if ($user) {
            $resetToken =  Str::random(20);
            $user->resetToken = $resetToken;
            $user->save();
            return  $resetToken;
        }
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

        if ($password != $passwordConfirm) {
            return response()->json([
                'success' => true,
                'message' => "Les mots de passe ne sont pas identique"
            ]);
        }
        
        Auth::user()->tokens->each(function ($token, $key) {
            $token->delete();
        });

        User::destroy(Auth::id());
        
        return response()->json([
            'success' => true,
            'message' => "Compte supprimer"
        ]);
    }
}
