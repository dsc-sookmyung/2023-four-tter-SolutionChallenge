import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:folder/bar/old_bottommenuhome.dart';
import 'package:folder/bar/protector_bottommenuhome.dart';
import 'package:folder/screen/signup_screen.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final loginidController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    const String url = 'http://34.168.149.159:8080/';
    const String url2 = 'auth/login';
    var urllogin = Uri.parse(url + url2);

    final headers = {'Content-Type': 'application/json'};

    Map<String, dynamic> request = {
      'loginId': loginidController.text.trim(),
      'password': passwordController.text.trim()
    };

    final response =
        await http.post(urllogin, headers: headers, body: jsonEncode(request));

    if (response.statusCode == 200) {
      print(response.body);

      //response.body에서 뽑아내기
      final userInfo = json.decode(response.body);

      final guard = userInfo['guard'];
      final String accessToken = userInfo['accessToken'];

      print(accessToken);
      if (guard == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProtectorBottomMenuHome(accessToken: accessToken),
          ),
        );
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => OldBottomMenuHome(
                      accessToken: accessToken,
                    )));
      }
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('로그인 실패'),
                content: const Text('아이디 혹은 비밀번호가 틀립니다'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('ok'))
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 252, 252, 252),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(children: [
            const SizedBox(
              height: 250,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Folder',
                      style: TextStyle(
                          color: Color.fromARGB(255, 2, 2, 2),
                          fontSize: 43,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'For all older adults',
                      style: TextStyle(
                          color: const Color(0x00004d40).withOpacity(0.5),
                          fontSize: 18),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  controller: loginidController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ID',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(height: 60.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      backgroundColor: Colors.teal.shade900),
                  onPressed: login,
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      '로그인',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        backgroundColor: Colors.teal.shade700),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupScreen()),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        '회원가입',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )),
              ],
            )
          ]),
        )),
      ),
    );
  }
}
