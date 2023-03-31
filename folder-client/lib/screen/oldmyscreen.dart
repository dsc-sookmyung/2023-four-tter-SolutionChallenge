import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../protector/fill.dart';

class OldMyScreen extends StatefulWidget {
  final String accessToken;

  const OldMyScreen({required this.accessToken, super.key});
  @override
  State<OldMyScreen> createState() => _OldMyScreenState();
}

class _OldMyScreenState extends State<OldMyScreen> {
  //친구 추가 요청한 사람 정보
  String? friendName;
  int familyCode = 0;
  bool? _acceptValue;
  final protectorplus = TextEditingController();
  List<Fill> _fillsT = [];
  String? _accessToken;
  String? username;
  int userCodeget = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _accessToken = widget.accessToken;
    UserCodeApi();
    OldPillInfoApi();
  }

  Future<void> FamilyAddApi() async {
    String url = 'http://34.168.149.159:8080/my-page/family?userCode=';
    String url2 = protectorplus.text.trim();
    final headers = {
      "accept": "*/*",
      "Authorization": "$_accessToken",
    };
    print(url2);
    print(url + url2);
    final familyurl = Uri.parse(url + url2);

    final response = await http.post(familyurl,
        headers: headers, body: {'userCode': protectorplus.text.trim()});
    if (response.statusCode == 200) {
      print(response.body);
    } else {
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
    print(userCodeget);
    print(username);
    setState(() {});
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
                            const SizedBox(
                              height: 10,
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
                              children: const [
                                Text(
                                  '나의 코드',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 28,
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
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
                              '보호자 추가하기',
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
                                controller: protectorplus,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  '보호대상 추가 요청',
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      friendName?.isEmpty ??
                                              true || friendName == ""
                                          ? "보호자 추가요청이 없습니다"
                                          : "$friendName님이 보호자 등록을 요청했어요",
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          shadowColor: Colors.teal.shade700,
                                          //elevation: 3,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          minimumSize:
                                              const Size(130, 40), //////// HERE
                                        ),
                                        onPressed: () {
                                          _acceptValue = true;
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
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          minimumSize:
                                              const Size(130, 40), //////// HERE
                                        ),
                                        onPressed: () {
                                          _acceptValue = false;
                                        },
                                        child: const Text("거절할게요"),
                                      ),
                                    ],
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
