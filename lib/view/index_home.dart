import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'flashcard.dart';

void main() {
  runApp(const IndexHome());
}

class IndexHome extends StatefulWidget {
  const IndexHome({super.key});

  @override
  State<IndexHome> createState() => _IndexHomeState();
}

class Folder {
  final int id;
  final int idAccount;
  final String name;

  Folder({required this.id, required this.idAccount, required this.name});

  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      id: int.parse(json['id_folder']),
      idAccount: int.parse(json['id_account']),
      name: json['name_folders'],
    );
  }
}

class Topic {
  final int id;
  final int folderId;
  final String name;

  Topic({required this.id, required this.folderId, required this.name});

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: int.parse(json['id_topic']),
      folderId: int.parse(json['id_folder']),
      name: json['name_topics'],
    );
  }
}

class Vocabulary {
  final int id;
  final int topicId;
  final String engVocabulary;
  final String vnVocabulary;

  Vocabulary({required this.id, required this.topicId, required this.engVocabulary, required this.vnVocabulary});

  factory Vocabulary.fromJson(Map<String, dynamic> json) {
    return Vocabulary(
      id: int.parse(json['id_vocabulary']),
      topicId: int.parse(json['id_topic']),
      engVocabulary: json['eng_vocabulary'],
      vnVocabulary: json['vn_vocabulary'],
    );
  }
}

class _IndexHomeState extends State<IndexHome> {
  late Future<List<Folder>> folders;
  List<Topic> topics = [];
  List<Vocabulary> vocabularies = [];

  @override
  void initState() {
    super.initState();
    folders = fetchFolders();
  }

  Future<List<Folder>> fetchFolders() async {
    final response = await http.get(Uri.parse('http://192.168.1.8/api_learn_english/index.php?type=folders'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map<Folder>((folder) => Folder.fromJson(folder)).toList();
    } else {
      throw Exception('Failed to load folders');
    }
  }

  Future<void> fetchTopics(int folderId) async {
    final response = await http.get(Uri.parse('http://192.168.1.8/api_learn_english/index.php?type=topics&id_folder=$folderId'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      setState(() {
        topics = jsonResponse.map<Topic>((topic) => Topic.fromJson(topic)).toList();
        vocabularies = []; // Clear vocabularies when a new folder is selected
      });
    } else {
      throw Exception('Failed to load topics');
    }
  }

  Future<void> fetchVocabularies(int topicId) async {
    final response = await http.get(Uri.parse('http://192.168.1.8/api_learn_english/index.php?type=vocabulary&id_topic=$topicId'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      setState(() {
        vocabularies = jsonResponse.map<Vocabulary>((vocabulary) => Vocabulary.fromJson(vocabulary)).toList();
      });
    } else {
      throw Exception('Failed to load vocabularies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height - 111.143),
            child: Stack(
              children: [
                Container(
                  color: const Color.fromRGBO(240, 240, 240, 1.0),
                ),
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.deepPurpleAccent,
                      floating: false,
                      pinned: true,
                      flexibleSpace: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(10, 12, 10, 12),
                            child: Image(
                              image: AssetImage('assets/logo.png'),
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Colors.yellowAccent),
                              ),
                              child: const Text(
                                'Dùng thử miễn phí',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Icon(
                              Icons.notifications_none,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverAppBar(
                      toolbarHeight: 80,
                      backgroundColor: Colors.deepPurpleAccent,
                      pinned: true,
                      flexibleSpace: Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Tìm kiếm...',
                              contentPadding: const EdgeInsets.only(right: 40),
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverAppBar(
                      backgroundColor: const Color.fromRGBO(240, 240, 240, 1.0),
                      pinned: true,
                      flexibleSpace: ClipPath(
                        clipper: MiddleCurveClipper(),
                        child: Container(
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return FutureBuilder<List<Folder>>(
                            future: folders,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text("Error: ${snapshot.error}"));
                              } else if (snapshot.hasData) {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: const Text(
                                              'Các thư mục',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          5, 0, 0, 28),
                                      color: const Color.fromRGBO(
                                          240, 240, 240, 1.0),
                                      height: 130,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          Folder folder = snapshot.data![index];
                                          return GestureDetector(
                                            onTap: () {
                                              fetchTopics(folder.id);
                                            },
                                            child: Container(
                                              width: 320,
                                              margin: const EdgeInsets.all(5.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: const Color.fromRGBO(
                                                        200, 200, 200, 1.0),
                                                    width: 1),
                                                color: Colors.white,
                                              ),
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 30),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const Icon(Icons
                                                                .folder_open),
                                                            const SizedBox(
                                                                width: 10),
                                                            Text(folder.name,
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                          ],
                                                        ),
                                                        Container(
                                                          height: 30,
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                            child: Text(
                                                              '${folder.idAccount} học phần',
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                  13),
                                                            ),
                                                          ),
                                                          decoration:
                                                          BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                20),
                                                            color: const Color
                                                                .fromRGBO(
                                                                200,
                                                                150,
                                                                250,
                                                                0.5),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                          EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: Text('Các học phần',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          5, 0, 0, 28),
                                      color: const Color.fromRGBO(
                                          240, 240, 240, 1.0),
                                      height: 130,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: topics.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          Topic topic = topics[index];
                                          return GestureDetector(
                                            onTap: () {
                                              fetchVocabularies(topic.id);
                                            },
                                            child: Container(
                                              width: 320,
                                              margin: const EdgeInsets.all(5.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: const Color.fromRGBO(
                                                        200, 200, 200, 1.0),
                                                    width: 1),
                                                color: Colors.white,
                                              ),
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 30),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const Icon(Icons
                                                                .library_books_outlined),
                                                            const SizedBox(
                                                                width: 10),
                                                            Text(topic.name,
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                          ],
                                                        ),
                                                        Container(
                                                          height: 30,
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                            child: const Text(
                                                              '0 thuật ngữ',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  13),
                                                            ),
                                                          ),
                                                          decoration:
                                                          BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                20),
                                                            color: const Color
                                                                .fromRGBO(
                                                                200,
                                                                150,
                                                                250,
                                                                0.5),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                          EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: Text('Thuật ngữ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          5, 0, 0, 28),
                                      color: const Color.fromRGBO(
                                          240, 240, 240, 1.0),
                                      height: 130,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: vocabularies.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          Vocabulary vocabulary =
                                          vocabularies[index];
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => FlashcardScreen(vocabulary: vocabulary),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: 320,
                                              margin: const EdgeInsets.all(5.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: const Color.fromRGBO(
                                                        200, 200, 200, 1.0),
                                                    width: 1),
                                                color: Colors.white,
                                              ),
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 30),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const Icon(Icons
                                                                .translate),
                                                            const SizedBox(
                                                                width: 10),
                                                            Text(
                                                                vocabulary
                                                                    .engVocabulary,
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                          ],
                                                        ),
                                                        Container(
                                                          height: 30,
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                            child: Text(
                                                              vocabulary
                                                                  .vnVocabulary,
                                                              style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                  13),
                                                            ),
                                                          ),
                                                          decoration:
                                                          BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                            color: const Color
                                                                .fromRGBO(
                                                                200,
                                                                150,
                                                                250,
                                                                0.5),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return const Center(child: Text("No data found"));
                              }
                            },
                          );
                        },
                        childCount: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MiddleCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final midPoint = size.width / 2;

    path.lineTo(0, 0);

    path.quadraticBezierTo(midPoint, size.height, size.width, 0);

    path.lineTo(size.width, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
