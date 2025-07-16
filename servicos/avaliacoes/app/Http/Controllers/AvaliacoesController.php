<?php

namespace App\Http\Controllers;

use App\Models\Avaliacao;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class AvaliacoesController extends Controller
{
    public function adicionarAvaliacao(Request $request)
    {
        $validated = $request->validate([
            'metodo_id' => 'required|integer',
            'nome' => 'required|string|max:255',
            'email' => 'required|email|max:125',
            'nota' => 'required|integer|min:1|max:5',
            'tags_positivas' => 'nullable|array',
            'tags_negativas' => 'nullable|array',
            'comentario' => 'nullable|string',
        ]);

        $usuarioExiste = DB::table('usuarios')
            ->where('email', $validated['email'])
            ->exists();

        if (!$usuarioExiste) {
            return response()->json(['error' => 'Usuário não encontrado'], 404);
        }

        $avaliacaoExiste = DB::table('avaliacoes')
            ->where('email', $validated['email'])
            ->where('metodo_id', $validated['metodo_id'])
            ->exists();

        if ($avaliacaoExiste) {
            return response()->json(['error' => 'Avaliação já existe para este usuário e método.'], 409);
        }

        try {
            $avaliacao = Avaliacao::create([
                'metodo_id' => $validated['metodo_id'],
                'nome' => $validated['nome'],
                'email' => $validated['email'],
                'nota' => $validated['nota'],
                'tags_positivas' => $validated['tags_positivas'] ?? [],
                'tags_negativas' => $validated['tags_negativas'] ?? [],
                'comentario' => $validated['comentario'],
            ]);

            return response()->json($avaliacao, 201);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Erro ao adicionar avaliação: ' . $e->getMessage()], 500);
        }
    }

    public function excluirAvaliacao(Request $request)
    {
        $validated = $request->validate([
            'email' => 'required|email|max:125',
            'metodo_id' => 'required|integer',
        ]);

        $avaliacao = Avaliacao::where('email', $validated['email'])
            ->where('metodo_id', $validated['metodo_id'])
            ->first();

        if (!$avaliacao) {
            return response()->json(['error' => 'Avaliação não encontrada'], 404);
        }

        try {
            $avaliacao->delete();
            return response()->json(['message' => 'Avaliação excluída com sucesso'], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Erro ao excluir avaliação: ' . $e->getMessage()], 500);
        }
    }

    public function listarAvaliacoesPorMetodo($metodo_id)
    {
        $avaliacoes = Avaliacao::where('metodo_id', $metodo_id)
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json($avaliacoes, 200);
    }

    public function mediaAvaliacoesPorMetodo($metodo_id)
    {
        $avaliacoes = Avaliacao::where('metodo_id', $metodo_id);
        $media = $avaliacoes->avg('nota');
        $total = $avaliacoes->count();

        return response()->json([
            'metodo_id' => $metodo_id,
            'media_nota' => round($media, 1),
            'total_avaliacoes' => $total
        ]);
    }
}
