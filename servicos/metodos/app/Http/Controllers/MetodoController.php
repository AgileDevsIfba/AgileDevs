<?php

namespace App\Http\Controllers;

use App\Models\Metodo;

class MetodoController extends Controller
{
    public function listarMetodos($ultimoId = null, $tamanho = null)
    {
        $metodos = Metodo::where('id', '>', $ultimoId)
            ->orderBy('id', 'asc')
            ->limit($tamanho)
            ->get();
        
        return response()->json($metodos);
    }

    public function buscarMetodo($ultimoId = 0, $tamanho = 0, $filtro = '')
    {
        $metodos = Metodo::where('titulo', 'like', '%' . $filtro . '%')
            ->where('id', '>', $ultimoId)
            ->orderBy('id', 'asc')
            ->limit($tamanho)
            ->get();
        
        return response()->json($metodos);
    }

    public function buscarMetodoPorId($id)
    {
        $metodo = Metodo::find($id);
        
        if (!$metodo) {
            return response()->json(['message' => 'Método não encontrado'], 404);
        }
        
        return response()->json($metodo);
    }
}
