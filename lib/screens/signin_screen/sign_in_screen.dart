import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talenta_adminnn/services/user_service.dart';
import 'package:talenta_adminnn/utilities/routes.dart';
import 'package:talenta_adminnn/providers/user_provider.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String email = '';
    String password = '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Container(
        color: Colors.blueGrey[100],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  email = value;
                },
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () async {
                  Map<String, dynamic> result =
                      await UserService.loginUser(email, password);

                  if (result['success']) {
                    print('Connexion réussie !');

                    String? userId = result['userId'];
                    String? userEmail = result['userEmail'];
                    String? userRole = result['userRole'];
                    String? userPassword = result['userPassword'];

                    if (userId != null &&
                        userEmail != null &&
                        userRole != null &&
                        userPassword != null) {
                      Provider.of<UserProvider>(context, listen: false)
                          .setUserData(
                              userId, userEmail, userRole, userPassword);

                      // Print user information
                      print('User ID: $userId');
                      print('User Email: $userEmail');
                      print('User Role: $userRole');
                      print('User Password: $userPassword');

                      if (userRole == 'admin') {
                        Navigator.pushReplacementNamed(
                            context, dashboardAdminRoute);
                      } else {
                        // Handle redirection for other roles if needed
                      }
                    } else {
                      print('User information is missing.');
                    }
                  } else {
                    print('Login failed. Message: ${result['message']}');
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text(
                  'Sign In',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, YourFrontendRoute);
                },
                child: Text('Forgot Password?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
