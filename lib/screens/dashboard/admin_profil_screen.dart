import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talenta_adminnn/providers/user_provider.dart';
//import 'package:talenta_adminnn/screens/dashboard/update_profil_screen.dart';

class ProfilAdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    String userId = userProvider.userId;
    String userEmail = userProvider.userEmail;
    String userRole = userProvider.userRole;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(
            255, 114, 46, 14), // Couleur de fond de l'AppBar
        title: Text(
          'Profil Admin',
          style: TextStyle(
            color: const Color.fromARGB(
                255, 6, 6, 6), // Couleur du texte de l'AppBar
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 10, 1, 1),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: Colors.blue,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Profil de l\'administrateur',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Couleur du texte en noir
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Card(
              color: Colors.blue, // Couleur de fond de la Card
              child: ListTile(
                title: Text('ID de l\'utilisateur connecté'),
                subtitle: Text(userId),
              ),
            ),
            Card(
              color: Colors.blue,
              child: ListTile(
                title: Text('Email de l\'utilisateur connecté'),
                subtitle: Text(userEmail),
              ),
            ),
            Card(
              color: Colors.blue,
              child: ListTile(
                title: Text('Mot de passe de l\'utilisateur connecté'),
                subtitle: Text(
                    '******'), // Remplacez par le mot de passe réel si nécessaire
              ),
            ),
            Card(
              color: Colors.blue,
              child: ListTile(
                title: Text('Rôle de l\'utilisateur connecté'),
                subtitle: Text(userRole),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Naviguer vers l'écran de modification du profil
                Navigator.pushNamed(context, '/update_profile');
              },
              child: Text('Modifier mes informations'),
            ),
          ],
        ),
      ),
    );
  }
}
