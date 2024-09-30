import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String userId = '';
  String userEmail = '';
  String userRole = '';
  String userPassword = ''; // Ajout du champ de mot de passe

  void setUserData(String id, String email, String role, String password) {
    userId = id;
    userEmail = email;
    userRole = role;
    userPassword = password; // Mettez à jour le champ de mot de passe
    notifyListeners();
  }

  void updateUserEmail(String newEmail) {
    userEmail = newEmail;
    notifyListeners();
  }

  void updateUserRole(String newRole) {
    userRole = newRole;
    notifyListeners();
  }

  void updateUserPassword(String newPassword) {
    userPassword = newPassword;
    notifyListeners();
  }
}
