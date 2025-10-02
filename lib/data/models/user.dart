class User {
  final String id;
  final String name;
  final String email;
  final String position;
  final String department;
  final String? photoUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.position,
    required this.department,
    this.photoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      position: json['position'] as String,
      department: json['department'] as String,
      photoUrl: json['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'position': position,
      'department': department,
      'photoUrl': photoUrl,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? position,
    String? department,
    String? photoUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      position: position ?? this.position,
      department: department ?? this.department,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
