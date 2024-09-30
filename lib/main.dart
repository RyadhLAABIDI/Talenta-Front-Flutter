import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talenta_adminnn/providers/user_provider.dart';
import 'package:talenta_adminnn/screens/dashboard/update_profil_screen.dart';
import 'package:talenta_adminnn/screens/dashboard_screen.dart';
import 'package:talenta_adminnn/screens/signin_screen/sign_in_screen.dart'; // Utilisation de l'alias SignInScreen
import 'package:talenta_adminnn/screens/signin_screen/reset_password_screen.dart';
import 'package:talenta_adminnn/screens/dashboard/user_screen.dart';
import 'package:talenta_adminnn/screens/dashboard/talent_screen.dart';
import 'package:talenta_adminnn/screens/dashboard/admin_profil_screen.dart';
import 'package:talenta_adminnn/utilities/routes.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Votre Application',
      initialRoute: signInRoute,
      routes: {
        signInRoute: (context) =>
            SignInScreen(), // Utilisation de l'alias SignInScreen
        dashboardAdminRoute: (context) => DashboardScreen(),
        YourFrontendRoute: (context) => YourFrontendScreen(),
        interface1Route: (context) => UserScreen(),
        interface2Route: (context) => TalentScreen(),
        profilAdminRoute: (context) => ProfilAdminScreen(),
        updateProfileRoute: (context) =>
            UpdateProfilScreen(), // Ajoutez cette ligne
      },
    );
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}
