import 'dart:async';
import 'dart:convert';
import 'index.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const Login());
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _tfState = '';
  bool _isEmailError = false;
  bool _isPasswordError = false;
  bool _isObscureText = true;
  bool _isSubmited = false;

  final _formState = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _buttonRegFocusNode = FocusNode();

  void _updateTFState(FocusNode focusNode) {
    focusNode.addListener(() {
      setState(() {
        if (focusNode.hasFocus) {
          if (focusNode == _emailFocusNode) {
            _tfState = '1';
          } else if (focusNode == _passwordFocusNode) {
            _tfState = '2';
          } else if (focusNode == _buttonRegFocusNode) {
            _tfState = 'none';
          }
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _updateTFState(_emailFocusNode);
    _updateTFState(_passwordFocusNode);
    _updateTFState(_buttonRegFocusNode);
  }

  Future<void> _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    final response = await http.post(
      Uri.parse('http://192.168.1.8/api_learn_english/login.php'),
      body: jsonEncode({'email': email, 'password': password}), // Update key name to 'email'
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        // Navigate to the Home screen upon successful login
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Index()),
        );
      } else {
        // Display error message if login fails
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(data['message']),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      // Show dialog for connection error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to connect to server'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }

    setState(() {
      _isSubmited = false; // Hide the loading indicator after login attempt
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Đăng nhập Fluentz',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.deepPurpleAccent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formState,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onTap: () {
                          setState(() {
                            _tfState = '1';
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            if (!value!.endsWith('@gmail.com')) {
                              _isEmailError = true;
                            } else {
                              _isEmailError = false;
                            }
                          });
                        },
                        validator: (value) {
                          if (!value!.endsWith('@gmail.com')) {
                            return 'Email không hợp lệ!';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          setState(() {
                            _tfState = '2';
                            FocusScope.of(context)
                                .requestFocus(_passwordFocusNode);
                          });
                        },
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Nhập email của bạn',
                          prefixIcon: const Icon(Icons.email),
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.blue, width: 2.0)),
                          labelStyle: () {
                            if (_tfState == '1' && _isEmailError == false) {
                              return const TextStyle(color: Colors.blue);
                            } else if (_isEmailError == true) {
                              return const TextStyle(color: Colors.red);
                            } else {
                              return null;
                            }
                          }(),
                          prefixIconColor: () {
                            if (_tfState == '1' && _isEmailError == false) {
                              return Colors.blue;
                            } else if (_isEmailError == true) {
                              return Colors.red;
                            } else {
                              return null;
                            }
                          }(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onTap: () {
                          setState(() {
                            _tfState = '2';
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            if (value!.length < 6) {
                              _isPasswordError = true;
                            } else {
                              _isPasswordError = false;
                            }
                          });
                        },
                        validator: (value) {
                          if (value!.length < 6) {
                            return 'Mật khẩu phải có ít nhất 6 ký tự!';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          setState(() {
                            _tfState = 'none';
                            FocusScope.of(context)
                                .requestFocus(_buttonRegFocusNode);
                          });
                        },
                        obscureText: _isObscureText,
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu',
                          hintText: 'Nhập mật khẩu của bạn',
                          prefixIcon: const Icon(Icons.password),
                          suffixIcon: IconButton(
                            icon: Icon(_isObscureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _isObscureText = !_isObscureText;
                              });
                            },
                          ),
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.blue, width: 2.0)),
                          labelStyle: () {
                            if (_tfState == '2' &&
                                _isPasswordError == false) {
                              return const TextStyle(color: Colors.blue);
                            } else if (_isPasswordError == true) {
                              return const TextStyle(color: Colors.red);
                            } else {
                              return null;
                            }
                          }(),
                          prefixIconColor: () {
                            if (_tfState == '2' &&
                                _isPasswordError == false) {
                              return Colors.blue;
                            } else if (_isPasswordError == true) {
                              return Colors.red;
                            } else {
                              return null;
                            }
                          }(),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                      ),
                    ),
                    const Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              'Bằng việc đăng nhập, bạn chấp thuận',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: 'Điều khoản dịch vụ ',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            print('Đã bấm ĐKDV');
                                          }),
                                    const TextSpan(
                                      text: 'và ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    ),
                                    TextSpan(
                                        text: 'Chính sách quyền riêng tư ',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            print('Đã bấm CSQRT');
                                          }),
                                    const TextSpan(
                                      text: 'của Fluentz',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                      child: Builder(builder: (context2) {
                        return Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  print("Email: ${_emailController.text}");
                                  print(
                                      "Password: ${_passwordController.text}");
                                  setState(() {
                                    _isSubmited = true;
                                  });

                                  _login().then((_) {
                                    setState(() {
                                      _isSubmited = false;
                                    });
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                  const MaterialStatePropertyAll(
                                      Colors.deepPurpleAccent),
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(5.0))),
                                  minimumSize: const MaterialStatePropertyAll(
                                      Size(double.infinity, 60)),
                                ),
                                child: const Text('Đăng nhập',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(15, 0, 5, 15),
                            child: const Divider(
                              color: Colors.grey,
                              height: 1,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            color: Colors.white,
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                            child: const Center(
                              child: Expanded(
                                child: Text(
                                  'Đăng nhập nhanh bằng',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(5, 0, 15, 15),
                            child: const Divider(
                              color: Colors.grey,
                              height: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  ;
                                },
                                focusNode: _passwordFocusNode,
                                style: ButtonStyle(
                                  backgroundColor:
                                  const MaterialStatePropertyAll(
                                      Colors.white),
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        side: const BorderSide(
                                            color: Colors.grey, width: 2),
                                      )),
                                  minimumSize: const MaterialStatePropertyAll(
                                      Size(double.infinity, 60)),
                                ),
                                child: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset('assets/icon_google.png',
                                            width: 20),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'Tiếp tục với Google',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.deepPurpleAccent),
                                        )
                                      ],
                                    ))),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  ;
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                  const MaterialStatePropertyAll(
                                      Colors.white),
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        side: const BorderSide(
                                            color: Colors.grey, width: 2),
                                      )),
                                  minimumSize: const MaterialStatePropertyAll(
                                      Size(double.infinity, 60)),
                                ),
                                child: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset('assets/icon_facebook.png',
                                            width: 20),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'Tiếp tục với Facebook',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.deepPurpleAccent),
                                        )
                                      ],
                                    ))),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // if (_isSubmited)
            //   Container(
            //     color: const Color.fromRGBO(255, 255, 255, 0.8),
            //     child: const Center(
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           CircularProgressIndicator(
            //             color: Colors.blue,
            //           ),
            //           SizedBox(height: 30),
            //           Text(
            //             'Connecting to backend server ...',
            //             style: TextStyle(color: Colors.blue, fontSize: 18),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
