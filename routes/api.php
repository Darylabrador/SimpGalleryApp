<?php

use App\Http\Controllers\AccessController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\AccountController;
use App\Http\Controllers\AlbumController;
use App\Http\Controllers\CommentController;
use App\Http\Controllers\PhotoController;
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
Route::post('/email/verification', [AuthController::class, "verifymail"])->middleware(['auth:api'])->name('api.verify.email');
/*
|--------------------------------------------------------------------------
| Account routes
|--------------------------------------------------------------------------
*/

Route::get('/account/info', [AccountController::class, "accountInformations"])->middleware(['auth:api'])->name('api.user.info');

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
    Route::post('/update/avatar', [AccountController::class, 'updateAvatarImage'])->name('api.update.updateAvatarImage');
    Route::post('/update/profil', [AccountController::class, 'updateProfil'])->name('api.update.profil');
    Route::post('/delete/account', [AccountController::class, 'deleteAccount'])->name("api.delete.account");
});



/*
|--------------------------------------------------------------------------
| Albums gestion's
|--------------------------------------------------------------------------
*/

Route::get('/email/liste/{value}', [AlbumController::class, "autocomplete"])->name("api.autocomplete");

Route::middleware(['auth:api'])->prefix('/album')->group(function() {
    Route::post('/create', [AlbumController::class, 'create'])->name('api.create.album');
    Route::post('/cover', [AlbumController::class, 'editCover'])->name('api.editcover.album');
    Route::get('/list', [AlbumController::class, 'myAlbumList'])->name('api.list.album');
    Route::delete('/delete/{id}', [AlbumController::class, 'destroy'])->name('api.delete.album');

    Route::get('/trash/list', [AlbumController::class, 'getTrash'])->name('api.list.album.trash');
    Route::put('{id}/trash/restore', [AlbumController::class, 'restoreTrash'])->name('api.photo.album.restore');
    Route::delete('{id}/delete/confirm', [AlbumController::class, 'confirmDelete'])->name('api.delete.album.confirm');

    Route::post('/share', [AlbumController::class, 'share'])->name('api.share.album');    
    Route::get('/share/list', [AlbumController::class, 'shareAlbumList'])->name('api.share.list.album');
    Route::post('/share/confirm', [AccessController::class, "checkAccess"])->name('api.share.confirm');
    
    Route::get('{id}/participants', [AccessController::class, "listParticipants"])->name('api.share.participants');
    Route::put('{id}/participant/delete', [AccessController::class, "deleteParticipants"])->name('api.share.delete.participants');
    Route::get('/share/leave/{id}', [AccessController::class, "leaveAlbumShare"])->name('api.share.leave');
    Route::delete('{id}/share/delete', [AlbumController::class, 'deleteShare'])->name('api.share.delete');
});


/*
|--------------------------------------------------------------------------
| Photos gestion's
|--------------------------------------------------------------------------
*/

Route::middleware(['auth:api'])->prefix('/photo')->group(function(){
    Route::post('/create', [PhotoController::class, 'create'])->name('api.create.photo');
    Route::get('/list/{albumId}', [PhotoController::class, 'photoList'])->name('api.list.photo');
    Route::get('/show/{photoId}', [AlbumController::class, 'showOne'])->name('api.show.photo');

    Route::get('/trash/list', [PhotoController::class, 'getTrash'])->name('api.list.photo.trash');
    Route::put('{id}/trash/restore', [PhotoController::class, 'restoreTrash'])->name('api.photo.trash.restore');
    Route::delete('/delete/{id}', [PhotoController::class, 'destroy'])->name('api.delete.photo');
    Route::delete('{id}/delete/confirm', [PhotoController::class, 'confirmDelete'])->name('api.delete.photo.confirm');
});

/*
|--------------------------------------------------------------------------
| Comments gestion's
|--------------------------------------------------------------------------
*/

Route::middleware(['auth:api'])->prefix('/comment')->group(function(){
    Route::post('/create', [CommentController::class, 'create'])->name('api.create.comment');
    Route::delete('/delete/{commentId}', [CommentController::class, 'delete'])->name('api.delete.comment');
    Route::get('/list/{photoId}', [CommentController::class, 'list'])->name('api.list.comment');
});
