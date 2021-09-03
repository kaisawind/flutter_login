class User {
  String id;
  String name;
  String email;
  String telephone;
  List<String> roles;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.telephone,
    required this.roles,
  });

  @override
  String toString() {
    return 'User: {id: $id, name: $name, email: $email, telephone: $telephone}';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    List<String> items = [];
    json['roles'].forEach((f) => items.add(f));
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      telephone: json['telephone'],
      roles: items,
    );
  }
}
