class User {
  final String? id;
  final String? firstname;
  final String? lastname;
  final String? phoneNumber;
  final String? username;
  final String? email;
  final String? userProfileUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    this.email,
    this.userProfileUrl,
    this.firstname,
    this.lastname,
    this.phoneNumber,
    this.username,
    this.createdAt,
    this.updatedAt,
  });

  User.fromJson(Map<String, dynamic> data, String id)
      : id = id,
        firstname = data['firstname'],
        lastname = data['lastname'],
        phoneNumber = data['phoneNumber'],
        username = data['username'],
        email = data['email'],
        userProfileUrl = data['userProfileUrl'],
        createdAt = data['createdAt'],
        updatedAt = data['updatedAt'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'phoneNumber': phoneNumber,
      'username': username,
      'email': email,
      'userProfileUrl': userProfileUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
