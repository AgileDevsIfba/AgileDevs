<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class FavoritosController extends Controller
{
    public function adicionarFavorito(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'metodo_id' => 'required|integer',
        ]);

        $email = $request->input('email');
        $metodoId = $request->input('metodo_id');

        $usuarioExiste = DB::table('usuarios')
            ->where('email', $email)
            ->exists();

        if (!$usuarioExiste) {
            return response()->json(['error' => 'Usuário não encontrado'], 404);
        }

        $favoritoExiste = DB::table('favoritos')
            ->where('email', $email)
            ->where('metodo_id', $metodoId)
            ->exists();
        if ($favoritoExiste) {
            return response()->json(['error' => 'Esse método já está nos favoritos.'], 409);
        }

        DB::table('favoritos')->insert([
            'email' => $email,
            'metodo_id' => $metodoId,
        ]);

        return response()->json(['message' => 'Método adicionado aos favoritos com sucesso.'], 201);
    }

    public function excluirFavorito(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'metodo_id' => 'required|integer',
        ]);

        $email = $request->input('email');
        $metodoId = $request->input('metodo_id');

        DB::table('favoritos')
            ->where('email', $email)
            ->where('metodo_id', $metodoId)
            ->delete();

        return response()->json(['message' => 'Método removido dos favoritos com sucesso.'], 200);
    }

    public function listarIdsFavoritos($email = null)
    {
        $ids = DB::table('favoritos')
            ->where('email', $email)
            ->pluck('metodo_id');

        return response()->json($ids);
    }

    public function listarFavoritos($email = null, $ultimoId = 0, $tamanho = 0)
    {
        $favoritos = DB::table('favoritos')
            ->where('favoritos.email', $email)
            ->join('metodos', 'favoritos.metodo_id', '=', 'metodos.id')
            ->where('metodos.id', '>', $ultimoId)
            ->orderBy('metodos.id', 'asc')
            ->limit($tamanho)
            ->select('metodos.*')
            ->get();

        return response()->json($favoritos);
    }

    public function buscarFavoritos($email, $ultimoId = 0, $tamanho = 0, $filtro = '')
    {
        $favoritos = DB::table('favoritos')
            ->where('favoritos.email', $email)
            ->join('metodos', 'favoritos.metodo_id', '=', 'metodos.id')
            ->where('metodos.titulo', 'like', '%' . $filtro . '%')
            ->where('metodos.id', '>', $ultimoId)
            ->orderBy('metodos.id', 'asc')
            ->limit($tamanho)
            ->select('metodos.*')
            ->get();

        return response()->json($favoritos);
    }
}
