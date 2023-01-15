<?php

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


Route::post('/register', [App\Http\Controllers\Auth\AuthController::class, 'register']);

Route::post('/login', [App\Http\Controllers\Auth\AuthController::class, 'login']);


Route::group(['middleware' => ['auth:sanctum']], function () {

    //---------------- Auth's Routes ----------------//
    Route::get('/logout', [App\Http\Controllers\Auth\AuthController::class, 'logout']);
    //---------------- User's Routes ----------------//
    Route::post('/stations', [App\Http\Controllers\StationController::class, 'store']);
   Route::get('/stations', [App\Http\Controllers\StationController::class, 'index']);
    Route::get('/user', [App\Http\Controllers\UserController::class, 'show']);
    Route::get('/favorites', [App\Http\Controllers\UserController::class, 'Favorites']);
    Route::post('/user/addFavorite', [App\Http\Controllers\UserController::class, 'addFavorite']);
    Route::get('/station/{station}', [App\Http\Controllers\StationController::class, 'show']);
    Route::get('/stations/{name}/search', [App\Http\Controllers\StationController::class, 'search']);
    Route::patch('/stations/{station}', [App\Http\Controllers\StationController::class, 'update']);
    Route::delete('/stations/{station}', [App\Http\Controllers\StationController::class, 'destroy']);
});

Route::post('influxdb/get/{mesurment}', [App\Http\Controllers\InfluxDBController::class, 'index']);
