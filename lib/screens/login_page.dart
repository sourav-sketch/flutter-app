import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  // Icon for toggling password visibility
  Icon _passwordVisibilityIcon = Icon(Icons.visibility_off);

  // Flag to toggle password visibility
  bool _isPasswordVisible = false;

  // Method to toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
      _passwordVisibilityIcon =
      _isPasswordVisible ? Icon(Icons.visibility) : Icon(Icons.visibility_off);
    });
  }

  Future<void> _login() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final String apiUrl = 'https://reqres.in/api/login';
    final Map<String, dynamic> loginData = {
      'email': emailController.text,
      'password': passwordController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(loginData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Login successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // Login failed
        setState(() {
          isLoading = false;
          errorMessage = 'Invalid email or password';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to connect to the server';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20.0),
            // Image above login text
            Image.asset(
              'assets/images/login.png',
              height: 200,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20.0),
            Text(
              'Login',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15.0),
            // Icon before email field
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email ID',
                prefixIcon: Icon(Icons.email), // Icon added here
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
              ),
            ),
            SizedBox(height: 10.0),
            // Icon before password field
            TextFormField(
              controller: passwordController,
              obscureText: !_isPasswordVisible, // Toggle password visibility
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock), // Icon added here
                suffixIcon: IconButton(
                  icon: _passwordVisibilityIcon,
                  onPressed: _togglePasswordVisibility, // Toggle password visibility on icon press
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
            ),
            //oooiiii

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Navigate to forgot password page
                      },
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //SizedBox(height: 10.0),
            SizedBox(height: 10.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'New to logistics? ',
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to registration page
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
