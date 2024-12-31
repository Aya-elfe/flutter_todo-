// File: lib/models/user.dart
class User {
  final int id;
  final String username;
  final String email;
  final String? name;
  final String? photoUrl;
  final Map<String, dynamic>? preferences;

  const User({
    required this.id,
    required this.username,
    required this.email,
    this.name,
    this.photoUrl,
    this.preferences,
  });

  User copyWith({
    String? name,
    String? photoUrl,
    Map<String, dynamic>? preferences,
  }) {
    return User(
      id: id,
      username: username,
      email: email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      preferences: preferences ?? this.preferences,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      photoUrl: json['photoUrl'] as String?,
      preferences: json['preferences'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'preferences': preferences,
    };
  }

  @override
  String toString() => 'User(id: $id, username: $username, email: $email)';
}