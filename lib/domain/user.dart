class User {
  final String? id;
  final String? name;
  final String? bio;
  final String? fileImage;

//<editor-fold desc="Data Methods">
  const User({
    this.id,
    this.name,
    this.bio,
    this.fileImage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          bio == other.bio &&
          fileImage == other.fileImage);

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ bio.hashCode ^ fileImage.hashCode;

  @override
  String toString() {
    return 'User{' +
        ' id: $id,' +
        ' name: $name,' +
        ' bio: $bio,' +
        ' file_image: $fileImage,' +
        '}';
  }

  User copyWith({
    String? id,
    String? name,
    String? bio,
    String? fileImage,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      fileImage: fileImage ?? this.fileImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'bio': this.bio,
      'file_image': this.fileImage,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      bio: map['bio'] != null ? map['bio'] as String : null,
      fileImage: map['file_image'] != null ? map['file_image'] as String : null,
    );
  }

//</editor-fold>
}
