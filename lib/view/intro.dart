import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:learn_english/view/login.dart';
import 'package:learn_english/view/register.dart';

import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';

void main() {
  runApp(const Intro());
}

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              color: Colors.white,
            ),
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50,
                          child: Transform.scale(
                              scale: 0.8,
                              child: const Image(
                                image: AssetImage('assets/logo.png'),
                                color: Colors.deepPurpleAccent,
                                filterQuality: FilterQuality.high,
                              )),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: PageView(
                      scrollDirection: Axis.horizontal,
                      controller: _pageController,
                      onPageChanged: (value) {
                        Timer(const Duration(milliseconds: 30), () {
                          setState(() {
                            _currentPage = value;
                          });
                        });
                      },
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: Container(
                                margin:
                                const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                height: 250,
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    image:
                                    AssetImage('assets/intro_image1.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                              child: const Text(
                                'Hơn 90% học sinh sử dụng Fluentz cho biết họ đã cải thiện kỹ năng tiếng Anh.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 25),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Expanded(
                              child: Container(
                                margin:
                                const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                height: 250,
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    image:
                                    AssetImage('assets/intro_image2.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                              child: const Text(
                                'Tùy chỉnh thẻ ghi nhớ cá nhân hóa phù hợp với nhu cầu học của bạn.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 25),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Expanded(
                              child: Container(
                                margin:
                                const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                height: 250,
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    image:
                                    AssetImage('assets/intro_image3.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                              child: const Text(
                                'Chinh phục tiếng Anh sẽ trở nên dễ dàng và hiệu quả hơn bao giờ hết.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 25),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Expanded(
                              child: Container(
                                margin:
                                const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                height: 250,
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    image:
                                    AssetImage('assets/intro_image4.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                              child: const Text(
                                'Khám phá ứng dụng giúp bạn học tiếng Anh một cách linh hoạt và hiệu quả.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 25),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: DotsIndicator(
                            dotsCount: 4,
                            position: _currentPage,
                            decorator: const DotsDecorator(
                              size: Size.square(8),
                              activeSize: Size.square(8),
                              activeColor: Colors.deepPurpleAccent,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Register(),
                                  ));
                            },
                            style: ButtonStyle(
                              backgroundColor: const MaterialStatePropertyAll(
                                  Colors.deepPurpleAccent),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              minimumSize: const MaterialStatePropertyAll(
                                Size(double.infinity, 60),
                              ),
                            ),
                            child: const Text(
                              'Đăng ký miễn phí',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Login()));
                            },
                            style: ButtonStyle(
                              backgroundColor:
                              const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  )),
                              minimumSize: const MaterialStatePropertyAll(
                                  Size(double.infinity, 60)),
                            ),
                            child: const Text(
                              'Hoặc đăng nhập',
                              style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
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
    );
  }
}
