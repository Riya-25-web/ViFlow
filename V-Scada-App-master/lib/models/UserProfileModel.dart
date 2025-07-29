class UserProfileModel {
  final bool status;
  final UserData data;

  UserProfileModel({required this.status, required this.data});

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      status: json['status'] ?? false, // Top-level boolean
      data: UserData.fromJson(json['data'] ?? {}),
    );
  }
}

class UserData {
  final int id;
  final String firstName;
  final String lastName;
  final String contactNo;
  final String profilePic;
  final String company;
  final String city;
  final String email;
  final String ccEmail;
  final String state;
  final String pincode;
  final String address;
  final String? emailVerifiedAt;
  final int status; // This is INT inside "data"
  final int userFlowLimit;
  final int manualSettings;
  final int? rolesId;
  final String createdAt;
  final String updatedAt;

  UserData({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.contactNo,
    required this.profilePic,
    required this.company,
    required this.city,
    required this.email,
    required this.ccEmail,
    required this.state,
    required this.pincode,
    required this.address,
    this.emailVerifiedAt,
    required this.status,
    required this.userFlowLimit,
    required this.manualSettings,
    this.rolesId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    // Debug log the "data" object to ensure you're not using top-level keys
    print("🔍 UserData JSON: $json");

    return UserData(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      contactNo: json['contact_no'] ?? '',
      profilePic: json['profile_pic'] ?? '',
      company: json['company'] ?? '',
      city: json['city'] ?? '',
      email: json['email'] ?? '',
      ccEmail: json['cc_email'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      address: json['address'] ?? '',
      emailVerifiedAt: json['email_verified_at'],
      status: json['status'] is int ? json['status'] : int.tryParse(json['status'].toString()) ?? 0, // FIX HERE
      userFlowLimit: json['user_flow_limit'] ?? 0,
      manualSettings: json['manual_settings'] ?? 0,
      rolesId: json['roles_id'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
