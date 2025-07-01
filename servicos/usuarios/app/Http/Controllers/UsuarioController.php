<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Usuarios;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class UsuarioController extends Controller
{
    public function login(Request $request) {
        $nome = $request->input('nome');
        $email = $request->input('email');

        $user = Usuarios::firstOrCreate(
            ['email' => $email],
            ['nome' => $nome]
        );
        return response()->json(['user' => $user]);
    }
}
