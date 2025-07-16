class Metodo {
  final int id;
  final String title;
  final String description;
  final String folder;
  double? mediaNota;
  int? totalAvaliacoes;

  Metodo({
    required this.id,
    required this.title,
    required this.description, 
    required this.folder,
    this.mediaNota,
    this.totalAvaliacoes,
  });

  factory Metodo.fromJson(Map<String, dynamic> json) {
    return Metodo(
      id: json['id'] as int,
      title: json['titulo'] as String,
      description: json['descricao'] as String,
      folder: json['folder'] as String,
    );
  }
}