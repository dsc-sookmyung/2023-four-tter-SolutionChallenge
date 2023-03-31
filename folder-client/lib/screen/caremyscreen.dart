import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../protector/fill.dart';

class CareMyScreen extends StatefulWidget {
  final String accessToken;
  const CareMyScreen({required this.accessToken});

  @override
  State<CareMyScreen> createState() => _CareMyScreenState();
}

class _CareMyScreenState extends State<CareMyScreen> {
  //친구 추가 요청한 사람 정보
  String? friendName; //이름
  int familyCode = 0; //userFamilyId
  final _pillNameController = TextEditingController();
  final _pilltimeController = TextEditingController();
  final List<Map<String, String>> _pillList = [];
  bool _acceptValue = false;
  final oldplus = TextEditingController();
  String? username;
  List<Fill> _fills = [];
  int userCodeget = 0;
  String? _accessToken;
  List<Fill> _fillsT = [];
  @override
  void initState() {
    super.initState();
    _accessToken = widget.accessToken;
    PillApi();
    UserCodeApi();
    CheckFriendApi();
    OldPillInfoApi();
  }

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
      print("_addPill 실행");
      print(pill);
    });
  }

  Future<void> postaddpill() async {
    List<String?> fillTimes = [];
    List<String?> fills = [];
    final url = Uri.parse('http://34.168.149.159:8080/my-page/fillInfo');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': '$_accessToken'
    };

    for (Map<String, String> pill in _pillList) {
      fillTimes.add(pill['time']);
      fills.add(pill["name"]);
    }

    Map<String, dynamic> request = {
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
                title: const Text('약 정보 등록을 완료했습니다'),
                content: const Text(''),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('ok'))
                ],
              ));
    } else {
      print(jsonEncode(request));
      print(response.body);
    }
  }

  Future<void> CheckFriendApi() async {
    const String url1 = 'http://34.168.149.159:8080/my-page/family';
    final urlparse = Uri.parse(url1);
    final headers = {
      "accept": "*/*",
      "Authorization": "$_accessToken",
    };
    final response = await http.get(urlparse, headers: headers);
    final Map<String, dynamic> data = json.decode(response.body);
    setState(() {
      friendName = data['username'];
      print(friendName);
      familyCode = data['userFamilyId'];
      print(familyCode);
    });
  }

  Future<void> acceptApi(bool accept, int userFamilyId) async {
    //dayeong노인이 nari보호자의 코드를 노인페이지에 추가함
    //그랬을때 nari마이페이지에서 dayeong의 유저코드를 받아서 확인
    print("acceptapi실행 시작");
    var url = Uri.parse(
        'http://34.168.149.159:8080/my-page/family?accept=$accept&userFamilyId=$userFamilyId');
    final headers = {
      "accept": "*/*",
      "Authorization": "$_accessToken",
    };
    print("patch직전");
    var response = await http.patch(url, headers: headers, body: {
      'accept': accept.toString(),
      'userFamilyId': userFamilyId.toString()
    });
    if (response.statusCode == 200) {
      print("acceptApi 성공 response.body");
      print(response.body);
    } else {
      print("acceptApi 실패 response.body");
      print(response.body);
    }
  }

  Future<void> OldPillInfoApi() async {
    const String url1 = 'http://34.168.149.159:8080/old/fillInfo/';
    final careurl = Uri.parse(url1);
    final headers = {
      "accept": "*/*",
      "Authorization": "$_accessToken",
    };
    final response = await http.get(careurl, headers: headers);
    final List<dynamic> data = json.decode(response.body);
    print("OldPillInfoApi data");
    print(data);
    setState(() {
      _fillsT = data.map((json) => Fill.fromJson(json)).toList();
    });
  }

  Future<void> FamilyAddApi() async {
    String url = 'http://34.168.149.159:8080/my-page/family?userCode=';
    String url2 = oldplus.text.trim();
    final headers = {
      "accept": "*/*",
      "Authorization": "$_accessToken",
    };
    print(url2);
    print(url + url2);
    final familyurl = Uri.parse(url + url2);

    final response = await http.post(familyurl,
        headers: headers, body: {'userCode': oldplus.text.trim()});
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.body);
    }
  }

  Future<void> UserCodeApi() async {
    const String url1 = 'http://34.168.149.159:8080/auth/me';
    final oldurl = Uri.parse(url1);
    final headers = {
      "accept": "*/*",
      "Authorization": "$_accessToken",
    };
    final response = await http.get(oldurl, headers: headers);
    // final List<dynamic> data = json.decode(response.body);
    final data = json.decode(response.body);
    print(data);
    print(data['userCode']);
    userCodeget = data['userCode'];
    username = data['username'];
    print(username);
    print(userCodeget);
    setState(() {});
  }

  Future<void> PillApi() async {
    const String url1 = 'http://34.168.149.159:8080/my-page/fillInfo/';
    final careurl = Uri.parse(url1);
    final headers = {
      "accept": "*/*",
      "Authorization": "$_accessToken",
    };
    final response = await http.get(careurl, headers: headers);
    final List<dynamic> data = json.decode(response.body);
    print(data);
    setState(() {
      _fills = data.map((json) => Fill.fromJson(json)).toList();
    });
  }

  @override //부모 클래스에 있는걸 가져옴
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Transform.scale(
                          scale: 2.2,
                          child: Transform.translate(
                            offset: const Offset(10, 2),
                            child: const Icon(
                              Icons.account_circle,
                              color: Colors.grey,
                              size: 50,
                            ),
                          ),
                        ),
                        // Column(Icons.add_a_photo_rounded),
                        Column(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '$username',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 32,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '님',
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.8),
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  '나의 코드',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 28,
                                  ),
                                ),
                                const SizedBox(
                                  width: 150,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: const Color.fromARGB(
                                        0,
                                        0,
                                        77,
                                        64), // Text Color (Foreground color)
                                  ),
                                  onPressed: () {},
                                  child: const Text("복사"),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              '$userCodeget',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                color: Color(0xFF004D40),
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 371.4,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Text(
                              '보호대상 추가하기',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 28,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: oldplus,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    labelText: '사용자코드'),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.teal.shade700),
                                    fixedSize: MaterialStateProperty.all<Size>(
                                        const Size.fromHeight(59))),
                                onPressed: () {
                                  FamilyAddApi();
                                },
                                child: const Text(
                                  '요청하기',
                                  style: TextStyle(fontSize: 18),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Text(
                              '보호자 추가 요청',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 28,
                              ),
                            ),
                            SizedBox(
                              width: 100,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              friendName?.isEmpty ?? true || friendName == ""
                                  ? "보호대상 추가요청이 없습니다"
                                  : "$friendName님이 보호대상 등록을 요청했어요",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 17,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shadowColor: Colors.teal.shade700,
                                  //elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  minimumSize:
                                      const Size(130, 40), //////// HERE
                                ),
                                onPressed: () {
                                  _acceptValue = true;
                                  acceptApi(_acceptValue, familyCode);
                                },
                                child: const Text(
                                  "수락할게요",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.teal,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal.shade700,
                                  shadowColor: Colors.teal.shade700,
                                  //elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  minimumSize:
                                      const Size(130, 40), //////// HERE
                                ),
                                onPressed: () {
                                  _acceptValue = false;
                                  acceptApi(_acceptValue, familyCode);
                                },
                                child: const Text("거절할게요"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Text(
                              '약 추가하기',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 28,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 150,
                              height: 50,
                              child: TextField(
                                controller: _pillNameController,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    labelText: '약 종류(예, 고혈압약)'),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 150,
                              height: 50,
                              child: TextField(
                                controller: _pilltimeController,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    labelText: '시( - - : - -)'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade700,
                            shadowColor: Colors.teal.shade700,
                            //elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            minimumSize: const Size(140, 40), //////// HERE
                          ),
                          onPressed: () {
                            _addPill();
                            postaddpill();
                          },
                          child: const Text(
                            '추가',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Text(
                              '약 복용일지',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 28,
                              ),
                            ),
                            SizedBox(
                              width: 100,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: const [
                            Text(
                              '복용중인 약을 수정하세요',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _fillsT.length,
                            itemBuilder: (context, index) {
                              return Flexible(
                                  child: ListTile(
                                title: Text(_fillsT[index].fillName),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_fillsT[index].fillTime),
                                    Text(
                                        "복용여부: ${_fillsT[index].isChecked ? '복용' : '미복용'}"),
                                  ],
                                ),
                              ));
                            }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
