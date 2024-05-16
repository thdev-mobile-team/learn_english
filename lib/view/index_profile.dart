import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserInfo {
  final String username;
  final String email;
  final String password;

  UserInfo({required this.username, required this.email, required this.password});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      username: json['username'],
      email: json['email'],
      password: json['password'],
    );
  }
}

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<UserInfo> userInfo;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userInfo = fetchUserInfo();
  }

  Future<UserInfo> fetchUserInfo() async {
    final response = await http.get(Uri.parse('http://192.168.1.8/api_learn_english/profile.php'));

    if (response.statusCode == 200) {
      return UserInfo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user info');
    }
  }

  Future<void> updateUserInfo(String username, String currentPassword, String newPassword) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.8/api_learn_english/profile.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User information updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update user information: ${jsonResponse['message']}')),
        );
      }
    } else {
      throw Exception('Failed to update user info');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: FutureBuilder<UserInfo>(
        future: userInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            _usernameController.text = snapshot.data!.username;

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage('https://i.pinimg.com/474x/dd/05/9e/dd059ef402eabd1f5c01b9024010011b.jpg'),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _currentPasswordController,
                      decoration: InputDecoration(labelText: 'Current Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your current password';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _newPasswordController,
                      decoration: InputDecoration(labelText: 'New Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a new password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          updateUserInfo(_usernameController.text, _currentPasswordController.text, _newPasswordController.text);
                        }
                      },
                      child: Text('Update'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('No user data found'));
          }
        },
      ),
    );
  }
}
