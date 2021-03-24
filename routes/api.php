<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\AccountController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/



/*
|--------------------------------------------------------------------------
| Authentication routes
|--------------------------------------------------------------------------
*/

Route::post('/connexion', [AuthController::class, 'connection'])->name('api.connexion');
Route::post('/inscription', [AuthController::class, 'register'])->name('api.inscription');
Route::get('/deconnexion', [AuthController::class, 'logout'])->middleware('auth:api')->name('api.deconnexion');
Route::post('/email/verification', [AuthController::class, "verifymail"])->name('api.verify.email');

/*
|--------------------------------------------------------------------------
| Account routes
|--------------------------------------------------------------------------
*/

Route::prefix("reset")->group(function() {
    Route::post("/request", [AccountController::class, 'forgottenPassRequest'])->name("api.reset.request");
    Route::post("/password", [AccountController::class, 'resetPassword'])->name("api.reset.password");
});

Route::post('/delete/account', [AccountController::class, 'deleteAccount'])->middleware('auth:api')->name("api.delete.account");

/*
|--------------------------------------------------------------------------
| Profil gestion's
|--------------------------------------------------------------------------
*/

Route::post('/update/profil', [AccountController::class, 'updateProfil'])->middleware('auth:api')->name('api.update.profil');