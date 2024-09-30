import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = 'http://localhost:5002';

  static Future<Map<String, dynamic>> loginUser(
      String email, String password) async {
    Map<String, dynamic> user = {};

    try {
      final client = http.Client();

      final response = await client.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Origin': 'http://localhost:5002', // Remplacez par votre domaine
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        user = json.decode(response.body);
      } else {
        throw Exception('Échec de la connexion');
      }

      client.close();
    } catch (error) {
      throw Exception('Erreur lors de la connexion: $error');
    }

    return user;
  }
}
