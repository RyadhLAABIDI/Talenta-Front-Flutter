import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:talenta_adminnn/utilities/routes.dart';
import 'package:intl/intl.dart';

class UserStatistics {
  final String category;
  final int count;
  final charts.Color color;

  UserStatistics(this.category, this.count, this.color);
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int userCount = 0;
  int talentCount = 0;
  int totalUserCount = 0;
  double percentageTalents = 0.0;
  double percentageUsers = 0.0;
  List<UserStatistics> chartData = [];
  int userBannedCount = 0;
  int talentBannedCount = 0;
  double appUsageRate = 0.0;
  int activeUserCount = 0;
  DateTime appUsageRateDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchStatistics();
    fetchStatisticPrct();
    fetchBannedUsersStatistics();
    fetchAppUsageRate();
  }

  Future<void> fetchStatistics() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:5002/statistics/statistic'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userCount = data['userCount'];
          talentCount = data['talentCount'];
        });
      } else {
        print(
            'Failed to fetch statistics. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching statistics: $error');
    }
  }

  Future<void> fetchStatisticPrct() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:5002/statistics/statisti'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userCount = data['userCount'];
          talentCount = data['talentCount'];
          totalUserCount = data['totalUserCount'];
          percentageTalents = data['percentageTalents'].toDouble();
          percentageUsers = data['percentageUsers'].toDouble();

          chartData = [
            UserStatistics('Pourcentage de TALENTS', percentageTalents.toInt(),
                charts.Color.fromHex(code: '#0715DC')),
            UserStatistics('Pourcentage de USERS', percentageUsers.toInt(),
                charts.Color.fromHex(code: '#0715DC')),
          ];
        });
      } else {
        print(
            'Failed to fetch statistics. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching statistics: $error');
    }
  }

  Future<void> fetchBannedUsersStatistics() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:5002/statistics/stat'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userBannedCount = data['userBannedCount'];
          talentBannedCount = data['talentBannedCount'];
        });
      } else {
        print(
            'Failed to fetch banned users statistics. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching banned users statistics: $error');
    }
  }

  Future<void> fetchAppUsageRate() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:5002/statistics/statAppUsageRate'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          appUsageRate = data['appUsageRate'].toDouble();
          activeUserCount = data['activeUserCount'];
          appUsageRateDate = DateTime.parse(data['date']);
        });
      } else {
        print(
            'Failed to fetch app usage rate. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching app usage rate: $error');
    }
  }

  Future<List<UserStatistics>> fetchUsageRateData() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:5002/statistics/statAppUsageRate'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final appUsageRate = data['appUsageRate'].toDouble();
        final activeUserCount = data['activeUserCount'];

        // Remplacez ces valeurs fictives par vos données réelles
        final usageRateData = [
          UserStatistics('Lundi', 20, charts.Color.fromHex(code: '#0715DC')),
          UserStatistics('Mardi', 30, charts.Color.fromHex(code: '#0715DC')),
          UserStatistics('Mercredi', 25, charts.Color.fromHex(code: '#0715DC')),
          // Ajoutez plus de points de données au besoin
        ];

        return usageRateData;
      } else {
        print(
            'Failed to fetch usage rate data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching usage rate data: $error');
    }
    return []; // Retourne une liste vide en cas d'erreur.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DASHBOARD ADMIN', style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color.fromARGB(255, 114, 46, 14),
      ),
      backgroundColor: Colors.black,
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 114, 46, 14),
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'DASHBOARD ADMIN',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Accueil'),
              onTap: () {
                Navigator.pushNamed(context, '/dashboard-screen');
              },
              hoverColor: Color.fromARGB(255, 255, 114, 46),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Interface Utilisateur'),
              onTap: () {
                Navigator.pushNamed(context, '/user');
              },
              hoverColor: Color.fromARGB(255, 255, 114, 46),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Interface Talent'),
              onTap: () {
                Navigator.pushNamed(context, '/talent');
              },
              hoverColor: Color.fromARGB(255, 255, 114, 46),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profil Administrateur'),
              onTap: () {
                Navigator.pushNamed(context, '/admin-profile');
              },
              hoverColor: Color.fromARGB(255, 255, 114, 46),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Déconnexion'),
              onTap: () {
                _performLogout(context);
              },
              hoverColor: Color.fromARGB(255, 255, 114, 46),
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: Color.fromARGB(255, 114, 46, 14),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Bienvenue dans le tableau de bord administrateur',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard(
                    'Statistiques Utilisateurs',
                    userCount,
                    Color.fromARGB(159, 7, 21, 220),
                    'Nombre d\'utilisateurs avec le rôle "user"',
                  ),
                  _buildStatCard(
                    'Statistiques Talents',
                    talentCount,
                    Color.fromARGB(159, 7, 21, 220),
                    'Nombre d\'utilisateurs avec le rôle "talent"',
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Nombre total d\'utilisateurs bannis: $userBannedCount',
                style: TextStyle(
                  color: const Color.fromARGB(159, 7, 21, 220),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Nombre total de talents bannis: $talentBannedCount',
                style: TextStyle(
                  color: const Color.fromARGB(159, 7, 21, 220),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              _buildChart(),
              SizedBox(height: 20),
              Text(
                'Nombre total d\'utilisateurs: $totalUserCount',
                style: TextStyle(
                  color: const Color.fromARGB(159, 7, 21, 220),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Pourcentage de TALENTS: $percentageTalents%',
                style: TextStyle(
                  color: const Color.fromARGB(159, 7, 21, 220),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Pourcentage de USERS: $percentageUsers%',
                style: TextStyle(
                  color: const Color.fromARGB(159, 7, 21, 220),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Nombre d\'utilisateurs avec le rôle "user": $userCount',
                style: TextStyle(
                  color: const Color.fromARGB(159, 7, 21, 220),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Nombre d\'utilisateurs avec le rôle "talent": $talentCount',
                style: TextStyle(
                  color: const Color.fromARGB(159, 7, 21, 220),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Nombre d\'utilisateurs actifs au cours des derniers jours: $activeUserCount', // Affichage du nombre d'utilisateurs actifs
                style: TextStyle(
                  color: const Color.fromARGB(159, 7, 21, 220),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Taux d\'utilisation de l\'application: $appUsageRate%',
                style: TextStyle(
                  color: const Color.fromARGB(159, 7, 21, 220),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Date: ${DateFormat('yyyy-MM-dd').format(appUsageRateDate)}',
                style: TextStyle(
                  color: const Color.fromARGB(159, 7, 21, 220),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildUsageRateChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsageRateChart() {
    return SizedBox(
      width: 500,
      height: 300,
      child: charts.LineChart(
        _createUsageRateData(),
        animate: true,
      ),
    );
  }

  List<charts.Series<UserStatistics, int>> _createUsageRateData() {
    final data = [
      UserStatistics('Lundi', 20, charts.Color.fromHex(code: '#0715DC')),
      UserStatistics('Mardi', 30, charts.Color.fromHex(code: '#0715DC')),
      UserStatistics('Mercredi', 25, charts.Color.fromHex(code: '#0715DC')),
      // Ajoutez plus de points de données au besoin
    ];

    return [
      charts.Series<UserStatistics, int>(
        id: 'usageRate',
        domainFn: (UserStatistics stats, _) => stats.count,
        measureFn: (UserStatistics stats, _) => stats.count,
        colorFn: (UserStatistics stats, _) => stats.color,
        data: data,
      ),
    ];
  }

  Widget _buildChart() {
    return SizedBox(
      width: 500,
      height: 300,
      child: charts.BarChart(
        [
          charts.Series<UserStatistics, String>(
            id: 'statistics',
            domainFn: (UserStatistics stats, _) => stats.category,
            measureFn: (UserStatistics stats, _) => stats.count,
            colorFn: (UserStatistics stats, _) => stats.color,
            data: chartData,
          ),
        ],
        animate: true,
        vertical: true,
      ),
    );
  }

  Widget _buildAnimatedCounter(int count) {
    return AnimatedTextKit(
      animatedTexts: [
        TyperAnimatedText(
          '$count',
          textStyle: TextStyle(
            fontSize: 50.0,
            fontWeight: FontWeight.bold,
          ),
          speed: Duration(milliseconds: 100),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, int count, Color? color, String message) {
    return Card(
      color: color ?? Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 250,
              height: 250,
              child: _buildAnimatedCounter(count),
            ),
            Text(message),
          ],
        ),
      ),
    );
  }

  void _performLogout(BuildContext context) async {
    try {
      var uri = Uri.parse('http://localhost:5002/auth/logout');
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        print('Déconnexion réussie');
        Navigator.pushNamedAndRemoveUntil(
            context, signInRoute, (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la déconnexion'),
          ),
        );
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }
}
