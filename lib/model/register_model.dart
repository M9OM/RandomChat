class Register {
  String? username;
  String? email;
  String? userId;

  Register(
      {this.username,
      this.email,
      this.userId});

  factory Register.fromFireStore(Map<String, dynamic> json) {
    return Register(
      username: json['username'],
      email: json['email'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toFireStore() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['email'] = email;
    data['userId'] = userId;

    return data;
  }
}
