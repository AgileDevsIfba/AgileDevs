import 'dart:convert';
import 'package:agiledevs/models/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final _BASE_USUARIOS = dotenv.env['USUARIOS_API']!;

class ServicoUsuarios {
  Future<Usuario?> salvar(Usuario usuario) async {
    final resposta = await http.post(
      Uri.parse("$_BASE_USUARIOS"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"nome": usuario.nome, "email": usuario.email}),
    );

    print('Status da resposta: ${resposta.statusCode}');
    print('Body da resposta: ${resposta.body}');
    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);
      final jsonUsuario = dados["usuario"];
      return Usuario(jsonUsuario["nome"], jsonUsuario["email"]);
    } else {
      return null;
    }
  }
}
