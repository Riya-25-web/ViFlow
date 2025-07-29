import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_scada/main.dart';
import 'package:v_scada/networking/api_client.dart';
import 'package:v_scada/networking/api_service.dart';
import 'package:v_scada/utils/shared_prefs_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService(apiClient: ApiClient());

  bool rememberMe = false;
  bool isCredentialsValid = false;
  bool isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool isEmailValid(String email) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailRegex.hasMatch(email);
  }

  void handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (!isEmailValid(email) || password.isEmpty) {
      setState(() => isCredentialsValid = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid email and password')),
      );
      return;
    }

    try {
      final response = await apiService.loginUser(email, password);
      print('Login API Response: $response');

      if (response['token'] != null && response['user'] != null) {
        final userStatus = response['user']['status'];
        if (userStatus == 1) {
          setState(() => isCredentialsValid = true);

          await SharedPrefsHelper.setString('token', response['token']);
          await SharedPrefsHelper.setString('user_name', response['user']['first_name']);
          await SharedPrefsHelper.setString('user_id', response['user']['id'].toString());
          await SharedPrefsHelper.setString('email', response['user']['email']);
          await SharedPrefsHelper.setString('contact_no', response['user']['contact_no']);
          await SharedPrefsHelper.setString('profile_pic', response['user']['profile_pic']);
          await SharedPrefsHelper.setString('company', response['user']['company']);
          await SharedPrefsHelper.setString('city', response['user']['city']);
          await SharedPrefsHelper.setString('state', response['user']['state']);
          await SharedPrefsHelper.setString('pincode', response['user']['pincode']);
          await SharedPrefsHelper.setString('address', response['user']['address']);
          await SharedPrefsHelper.setString('status', response['user']['status'].toString());
          await SharedPrefsHelper.setString('user_flow_limit', response['user']['user_flow_limit'].toString());
          await SharedPrefsHelper.setString('manual_settings', response['user']['manual_settings'].toString());

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
          );
          return;
        } else {
          setState(() => isCredentialsValid = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not active.')),
          );
        }
      } else {
        setState(() => isCredentialsValid = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login failed")),
        );
      }
    } catch (e) {
      setState(() => isCredentialsValid = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/logo2.png',
                width: 350,
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Customer Login',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFF012970),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Enter your username & password to login',
              style: TextStyle(fontSize: 16, color: Color(0xFF444444)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Email', style: TextStyle(fontSize: 18, color: Color(0xFF444444))),
            ),
            const SizedBox(height: 10),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: emailController,
                  style: TextStyle(color: Colors.black),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.grey[100],
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                if (isCredentialsValid)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: Colors.green),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Password', style: TextStyle(fontSize: 18, color: Color(0xFF444444))),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              style: TextStyle(color: Colors.black),
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                hintText: 'Enter your password',
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.grey[100],
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: rememberMe,
                  onChanged: (val) {
                    setState(() {
                      rememberMe = val ?? false;
                    });
                  },
                ),
                const Text("Remember me", style: TextStyle(color: Color(0xFF444444))),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: handleLogin,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Center(
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: TextButton(
            //     onPressed: () {
            //       // Forgot password action
            //     },
            //     // child: const Text(
            //     //   "Forgot Your Password?",
            //     //   style: TextStyle(
            //     //     fontSize: 16,
            //     //     color: Colors.redAccent,
            //     //     decoration: TextDecoration.underline,
            //     //   ),
            //     // ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
