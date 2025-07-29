class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String contactNo;
  final String profilePic;
  final String company;
  final String city;
  final String email;
  final String? ccEmail;
  final String state;
  final String pincode;
  final String address;
  final int status;
  final int userFlowLimit;
  final int manualSettings;

  UserModel({
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
    required this.status,
    required this.userFlowLimit,
    required this.manualSettings,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      contactNo: json['contact_no'],
      profilePic: json['profile_pic'],
      company: json['company'],
      city: json['city'],
      email: json['email'],
      ccEmail: json['cc_email'],
      state: json['state'],
      pincode: json['pincode'],
      address: json['address'],
      status: json['status'],
      userFlowLimit: json['user_flow_limit'],
      manualSettings: json['manual_settings'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'contact_no': contactNo,
      'profile_pic': profilePic,
      'company': company,
      'city': city,
      'email': email,
      'cc_email': ccEmail,
      'state': state,
      'pincode': pincode,
      'address': address,
      'status': status,
      'user_flow_limit': userFlowLimit,
      'manual_settings': manualSettings,
    };
  }
}
