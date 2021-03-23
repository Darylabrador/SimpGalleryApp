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


/**
 * Authentication routes
 */

Route::post('/connexion', [AuthController::class, 'connection'])->name('api.connexion');
Route::post('/inscription', [AuthController::class, 'register'])->name('api.inscription');
Route::post('/email/verification', [AuthController::class, "verifymail"])->name('api.verify.email');
Route::get('/deconnexion', [AuthController::class, 'logout'])->middleware('auth:api')->name('api.deconnexion');


/**
 * Profil gestion's
 */