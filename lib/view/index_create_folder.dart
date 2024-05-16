import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const IndexCreateFolder());
}

class IndexCreateFolder extends StatefulWidget {
  const IndexCreateFolder({super.key});

  @override
  State<IndexCreateFolder> createState() => _IndexCreateFolderState();
}

class _IndexCreateFolderState extends State<IndexCreateFolder> {
  final TextEditingController _nameController = TextEditingController();

  Future<void> _createFolder() async {
    final response = await http.post(
      Uri.parse('http://192.168.1.8/api_learn_english/addfolder.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name_folders': _nameController.text,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Folder created successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create folder: ${jsonResponse['message']}')),
        );
      }
    } else {
      throw Exception('Failed to create folder');
    }
  }

  void _onDoneTap() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a folder name')),
      );
    } else {
      _createFolder();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          title: const Text(
            'Tạo thư mục',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: InkWell(
                onTap: _onDoneTap,
                child: const Text(
                  'Lưu',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
              color: const Color.fromRGBO(240, 240, 240, 1.0),
            ),
            SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(5),
                            color: Colors.white,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        child: TextField(
                                          controller: _nameController,
                                          decoration: const InputDecoration(
                                            hintText: 'Tên thư mục ...',
                                            floatingLabelBehavior: FloatingLabelBehavior.always,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      child: const Align(
                                        alignment: Alignment.topLeft,
                                        child: Text('Tên thư mục'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
