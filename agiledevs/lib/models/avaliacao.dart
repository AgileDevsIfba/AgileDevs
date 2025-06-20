class Avaliacao {
  final int metodoId;
  final String nome;
  final String email;
  final int nota;
  final List<String> tagsPositivas;
  final List<String> tagsNegativas;
  final String? comentario;

  Avaliacao({
    required this.metodoId,
    required this.nome,
    required this.email,
    required this.nota,
    required this.tagsPositivas,
    required this.tagsNegativas,
    this.comentario,
  });

  factory Avaliacao.fromJson(Map<String, dynamic> json) {
    return Avaliacao(
      metodoId: json['metodo_id'] as int,
      nome: json['nome'] as String,
      email: json['email'] as String,
      nota: json['nota'] as int,
      tagsPositivas: json['tags_positivas'] != null 
          ? List<String>.from(json['tags_positivas'])
          : [],
      tagsNegativas: json['tags_negativas'] != null
          ? List<String>.from(json['tags_negativas'])
          : [],
      comentario: json['comentario'] as String?,
    );
  }
}

