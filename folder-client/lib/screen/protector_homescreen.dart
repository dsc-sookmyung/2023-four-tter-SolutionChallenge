import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:folder/protector/calendar.dart';
import 'package:intl/intl.dart';

import '../protector/fill.dart';
import 'package:folder/protector/event.dart';

class ProtectorHomeScreen extends StatefulWidget {
  final String accessToken;
  const ProtectorHomeScreen({required this.accessToken, super.key});
  @override
  State<ProtectorHomeScreen> createState() => _ProtectorHomeScreenState();
}

class _ProtectorHomeScreenState extends State<ProtectorHomeScreen> {
  List<Fill> _fills = [];
  String formatDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String? _accessToken;
  List<Event> _events = [];
  bool iseventChecked = false;
  bool isfillChecked = false;
  @override
  void initState() {
    super.initState();
    _accessToken = widget.accessToken;
    getCalendar();
    PillApi();
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

  Future<void> getCalendar() async {
    const String url1 = 'http://34.168.149.159:8080/calendar';
    final careurl = Uri.parse(url1);
    final headers = {
      "Authorization": "$_accessToken",
    };
    final response = await http.get(careurl, headers: headers);
    final List<dynamic> data = json.decode(response.body);
    print(data);
    setState(() {
      _events = data.map((json) => Event.fromJson(json)).toList();
    });
  }

  // final Map<String,dynamic> _calendar;
  final _eventController = TextEditingController();
  final _timeController = TextEditingController();
  DateTime selectedDate = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime today = DateTime.now();
  //final bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                width: 372,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
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
                        children: [
                          Text(
                            '어르신 일정 추가하기',
                            style: TextStyle(
                              color: Colors.teal.shade700,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CalendarWidget(
                        selectedDate: selectedDate,
                        onDaySelected: onDaySelected,
                      ),
                      FloatingActionButton(
                        onPressed: (() {
                          initState() {
                            _eventController;
                            _timeController;
                          }

                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('일정 추가하기'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: _eventController,
                                    decoration: const InputDecoration(
                                        hintText: '일정 내용'),
                                  ),
                                  TextField(
                                    controller: _timeController,
                                    decoration: const InputDecoration(
                                        hintText: '일정 시간( - - : - -)'),
                                  )
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('취소')),
                                ElevatedButton(
                                    onPressed: () async {
                                      print(selectedDate
                                          .toIso8601String()
                                          .split('T')[0]);
                                      print(_eventController.text);
                                      print(_timeController.text);
                                      final eventName = _eventController.text;
                                      final eventTime = _timeController.text;
                                      if (eventName.isNotEmpty &&
                                          eventTime.isNotEmpty) {
                                        final url = Uri.parse(
                                            'http://34.168.149.159:8080/calendar');
                                        final headers = {
                                          'Authorization': '$_accessToken',
                                          'Content-Type': 'application/json'
                                        };
                                        final response = await http.post(url,
                                            headers: headers,
                                            body: jsonEncode(<String, dynamic>{
                                              'calendarDate': selectedDate
                                                  .toIso8601String()
                                                  .split('T')[0],
                                              'calendarTime': eventTime,
                                              'content': eventName,
                                              //'calendarCheck': false,
                                              //'calendarId': 0,
                                            }));
                                        if (response.statusCode == 200) {
                                          print(response.body);
                                        } else {
                                          print(response.body);
                                        }
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('추가하기'))
                              ],
                            ),
                          );
                        }),
                        child: const Icon(Icons.add),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 372,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
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
                        children: [
                          Text(
                            '오늘의 일정',
                            style: TextStyle(
                              color: Colors.teal.shade700,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _events.length,
                          itemBuilder: (BuildContext context, int index) {
                            final event = _events[index];
                            if (event.date == formatDate) {
                              return ListTile(
                                title: Text(event.name),
                                subtitle: Text(event.time),
                              );
                            } else {
                              return const Text('');
                            }
                          }),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 372,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
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
                        children: [
                          Text(
                            '약 복용',
                            style: TextStyle(
                              color: Colors.teal.shade700,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _fills.length,
                          itemBuilder: (BuildContext context, int index) {
                            final fill = _fills[index];
                            return ListTile(
                              title: Text(fill.fillName),
                              subtitle: Text(fill.fillTime),
                            );
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
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
