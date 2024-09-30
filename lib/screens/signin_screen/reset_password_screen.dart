import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:talenta_adminnn/utilities/routes.dart';
import 'package:talenta_adminnn/screens/signin_screen/sign_in_screen.dart';

class YourFrontendScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  Future<Map<String, dynamic>> addOtp(String email) async {
    final url = Uri.parse('http://localhost:5002/otp/add');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 201) {
      final otp = response.body;
      return {'success': true, 'otp': otp};
    } else {
      print('Erreur : ${response.statusCode}');
      return {'success': false, 'error': 'Failed to send OTP'};
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String otp) async {
    final url = Uri.parse('http://localhost:5002/otp/verify');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'otp': otp}),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'message': 'OTP verified successfully'};
    } else {
      print('Erreur : ${response.statusCode}');
      return {'success': false, 'error': 'Failed to verify OTP'};
    }
  }

  Future<List<dynamic>> getAllOtp() async {
    final url = Uri.parse('http://localhost:5002/otp/all');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final otpList = json.decode(response.body);
      return otpList;
    } else {
      print('Erreur : ${response.statusCode}');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Frontend Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final response = await addOtp(emailController.text);

                if (response['success']) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('OTP Sent'),
                        content: Text(
                            'OTP has been sent successfully to ${emailController.text}.'),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);

                              // Ajoutez ici la logique de navigation pour passer à l'étape suivante
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OtpVerificationScreen(
                                    email: emailController.text,
                                  ),
                                ),
                              );
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Failed to send OTP. Please try again.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}

class OtpVerificationScreen extends StatelessWidget {
  final String email;

  OtpVerificationScreen({required this.email});

  final TextEditingController otpController = TextEditingController();

  Future<void> verifyOtpAndNavigate(BuildContext context) async {
    final response = await YourFrontendScreen().verifyOtp(otpController.text);

    if (response['success']) {
      // Ajoutez ici la logique de navigation pour passer à l'étape suivante (par exemple, SignInScreen)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignInScreen(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to verify OTP. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter the OTP sent to $email'),
            SizedBox(height: 16.0),
            TextField(
              controller: otpController,
              decoration: InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await verifyOtpAndNavigate(context);
              },
              child: Text('Verify OTP and Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: YourFrontendScreen(),
  ));
}
