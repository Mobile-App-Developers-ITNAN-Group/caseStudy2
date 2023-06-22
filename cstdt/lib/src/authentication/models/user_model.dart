class userModel {
  final String username;
  final String name;
  final String password;

  const UserModel({
    required this.username,
    required this.name,
    required this.password,
  });

  toJson() {
    return {
      'username': username,
      'name': name,
      'password': password,
    };
  }
}
