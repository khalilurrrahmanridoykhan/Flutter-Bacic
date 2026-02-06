import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final String company;
  final String city;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.company,
    required this.city,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      website: json['website'] ?? '',
      company: json['company']?['name'] ?? '',
      city: json['address']?['city'] ?? '',
    );
  }
}

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late Future<List<User>> _futureUsers;

  @override
  void initState() {
    super.initState();

    // Try to load cached users first (synchronous) and then refresh from network.
    final box = Hive.box('usersBox');
    final cachedJson = box.get('usersJson') as String?;
    print('Loaded cached users JSON: $cachedJson');

    if (cachedJson != null) {
      try {
        final List data = jsonDecode(cachedJson) as List;
        final cachedUsers =
            data.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
        // show cached immediately
        _futureUsers = Future.value(cachedUsers);
        // also refresh in background
        fetchUsers().then((fresh) {
          setState(() {
            _futureUsers = Future.value(fresh);
          });
        }).catchError((_) {});
      } catch (e) {
        // parsing cache failed, fallback to network
        _futureUsers = fetchUsers();
      }
    } else {
      _futureUsers = fetchUsers();
    }
  }

  Future<List<User>> fetchUsers({bool useBrowserUA = false}) async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/users');
    final headers = <String, String>{
      'Accept': 'application/json',
      if (useBrowserUA)
        'User-Agent':
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36',
    };

    try {
      final resp = await http.get(url, headers: headers);
      // Diagnostic logs
      // ignore: avoid_print
      print('GET $url -> ${resp.statusCode}');
      // ignore: avoid_print
      print('Response body: ${resp.body}');

      if (resp.statusCode == 200) {
        final List data = jsonDecode(resp.body) as List;
        final users = data
            .map((e) => User.fromJson(e as Map<String, dynamic>))
            .toList();

        // Cache raw JSON string in Hive for quick load later
        final box = Hive.box('usersBox');
        await box.put('usersJson', resp.body);
        await box.put('usersFetchedAt', DateTime.now().toIso8601String());

        return users;
      } else {
        throw Exception('Failed to load users: ${resp.statusCode}\nBody: ${resp.body}');
      }
    } catch (e) {
      // include the exception message for debugging
      throw Exception('Failed to fetch users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: FutureBuilder<List<User>>(
        future: _futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Error: ${snapshot.error}'),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          // Retry using default headers first; change to useBrowserUA: true to try different UA if needed
                          _futureUsers = fetchUsers();
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // Retry with a browser-like User-Agent header to test server behavior
                          _futureUsers = fetchUsers(useBrowserUA: true);
                        });
                      },
                      child: const Text('Retry with Browser UA'),
                    ),
                  ],
                ),
              ),
            );
          }

          final users = snapshot.data ?? [];
          return RefreshIndicator(
            onRefresh: () async {
              final fresh = await fetchUsers();
              setState(() {
                _futureUsers = Future.value(fresh);
              });
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: users.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.hardEdge,
                  elevation: 2,
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(user.name),
                    subtitle: Text('${user.email}\n${user.city}'),
                    isThreeLine: true,
                    trailing: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Tapped ${user.name}')),
                        );
                      },
                      child: const Text('Tap'),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
