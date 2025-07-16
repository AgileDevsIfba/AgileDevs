<?php

use App\Http\Controllers\AvaliacoesController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::post('/avaliacoes/adicionar', [AvaliacoesController::class, 'adicionarAvaliacao']);
Route::delete('/avaliacoes/excluir', [AvaliacoesController::class, 'excluirAvaliacao']);
Route::get('/avaliacoes/{metodo_id}', [AvaliacoesController::class, 'listarAvaliacoesPorMetodo']);Route::get('/avaliacoes', [AvaliacoesController::class, 'listarTodasAvaliacoes']);
Route::get('/avaliacoes/media/{metodo_id}', [AvaliacoesController::class, 'mediaAvaliacoesPorMetodo']);
// Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
//     return $request->user();
// });
