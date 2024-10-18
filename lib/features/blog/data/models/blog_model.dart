import 'package:blog_app/features/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.authorId,
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.tags,
    required super.updatedAt,
    super.posterEmail,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['id'],
      authorId: json['author_id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      tags: List<String>.from(json['tags']),
      updatedAt: DateTime.parse(json['updated_at']),
      posterEmail: json['profiles']?['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author_id': authorId,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'tags': tags,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
