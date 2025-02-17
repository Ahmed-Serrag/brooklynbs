class UserModel {
  final String name;
  final String stID;
  final String email;
  final String phone; // Primary phone (first number in list)
  final List<String> phones; // Store all phone numbers
  final String ppURL;

  UserModel({
    required this.name,
    required this.stID,
    required this.email,
    required this.phone,
    required this.phones,
    required this.ppURL,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print("🟢 Raw JSON Received: $json"); // Debugging line

    // Correctly extract the student data from the response
    final studentData = json['student'];

    if (studentData == null) {
      throw Exception("❌ student data is null in JSON response!");
    }

    // Directly use the 'phones' field without conversion
    final List<String> phoneList =
        List<String>.from(studentData['phones'] ?? []);

    return UserModel(
      name: studentData['name'] ?? 'Unknown Name',
      stID: studentData['st_num']?.toString() ??
          'Unknown stID', // Convert int to string if needed
      email: studentData['email'] ?? 'unknown@example.com',
      phones: phoneList, // Store the list of phones
      phone: phoneList.isNotEmpty
          ? phoneList[0]
          : 'No phone', // Use the first phone or default to 'No phone'
      ppURL: studentData['ppUrl'] ??
          "https://st2.depositphotos.com/1531183/5770/v/950/depositphotos_57709697-stock-illustration-male-person-silhouette-profile-picture.jpg",
    );
  }

  @override
  String toString() {
    return 'UserModel{ name: $name, st_num: $stID, email: $email, phones: $phones}';
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'ppURL': ppURL,
      'stID': stID,
      'phone': phone,
      'phones': phones, // Store all phones in case needed later
    };
  }
}
