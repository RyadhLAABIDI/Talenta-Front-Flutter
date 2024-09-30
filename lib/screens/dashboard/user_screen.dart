import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talenta_adminnn/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen>
    with SingleTickerProviderStateMixin {
  List<User> users = [];
  List<User> filteredUsers = [];
  bool _isAscending = true;
  late SharedPreferences _prefs;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initPrefs();
    _fetchUsers();

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    );

    // Create the animation
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start the animation after a delay of 500 milliseconds
    Timer(Duration(milliseconds: 500), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _fetchUsers() async {
    try {
      var response =
          await http.get(Uri.parse('http://localhost:5002/admin/getAllUser'));
      if (response.statusCode == 200) {
        var responseBody = response.body;
        if (responseBody != null) {
          var data = jsonDecode(responseBody);
          List<dynamic> userList = data['results'];

          List<User> fetchedUsers = userList
              .map((user) => User.fromJson(user))
              .where((user) => user.role == 'user')
              .toList();

          setState(() {
            users = fetchedUsers;
            filteredUsers = fetchedUsers;
          });

          _restoreBannedState();
        } else {
          print('La réponse de la requête est null');
        }
      } else {
        print(
            'Erreur lors de la récupération des utilisateurs: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
    }
  }

  Future<void> _restoreBannedState() async {
    for (var user in users) {
      bool isBanned = _prefs.getBool(user.email) ?? false;
      if (isBanned) {
        setState(() {
          user.banned = true;
        });
      }
    }
  }

  Future<void> _saveBannedState(String userEmail, bool isBanned) async {
    await _prefs.setBool(userEmail, isBanned);
  }

  Future<void> banUser(String userEmail) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5002/admin/ban/$userEmail'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Utilisateur banni avec succès');
        setState(() {
          final userIndex = users.indexWhere((user) => user.email == userEmail);
          if (userIndex != -1) {
            users[userIndex].banned = true;
            _saveBannedState(userEmail, true);
            _showBanMessage(userEmail); // Affiche le message de bannissement
          }
        });
      } else if (response.statusCode == 404) {
        print('Utilisateur non trouvé');
      } else {
        print(
            'Erreur lors du bannissement de l\'utilisateur: ${response.statusCode}');
      }
    } catch (error) {
      print('Erreur lors du bannissement de l\'utilisateur: $error');
    }
  }

  void _showBanMessage(String userEmail) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('L\'utilisateur $userEmail a été banni'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  DataColumn _buildDataColumn(String label) {
    return DataColumn(
      label: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.orange,
          fontSize: 16.0,
        ),
      ),
    );
  }

  void _sortUsers() {
    setState(() {
      if (_isAscending) {
        filteredUsers.sort((a, b) => a.email.compareTo(b.email));
      } else {
        filteredUsers.sort((a, b) => b.email.compareTo(a.email));
      }
      _isAscending = !_isAscending;
    });
  }

  void searchUsers(String query) {
    List<User> searchResults = users
        .where((user) => user.email.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredUsers = searchResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 114, 46, 14),
        title: TextField(
          onChanged: (value) {
            searchUsers(value);
          },
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Rechercher par Email',
            hintStyle: TextStyle(color: Colors.white70),
            prefixIcon: Icon(Icons.search, color: Colors.white),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                // Clear the search field
                searchUsers('');
              },
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Animated button
            AnimatedBuilder(
              animation: _animation,
              builder: (BuildContext context, Widget? child) {
                return Opacity(
                  opacity: _animation.value,
                  child: Transform.translate(
                    offset: Offset(0.0, 100.0 * (1.0 - _animation.value)),
                    child: child,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _sortUsers,
                  child: Text(
                    'Trier par email',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                  ),
                ),
              ),
            ),

            // Animated card
            AnimatedBuilder(
              animation: _animation,
              builder: (BuildContext context, Widget? child) {
                return Opacity(
                  opacity: _animation.value,
                  child: Transform.translate(
                    offset: Offset(0.0, 100.0 * (1.0 - _animation.value)),
                    child: child,
                  ),
                );
              },
              child: Card(
                color: Colors.grey[900],
                margin: EdgeInsets.all(16),
                child: DataTable(
                  headingTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  dataTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                  columns: [
                    _buildDataColumn('Email'),
                    _buildDataColumn('Rôle'),
                    _buildDataColumn('Bannir'),
                    _buildDataColumn('Statut'),
                  ],
                  rows: filteredUsers.map((user) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: user.banned
                                  ? Colors.red
                                  : Color.fromARGB(255, 4, 29, 170),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              user.email,
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 5, 137, 203),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              user.role,
                            ),
                          ),
                        ),
                        DataCell(
                          ElevatedButton(
                            onPressed: () {
                              banUser(user.email);
                            },
                            child: Text('Bannir'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                            ),
                          ),
                        ),
                        DataCell(
                          user.banned
                              ? Icon(Icons.warning, color: Colors.yellow)
                              : Container(),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
