class UserModel {
  final int id;
  final String name;
  final String stID;
  final String email;
  final String phone;
  final List<String> phones;
  final String ppURL;
  final String company;
  final String grade;
  final String idNumber;
  final String birthDate;
  final String marketingCode;

  UserModel({
    required this.id,
    required this.name,
    required this.stID,
    required this.email,
    required this.phone,
    required this.phones,
    required this.ppURL,
    required this.idNumber,
    required this.birthDate,
    required this.marketingCode,
    required this.company,
    required this.grade,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final studentData =
        json.containsKey('student') ? json['student'] : json['data'];

    if (studentData == null) {
      throw Exception("❌ student data is null in JSON response!");
    }

    final List<String> phoneList =
        List<String>.from(studentData['phones'] ?? []);

    return UserModel(
      id: studentData['id'],
      name: studentData['name'] ?? 'Unknown Name',
      stID: studentData['st_num']?.toString() ?? 'Unknown stID',
      email: studentData['email'] ?? 'unknown@example.com',
      phones: phoneList,
      phone: phoneList.isNotEmpty ? phoneList[0] : 'No phone',
      ppURL: studentData['ppUrl'] ??
          "https://st2.depositphotos.com/1531183/5770/v/950/depositphotos_57709697-stock-illustration-male-person-silhouette-profile-picture.jpg",
      company: studentData['company'] ?? '',
      grade: studentData['grade'] ?? '',
      idNumber: studentData['ID_number'] ?? '',
      birthDate: studentData['birth_date'] ?? '',
      marketingCode: studentData['marketing_code'] ?? '',
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
      'phones': phones,
    };
  }
}
