<?php

use App\Http\Controllers\MetodoController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/metodos/{ultimoId}/{tamanho}', [MetodoController::class, 'listarMetodos']);
Route::get('/metodos/filtrar/{ultimoId}/{tamanho}/{filtro}', [MetodoController::class, 'buscarMetodo']);
Route::get('/metodos/{id}', [MetodoController::class, 'buscarMetodoPorId']);

// Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
//     return $request->user();
// });
