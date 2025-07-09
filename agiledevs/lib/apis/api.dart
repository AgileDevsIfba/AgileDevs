import 'dart:convert';
import 'package:agiledevs/models/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final _BASE_USUARIOS = dotenv.env['USUARIOS_API']!;
final _METODOS_API = dotenv.env['METODOS_API']!;
final _FAVORITOS_API = dotenv.env['FAVORITOS_API']!;
final _AVALIACOES_API = dotenv.env['AVALIACOES_API']!;

class ServicoUsuarios {
  Future<Usuario?> salvar(Usuario usuario) async {
    final resposta = await http.post(
      Uri.parse("$_BASE_USUARIOS"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"nome": usuario.nome, "email": usuario.email}),
    );

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);
      final jsonUsuario = dados["usuario"];
      return Usuario(jsonUsuario["nome"], jsonUsuario["email"]);
    } else {
      return null;
    }
  }
}

class ServicoMetodos {
  Future<List<dynamic>> getMetodos(int ultimoId, int tamanhoPagina) async {
    final resposta = await http.get(
      Uri.parse('$_METODOS_API/metodos/$ultimoId/$tamanhoPagina'),
    );
    if (resposta.statusCode != 200) {
      throw Exception('Erro ao buscar metodos');
    }
    return jsonDecode(resposta.body);
  }

  Future<List<dynamic>> findMetodos(
    int ultimoId,
    int tamanhoPagina,
    String title,
  ) async {
    final resposta = await http.get(
      Uri.parse(
        '$_METODOS_API/metodos/filtrar/$ultimoId/$tamanhoPagina/$title',
      ),
    );
    if (resposta.statusCode != 200) {
      throw Exception('Erro ao buscar metodos');
    }
    return jsonDecode(resposta.body);
  }

  Future<dynamic> buscarMetodoPorId(int id) async {
    final resposta = await http.get(
      Uri.parse('$_METODOS_API/metodos/$id'),
    );
    if (resposta.statusCode != 200) {
      throw Exception('Erro ao buscar método por ID');
    }
    return jsonDecode(resposta.body);
  }
}

class ServicoFavoritos {
  Future<bool> adicionarFavorito(String? email, int metodoId) async {
    final resposta = await http.post(
      Uri.parse("$_FAVORITOS_API/favoritos/adicionar"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "metodo_id": metodoId}),
    );

    return resposta.statusCode == 201;
  }

  Future<bool> removerFavorito(String? email, int metodoId) async {
    final resposta = await http.delete(
      Uri.parse("$_FAVORITOS_API/favoritos/excluir"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "metodo_id": metodoId}),
    );

    return resposta.statusCode == 200;
  }

  Future<List<dynamic>> listarFavoritos(
    String? email,
    int ultimoId,
    int tamanho,
  ) async {
    final url = "$_FAVORITOS_API/favoritos/$email/$ultimoId/$tamanho";
    final resposta = await http.get(Uri.parse(url));

    if (resposta.statusCode != 200) {
      throw Exception("Erro ao listar favoritos");
    }

    return jsonDecode(resposta.body);
  }

  Future<List<dynamic>> buscarFavoritos(
    String? email,
    int ultimoId,
    int tamanho,
    String filtro,
  ) async {
    final url =
        "$_FAVORITOS_API/favoritos/buscar/$email/$ultimoId/$tamanho/$filtro";
    final resposta = await http.get(Uri.parse(url));

    if (resposta.statusCode != 200) {
      throw Exception("Erro ao buscar favoritos");
    }

    return jsonDecode(resposta.body);
  }

  Future<List<int>> listarIdsFavoritos(String? email) async {
    final url = "$_FAVORITOS_API/favoritos/ids/$email";
    final resposta = await http.get(Uri.parse(url));

    if (resposta.statusCode != 200) {
      throw Exception("Erro ao buscar IDs dos favoritos");
    }

    return List<int>.from(jsonDecode(resposta.body));
  }
}

class ServicoAvaliacoes {
  // 1. Adicionar avaliação
  Future<bool> adicionarAvaliacao(
    int metodoId,
    String? nome,
    String? email,
    int nota,
    List<String> tagsPositivas,
    List<String> tagsNegativas,
    String? comentario,
  ) async {
    final resposta = await http.post(
      Uri.parse("$_AVALIACOES_API/avaliacoes/adicionar"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "metodo_id": metodoId,
        "nome": nome,
        "email": email,
        "nota": nota,
        "tags_positivas": tagsPositivas,
        "tags_negativas": tagsNegativas,
        "comentario": comentario,
      }),
    );

    return resposta.statusCode == 201;
  }

  Future<bool> excluirAvaliacao(String? email, int metodoId) async {
    final resposta = await http.delete(
      Uri.parse("$_AVALIACOES_API/avaliacoes/excluir"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "metodo_id": metodoId}),
    );
    return resposta.statusCode == 200;
  }

  Future<List<dynamic>> listarAvaliacoesPorMetodo(int metodoId) async {
    final resposta = await http.get(
      Uri.parse("$_AVALIACOES_API/avaliacoes/$metodoId"),
    );

    if (resposta.statusCode != 200) {
      throw Exception("Erro ao listar avaliações!");
    }

    return jsonDecode(resposta.body);
  }

  Future<Map<String, dynamic>> mediaAvaliacoesPorMetodo(int metodoId) async {
    final resposta = await http.get(
      Uri.parse("$_AVALIACOES_API/avaliacoes/media/$metodoId"),
    );
    if (resposta.statusCode != 200) {
      throw Exception("Erro ao obter média de avaliações!");
    }

    final json = jsonDecode(resposta.body);
    return {
      'media': (json['media_nota'] as num).toDouble(),
      'total': json['total_avaliacoes'] as int,
    };
  }
}
