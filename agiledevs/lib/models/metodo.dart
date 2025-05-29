class Metodo {
  final int id;
  final String title;
  final String description;
  final String image;
  final int likes;
  final String folder;

  Metodo({
    required this.id,
    required this.title,
    required this.description, 
    required this.image,
    required this.likes,
    required this.folder,
  });

  factory Metodo.fromJson(Map<String, dynamic> json) {
    return Metodo(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      image: json['image'] ?? 'lib/data/images/method.png',
      likes: json['likes'] as int,
      folder: json['folder'] as String,
    );
  }
}