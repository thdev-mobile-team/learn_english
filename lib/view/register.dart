import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'index.dart';
void main() {
  runApp(const Register());
}

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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

  Future<void> _register() async {
    final response = await http.post(
      Uri.parse('http://192.168.1.8/api_learn_english/register.php'), // Update this URL to your backend server
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == 'success') {
      //   // Registration successful
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: const Text('Registration successful'),
      //     duration: const Duration(seconds: 2),
      //   ));
      // } else {
      //   // Registration failed
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text(responseData['message']),
      //     duration: const Duration(seconds: 2),
      //   ));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Index()),
        );
      }
    } else {
      // Server error
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Server error, please try again later'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Đăng ký Fluentz',
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
                            if (!value.endsWith('@gmail.com')) {
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
                            FocusScope.of(context).requestFocus(_passwordFocusNode);
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
                            borderSide: BorderSide(color: Colors.blue, width: 2.0),
                          ),
                          labelStyle: () {
                            if (_tfState == '1' && !_isEmailError) {
                              return const TextStyle(color: Colors.blue);
                            } else if (_isEmailError) {
                              return const TextStyle(color: Colors.red);
                            } else {
                              return null;
                            }
                          }(),
                          prefixIconColor: () {
                            if (_tfState == '1' && !_isEmailError) {
                              return Colors.blue;
                            } else if (_isEmailError) {
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
                            if (value.length < 6) {
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
                            FocusScope.of(context).requestFocus(_buttonRegFocusNode);
                          });
                        },
                        obscureText: _isObscureText,
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu',
                          hintText: 'Tạo mật khẩu của bạn',
                          prefixIcon: const Icon(Icons.password),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscureText ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscureText = !_isObscureText;
                              });
                            },
                          ),
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2.0),
                          ),
                          labelStyle: () {
                            if (_tfState == '2' && !_isPasswordError) {
                              return const TextStyle(color: Colors.blue);
                            } else if (_isPasswordError) {
                              return const TextStyle(color: Colors.red);
                            } else {
                              return null;
                            }
                          }(),
                          prefixIconColor: () {
                            if (_tfState == '2' && !_isPasswordError) {
                              return Colors.blue;
                            } else if (_isPasswordError) {
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
                              'Bằng việc đăng ký, bạn chấp thuận',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
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
                                        color: Colors.blueGrey,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          print('Đã bấm ĐKDV');
                                        },
                                    ),
                                    const TextSpan(
                                      text: 'và ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Chính sách quyền riêng tư ',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          print('Đã bấm CSQRT');
                                        },
                                    ),
                                    const TextSpan(
                                      text: 'của Fluentz',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
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
                      child: Builder(
                        builder: (context2) {
                          return Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formState.currentState!.validate()) {
                                      setState(() {
                                        _isSubmited = true;
                                      });
                                      await _register();
                                      setState(() {
                                        _isSubmited = false;
                                      });
                                    }
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
                                  child: const Text('Đăng ký',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(15, 0, 5, 15),
                            child: const Divider(
                              color: Colors.grey,
                              height: 1,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                            child: const Center(
                              child: Expanded(
                                child: Text(
                                  'Đăng ký nhanh bằng',
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
                              onPressed: () {},
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
                                  ),
                                ],
                              ),
                            ),
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
                              onPressed: () {},
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
                                  ),
                                ],
                              ),
                            ),
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
