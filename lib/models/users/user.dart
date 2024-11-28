class User {
  final int userId;
  late final String email;
  late final String password;
  late final bool isTeacher;

  User({
    required this.userId,
    required this.email,
    required this.password,
    required this.isTeacher,
  });

  factory User.fromMap(Map<dynamic, dynamic> map) {
    return User(
      userId: map['userId'],
      email: map['email'],
      password: map['password'],
      isTeacher: map['isTeacher'],
    );
  }
  Map <String,dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'password': password,
      'isTeacher': isTeacher,
    };
  }
}
