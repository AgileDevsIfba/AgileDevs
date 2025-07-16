<?php

use App\Http\Controllers\FavoritosController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::post('/favoritos/adicionar', [FavoritosController::class, 'adicionarFavorito']);
Route::delete('/favoritos/excluir', [FavoritosController::class, 'excluirFavorito']);
Route::get('/favoritos/{email}', [FavoritosController::class, 'listarFavoritos']);
Route::get('/favoritos/ids/{email}', [FavoritosController::class, 'listarIdsFavoritos']);
Route::get('/favoritos/{email}/{ultimoId?}/{tamanho?}', [FavoritosController::class, 'listarFavoritos']);
Route::get('/favoritos/buscar/{email}/{ultimoId?}/{tamanho?}/{filtro?}', [FavoritosController::class, 'buscarFavoritos']);

// Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
//     return $request->user();
// });
