class User {
  String id;
  String name;
  String email;
  String telephone;
  List<String> roles;

  User({
    this.id,
    this.name,
    this.email,
    this.telephone,
    this.roles,
  });

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
