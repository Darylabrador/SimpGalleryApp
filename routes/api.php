<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\AccountController;
use App\Http\Controllers\AlbumController;
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


/*
|--------------------------------------------------------------------------
| Profil gestion's
|--------------------------------------------------------------------------
*/

Route::middleware(['auth:api'])->group(function(){
    Route::post('/update/profil', [AccountController::class, 'updateProfil'])->name('api.update.profil');
    Route::post('/delete/account', [AccountController::class, 'deleteAccount'])->name("api.delete.account");
});



/*
|--------------------------------------------------------------------------
| Albums gestion's
|--------------------------------------------------------------------------
*/

Route::middleware(['auth:api'])->prefixe('album')->group(function(){
    Route::post('/create', [AlbumController::class, 'create'])->name('api.create.album');
    Route::post('/cover', [AlbumController::class, 'editCover'])->name('api.editcover.album');
    Route::post('/share', [AlbumController::class, 'share'])->name('api.share.album');
    Route::get('/share/list', [AlbumController::class, 'shareAlbumList'])->name('api.share.list.album');
    Route::get('/share/limit', [AlbumController::class, 'shareAlbumLimit'])->name('api.share.limit.album');
    Route::get('/list', [AlbumController::class, 'myAlbumList'])->name('api.list.album');
    Route::get('/limit', [AlbumController::class, 'myAlbumLimit'])->name('api.limit.album');
});
