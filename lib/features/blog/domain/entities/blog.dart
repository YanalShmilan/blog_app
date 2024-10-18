class Blog {
  final String id;
  final String authorId;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> tags;
  final DateTime updatedAt;
  final String? posterEmail;

  Blog({
    required this.id,
    required this.authorId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.tags,
    required this.updatedAt,
    this.posterEmail,
  });
}
