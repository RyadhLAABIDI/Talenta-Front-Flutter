import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:talenta_adminnn/providers/user_provider.dart';
import 'dart:convert';

class UpdateProfilScreen extends StatefulWidget {
  @override
  _UpdateProfilScreenState createState() => _UpdateProfilScreenState();
}

class _UpdateProfilScreenState extends State<UpdateProfilScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _roleController = TextEditingController();
  TextEditingController _passwordController =
      TextEditingController(); // Nouveau contrôleur pour le mot de passe

  @override
  void initState() {
    super.initState();
    _emailController.text =
        Provider.of<UserProvider>(context, listen: false).userEmail;
    _roleController.text =
        Provider.of<UserProvider>(context, listen: false).userRole;
    _passwordController.text =
        Provider.of<UserProvider>(context, listen: false).userPassword;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _roleController.dispose();
    _passwordController.dispose(); // Disposer du contrôleur du mot de passe
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier mon profil'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextFormField(
              controller: _roleController,
              decoration: InputDecoration(
                labelText: 'Rôle',
              ),
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true, // Pour masquer le mot de passe
              decoration: InputDecoration(
                labelText: 'Nouveau mot de passe',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String newEmail = _emailController.text;
                String newRole = _roleController.text;
                String newPassword = _passwordController.text;

                userProvider.updateUserEmail(newEmail);
                userProvider.updateUserRole(newRole);
                userProvider.updateUserPassword(newPassword);

                await updateProfil(
                    userProvider.userId, newEmail, newRole, newPassword);

                Navigator.pop(context);
              },
              child: Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateProfil(String userId, String newEmail, String newRole,
      String newPassword) async {
    String url = 'http://localhost:5002/admin/updateProfilById/$userId';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    Map<String, String> body = {
      'email': newEmail,
      'role': newRole,
      'password': newPassword, // Ajouter le mot de passe au corps de la requête
    };

    try {
      var response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        print('Profil mis à jour avec succès');
        print('Nouvel email : $newEmail');
        print('Nouveau rôle : $newRole');
        print('Nouveau password : $newPassword');
      } else {
        print(
            'Erreur lors de la mise à jour du profil: ${response.statusCode}');
      }
    } catch (error) {
      print('Erreur lors de la requête HTTP: $error');
    }
  }
}
