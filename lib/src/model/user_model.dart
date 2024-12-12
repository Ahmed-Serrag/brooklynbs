class UserModel {
  String name;
  String stID;
  String email;
  String phone;
  String ppURL;

  UserModel({
    required this.name,
    required this.stID,
    required this.email,
    required this.phone,
    required this.ppURL,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // final attributes = json['attributes'] ?? {};

    return UserModel(
      name: json['name'] ?? 'Unknown Name',
      stID: json['stID'] ?? 'Unknown stID',
      email: json['email'] ?? 'unknown@example.com',
      phone: json['phone'] ?? 'No phone',
      ppURL: json['ppURL'] ?? 'No image URL',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'ppURL': ppURL,
      'stID': stID,
      'phone': phone,
    };
  }
}
