// models/post.dart
class Post {
  final String id;
  final String title;
  final String body;
  
  Post({
    required this.id,
    required this.title,
    required this.body,
  });
  
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
    };
  }
  
  @override
  String toString() {
    return 'Post{id: $id, title: $title, body: $body}';
  }

  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Post &&
      other.id == id &&
      other.title == title &&
      other.body == body;
  }
  
  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ body.hashCode;
  }}