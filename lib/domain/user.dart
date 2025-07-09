class User {
  final String? id;
  final String? name;
  final String? bio;

//<editor-fold desc="Data Methods">
  const User({
    this.id,
    this.name,
    this.bio,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          bio == other.bio);

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ bio.hashCode;

  @override
  String toString() {
    return 'User{' ' id: $id,' ' name: $name,' ' bio: $bio,' '}';
  }

  User copyWith({
    String? id,
    String? name,
    String? bio,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      bio: map['bio'] != null ? map['bio'] as String : null,
    );
  }

//</editor-fold>
}
