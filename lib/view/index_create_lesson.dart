import 'package:flutter/material.dart';

void main() {
  runApp(const IndexCreateLesson());
}

class IndexCreateLesson extends StatefulWidget {
  const IndexCreateLesson({super.key});

  @override
  State<IndexCreateLesson> createState() => _IndexCreateLessonState();
}

class _IndexCreateLessonState extends State<IndexCreateLesson> {
  String _selectedOptionLanguage1 = 'Chọn ngôn ngữ';
  String _selectedOptionLanguage2 = 'Chọn ngôn ngữ';

  final ScrollController _scrollController = ScrollController();

  List<DropdownMenuItem<String>> dropdownItemsLanguage1 = <String>[
    'Chọn ngôn ngữ',
    'Vietnam',
    'Laos',
    'Cambodia',
    'Thailand',
    'Singapore'
  ].map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();

  List<DropdownMenuItem<String>> dropdownItemsLanguage2 = <String>[
    'Chọn ngôn ngữ',
    'Vietnam',
    'Laos',
    'Cambodia',
    'Thailand',
    'Singapore'
  ].map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();

  List<Widget> listItem = [];

  Widget _buildItem() {
    return Container(
      key: UniqueKey(),
      margin: const EdgeInsets.all(5),
      color: Colors.white,
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          color: Colors.red,
          child: const Padding(
            padding: EdgeInsets.only(right: 100),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
        onDismissed: (direction) {
          setState(() {
            listItem.removeWhere(
                (element) => element.key == Key(direction.index.toString()));
          });
        },
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: const TextField(
                      decoration: InputDecoration(),
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
                    child: Text('Thuật ngữ'),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: const TextField(),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(5, 0, 0, 15),
                  child: const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Định nghĩa'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    listItem.add(_buildItem());
  }

  void _addItem() {
    setState(() {
      listItem.add(_buildItem());
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _onDoneTap() {
    ;
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
            'Tạo học phần',
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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              Container(
                color: const Color.fromRGBO(240, 240, 240, 1.0),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
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
                                          margin: const EdgeInsets.fromLTRB(
                                              5, 0, 5, 0),
                                          child: const TextField(
                                            decoration: InputDecoration(
                                              hintText:
                                                  'Chủ đề, chương, đơn vị ...',
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            5, 0, 0, 0),
                                        child: const Align(
                                          alignment: Alignment.topLeft,
                                          child: Text('Tiêu đề'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              5, 0, 5, 0),
                                          child: const TextField(
                                            decoration: InputDecoration(
                                              hintText: 'Mô tả học phần ...',
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            5, 0, 0, 15),
                                        child: const Align(
                                          alignment: Alignment.topLeft,
                                          child: Text('Mô tả'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              margin: const EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: DropdownButtonFormField<String>(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      value: _selectedOptionLanguage1,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _selectedOptionLanguage1 = newValue!;
                                        });
                                      },
                                      items: dropdownItemsLanguage1,
                                      validator: (value) {
                                        if (_selectedOptionLanguage1 ==
                                            dropdownItemsLanguage1
                                                .first.value) {
                                          return 'Please choose a language!';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    child: const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text('Thuật ngữ'),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: DropdownButtonFormField<String>(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      value: _selectedOptionLanguage2,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _selectedOptionLanguage2 = newValue!;
                                        });
                                      },
                                      items: dropdownItemsLanguage2,
                                      validator: (value) {
                                        if (_selectedOptionLanguage2 ==
                                            dropdownItemsLanguage2
                                                .first.value) {
                                          return 'Please choose a language!';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(5, 0, 0, 15),
                                    child: const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text('Định nghĩa'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ...listItem,
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: ElevatedButton(
                                onPressed: _addItem,
                                style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.deepPurpleAccent),
                                ),
                                child: const Text('Thêm',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
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
      ),
    );
  }
}
