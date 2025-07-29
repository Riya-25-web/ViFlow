import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:v_scada/models/UserProfileModel.dart';

import '../Networking/ApiConstants.dart';
import '../Networking/api_client.dart';
import '../Networking/api_service.dart';
import 'package:v_scada/theme_provider.dart';


class AccountProfilePage extends StatefulWidget {
  final String userId;
  final VoidCallback? onBackToHome;

  const AccountProfilePage({required this.userId, this.onBackToHome});


  @override
  _AccountProfilePageState createState() => _AccountProfilePageState();
}

class _AccountProfilePageState extends State<AccountProfilePage> {
  final ApiService apiService = ApiService(apiClient: ApiClient());

  late Future<UserProfileModel> futureUser;
  bool isEditMode = false;

  // Controllers for Edit Form
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final companyController = TextEditingController();
  final contactNoController = TextEditingController();
  final emailController = TextEditingController();

  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }



  @override
  void initState() {
    super.initState();
    futureUser = apiService.getUserprofileData(widget.userId);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    companyController.dispose();
    contactNoController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _switchToEdit(UserProfileModel user) {
    setState(() {
      isEditMode = true;
      firstNameController.text = user.data.firstName;
      lastNameController.text = user.data.lastName;
      companyController.text = user.data.company;
      contactNoController.text = user.data.contactNo;
      emailController.text = user.data.email;
    });
  }

  void _switchToView() {
    setState(() {
      isEditMode = false;
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final updateData = {
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "company": companyController.text,
        "contact_no": contactNoController.text,
        "email": emailController.text,
      };

      print("Updating profile with data: $updateData");

      try {
        final success = await apiService.updateUserProfileData(widget.userId, updateData,_selectedImage);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile updated successfully")),
          );

          // Reload user data
          setState(() {
            futureUser = apiService.getUserprofileData(widget.userId);
            isEditMode = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to update profile")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating profile: $e")),
        );
      }
    }
  }

  Widget _buildProfileView(UserProfileModel user) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            elevation: 2,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 55),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // CircleAvatar(
                  //   radius: 28,
                  //   backgroundImage: AssetImage('assets/logo2.png'),
                  //   backgroundColor: Colors.transparent,
                  //   child: Image.asset(
                  //     'assets/logo2.png',
                  //     fit: BoxFit.cover,
                  //     errorBuilder: (context, error, stackTrace) {
                  //       return const Icon(Icons.account_circle, size: 56, color: Colors.grey);
                  //     },
                  //   ),
                  // ),

                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    backgroundImage: NetworkImage(
                      user.data.profilePic.isNotEmpty
                          ? "http://visioncgwa.com/"+user.data.profilePic
                          : "http://visioncgwa.com/"+user.data.profilePic
                    ),
                    onBackgroundImageError: (_, __) {
                      // Fallback logic handled below by child
                    },
                    child: user.data.profilePic.isEmpty
                        ? const Icon(
                      Icons.account_circle,
                      size: 56,
                      color: Colors.grey,
                    )
                        : null, // hide child if image loaded from network
                  ),

                  const SizedBox(height: 8),
                  const Text(
                    "Profile",
                    style: TextStyle(
                      color: Color(0xFF7B8FA1),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${user.data.firstName} ${user.data.lastName}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF25396F),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Details Card
          Card(
            elevation: 1,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tab-like Row
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _switchToView(),
                        child: Column(
                          children: [
                            Text(
                              "Profile Details",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              height: 2,
                              width: 40,
                              color: Colors.grey,
                              margin: const EdgeInsets.only(top: 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      GestureDetector(
                        onTap: () => _switchToEdit(user),
                        child: Text(
                          "Edit Profile",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 28, thickness: 1),
                  // Full Name
                  const SizedBox(height: 6),
                  const Text(
                    "Full Name",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7B8FA1),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${user.data.firstName} ${user.data.lastName}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF25396F),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Company
                  const Text(
                    "Company",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7B8FA1),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.data.company,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF25396F),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Role
                  const Text(
                    "Role",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7B8FA1),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "User",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF25396F),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Phone
                  const Text(
                    "Phone",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7B8FA1),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.data.contactNo,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF25396F),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Email
                  const Text(
                    "Email",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7B8FA1),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.data.email,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF25396F),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 50, 5, 5),
            child: Text(
              '© 2025 Copyright Vision World Tech PVT.LTD. All Rights Reserved. Designed & Developed by Vision World Tech PVT.LTD.',
              textAlign: TextAlign.center,
              style:  TextStyle(
                fontSize: 12,
                fontFamily: 'sans-serif',
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileEdit(UserProfileModel user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 55),
                child: Column(
                  children: [
                    // CircleAvatar(
                    //   radius: 28,
                    //   backgroundImage: AssetImage('assets/logo2.png'),
                    //   backgroundColor: Colors.transparent,
                    // ),
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.transparent,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!) // local image file
                            : NetworkImage("http://visioncgwa.com/" + user.data.profilePic) as ImageProvider,
                      ),
                    ),





                    const SizedBox(height: 8),
                    const Text(
                      "Edit Profile",
                      style: TextStyle(
                        color: Color(0xFF7B8FA1),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${firstNameController.text} ${lastNameController.text}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF25396F),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 1,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tab-like Row
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _switchToView,
                          child: Text(
                            "Profile Details",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: [
                              Text(
                                "Edit Profile",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Container(
                                height: 2,
                                width: 40,
                                color: Colors.grey[600],
                                margin: const EdgeInsets.only(top: 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 28, thickness: 1),

                    // First Name
                    const Text(
                      "First Name",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7B8FA1),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: firstNameController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "First Name",
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter first name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    // Last Name
                    const Text(
                      "Last Name",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7B8FA1),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: lastNameController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Last Name",
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter last name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    // Company
                    const Text(
                      "Company",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7B8FA1),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: companyController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Company",
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter company';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    // Contact No
                    const Text(
                      "Phone",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7B8FA1),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: contactNoController,
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "Phone Number",
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter phone number';
                        }
                        if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(value)) {
                          return 'Please enter valid phone number';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    // Email
                    const Text(
                      "Email",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7B8FA1),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: emailController,
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter valid email';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // ElevatedButton(
                    //   onPressed: _saveProfile,
                    //   style: ElevatedButton.styleFrom(
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(16),
                    //     ),
                    //     backgroundColor: Theme.of(context).primaryColor,
                    //   ),
                    //   child: const Padding(
                    //     padding: EdgeInsets.symmetric(horizontal: 70, vertical: 12),
                    //     child: Text(
                    //       "Save",
                    //       style: TextStyle(
                    //         fontWeight: FontWeight.w700,
                    //         fontSize: 16,
                    //       ),
                    //     ),
                    //   ),
                    // ),


                    Center(
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: Color(0xFF8CCDFD),
                          minimumSize: const Size(150, 48),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 50, 5, 5),
              child: Text(
                '© 2025 Copyright Vision World Tech PVT.LTD. All Rights Reserved. Designed & Developed by Vision World Tech PVT.LTD.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'sans-serif',
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),

        // child: Column(
        //   children: [
        //     GestureDetector(
        //       onTap: _pickImage,
        //       child: CircleAvatar(
        //         radius: 28,
        //         backgroundColor: Colors.transparent,
        //         backgroundImage: _selectedImage != null
        //             ? FileImage(_selectedImage!)
        //             : AssetImage('assets/logo2.png') as ImageProvider,
        //       ),
        //     ),
        //     const SizedBox(height: 8),
        //     const Text(
        //       "Edit Profile",
        //       style: TextStyle(
        //         color: Color(0xFF7B8FA1),
        //         fontSize: 16,
        //       ),
        //     ),
        //     const SizedBox(height: 8),
        //     Text(
        //       "${firstNameController.text} ${lastNameController.text}",
        //       style: const TextStyle(
        //         fontSize: 24,
        //         fontWeight: FontWeight.bold,
        //         color: Color(0xFF25396F),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       // title: const Text("Profile"),
  //     ),
  //     body: FutureBuilder<UserProfileModel>(
  //       future: futureUser,
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Center(child: CircularProgressIndicator());
  //         } else if (snapshot.hasError) {
  //           return Center(child: Text("Error loading profile: ${snapshot.error}"));
  //         } else if (!snapshot.hasData) {
  //           return const Center(child: Text("No profile data found."));
  //         } else {
  //           final user = snapshot.data!;
  //           return isEditMode ? _buildProfileEdit(user) : _buildProfileView(user);
  //         }
  //       },
  //     ),
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // // You can add a title or buttons here if needed
        // title: Text(isEditMode ? 'Edit Profile' : 'Profile'),
        // actions: [
        //   // Example: Toggle edit mode button
        //   // IconButton(
        //   //   icon: Icon(isEditMode ? Icons.check : Icons.edit),
        //   //   onPressed: () {
        //   //     setState(() {
        //   //       isEditMode = !isEditMode;
        //   //     });
        //   //   },
        //   // ),
        // ],
      ),
      body: FutureBuilder<UserProfileModel>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error loading profile:\n${snapshot.error}",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No profile data found."));
          } else {
            final user = snapshot.data!;
            return isEditMode ? _buildProfileEdit(user) : _buildProfileView(user);
          }
        },
      ),
    );
  }

}


