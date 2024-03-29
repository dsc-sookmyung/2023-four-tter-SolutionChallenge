import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _pillNameController = TextEditingController();
  final _pilltimeController = TextEditingController();
  final List<Map<String, String>> _pillList = [];

  bool? _isGuard;
  final usernameController = TextEditingController();
  final phonenumController = TextEditingController();
  final loginIdController = TextEditingController();
  final pwController = TextEditingController();
  final checkpwController = TextEditingController();
  final sleepTimeController = TextEditingController();
  final wakeTimeController = TextEditingController();

  void _addPill() {
    String pillName = _pillNameController.text.trim();
    String pillTime = _pilltimeController.text.trim();
    Map<String, String> pill = {
      "name": pillName,
      "time": pillTime,
    };
    setState(() {
      _pillList.add(pill);
      _pillNameController.clear();
      _pilltimeController.clear();
    });
  }

  Future<void> join() async {
    List<String?> fillTimes = [];
    List<String?> fills = [];
    final url = Uri.parse('http://34.28.46.24:8080/auth/join');
    final headers = {'Content-Type': 'application/json'};

    for (Map<String, String> pill in _pillList) {
      fillTimes.add(pill['time']);
      fills.add(pill["name"]);
    }

    Map<String, dynamic> request = {
      "checkedPassword": checkpwController.text.trim(),
      "loginId": loginIdController.text.trim(),
      "password": pwController.text.trim(),
      "phone": phonenumController.text.trim(),
      "sleepTime": sleepTimeController.text.trim(),
      "username": usernameController.text.trim(),
      "wakeTime": wakeTimeController.text.trim(),
      "guard": _isGuard,
      'fillTimes': fillTimes,
      'fills': fills,
    };
    final response =
        await http.post(url, headers: headers, body: jsonEncode(request));
    if (response.statusCode == 200) {
      print(response.body);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('회원가입을 완료했습니다'),
                content: const Text('correct login id or password'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('ok'))
                ],
              ));
    } else {
      print(request);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('response status code is ${response.statusCode}'),
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
        backgroundColor: const Color(0xFFFFF8ED),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              const Row(
                children: [
                  Text(
                    '안녕하세요!',
                    style: TextStyle(
                      color: Color.fromARGB(255, 2, 2, 2),
                      fontSize: 33,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  Text(
                    '회원가입을 시작해볼까요?',
                    style: TextStyle(
                      color: Color.fromARGB(255, 2, 2, 2),
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                children: [
                  Text(
                    '성명 *',
                    style: TextStyle(
                      color: Color.fromARGB(255, 2, 2, 2),
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: '성명을 입력해주세요',
                      labelStyle: TextStyle(color: Colors.grey), // 레이블의 색상
                      fillColor: Colors.white, // 텍스트 필드의 배경색
                      filled: true, // 배경색 채우기
                      hintStyle: TextStyle(color: Colors.green),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Row(
                    children: [
                      Text(
                        '전화번호 *',
                        style: TextStyle(
                          color: Color.fromARGB(255, 2, 2, 2),
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: phonenumController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: '전화번호를 입력해주세요',
                      labelStyle: TextStyle(color: Colors.grey), // 레이블의 색상
                      fillColor: Colors.white, // 텍스트 필드의 배경색
                      filled: true, // 배경색 채우기
                      hintStyle: TextStyle(color: Colors.green),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Row(
                    children: [
                      Text(
                        '아이디 *',
                        style: TextStyle(
                          color: Color.fromARGB(255, 2, 2, 2),
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: loginIdController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: '아이디를 입력해주세요',
                      labelStyle: TextStyle(color: Colors.grey), // 레이블의 색상
                      fillColor: Colors.white, // 텍스트 필드의 배경색
                      filled: true, // 배경색 채우기
                      hintStyle: TextStyle(color: Colors.green),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Row(
                    children: [
                      Text(
                        '비밀번호 *',
                        style: TextStyle(
                          color: Color.fromARGB(255, 2, 2, 2),
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: pwController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: '비밀번호를 입력해주세요',
                      labelStyle: TextStyle(color: Colors.grey), // 레이블의 색상
                      fillColor: Colors.white, // 텍스트 필드의 배경색
                      filled: true, // 배경색 채우기
                      hintStyle: TextStyle(color: Colors.green),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Row(
                    children: [
                      Text(
                        '비밀번호 확인*',
                        style: TextStyle(
                          color: Color.fromARGB(255, 2, 2, 2),
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: checkpwController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: '비밀번호를 입력해주세요',
                      labelStyle: TextStyle(color: Colors.grey), // 레이블의 색상
                      fillColor: Colors.white, // 텍스트 필드의 배경색
                      filled: true, // 배경색 채우기
                      hintStyle: TextStyle(color: Colors.green),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Row(
                    children: [
                      Text(
                        '보호자 여부*',
                        style: TextStyle(
                          color: Color.fromARGB(255, 2, 2, 2),
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _isGuard = true;
                        },
                        style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all(const Size(150, 40)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFF9D9D9D)),
                        ),
                        child: const Text(
                          '보호자',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            _isGuard = false;
                          },
                          style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(
                                  const Size(150, 40)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFF9D9D9D))),
                          child: const Text('어르신',
                              style: TextStyle(fontSize: 20))),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Row(
                    children: [
                      Text(
                        '기상시간',
                        style: TextStyle(
                          color: Color.fromARGB(255, 2, 2, 2),
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: wakeTimeController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: '- - : - -',
                      labelStyle: TextStyle(color: Colors.grey), // 레이블의 색상
                      fillColor: Colors.white, // 텍스트 필드의 배경색
                      filled: true, // 배경색 채우기
                      hintStyle: TextStyle(color: Colors.green),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Row(
                    children: [
                      Text(
                        '취침시간',
                        style: TextStyle(
                          color: Color.fromARGB(255, 2, 2, 2),
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: sleepTimeController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: '- - : - -',
                      labelStyle: TextStyle(color: Colors.grey), // 레이블의 색상
                      fillColor: Colors.white, // 텍스트 필드의 배경색
                      filled: true, // 배경색 채우기
                      hintStyle: TextStyle(color: Colors.green),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Row(
                    children: [
                      Text(
                        '먹는 약',
                        style: TextStyle(
                          color: Color.fromARGB(255, 2, 2, 2),
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: _pillNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: '약 종류(예. 고혈압약)',
                      labelStyle: TextStyle(color: Colors.grey), // 레이블의 색상
                      fillColor: Colors.white, // 텍스트 필드의 배경색
                      filled: true, // 배경색 채우기
                      hintStyle: TextStyle(color: Colors.green),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: _pilltimeController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: '시',
                      labelStyle: TextStyle(color: Colors.grey), // 레이블의 색상
                      fillColor: Colors.white, // 텍스트 필드의 배경색
                      filled: true, // 배경색 채우기
                      hintStyle: TextStyle(color: Colors.green),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity, // 가로 길이를 화면의 가로 길이로 설정
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        backgroundColor: const Color(0xFFF9B87E),
                      ),
                      onPressed: _addPill,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 3.0),
                        child: Text(
                          '추가',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(
                    // 가로줄 추가
                    height: 1, // 가로줄의 높이
                    thickness: 1, // 가로줄의 굵기
                    color: Colors.black, // 가로줄의 색상
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: Expanded(
                        child: ListView.builder(
                            itemCount: _pillList.length,
                            itemBuilder: (context, index) {
                              return Flexible(
                                child: ListTile(
                                    title: Text(_pillList[index]["name"]!),
                                    subtitle: Text(_pillList[index]["time"]!)),
                              );
                            })),
                  ),
                  /*const SizedBox(
                    height: 16,
                  ),*/
                  SizedBox(
                    width: double.infinity, // 가로 길이를 화면의 가로 길이로 설정
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        backgroundColor: const Color(0xFFF5A359),
                      ),
                      onPressed: join,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 3.0),
                        child: Text(
                          'Folder 시작하기',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}
