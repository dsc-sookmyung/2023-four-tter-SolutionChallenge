import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:folder/protector/event.dart';
import 'package:folder/services/networking.dart';
import 'package:folder/services/weathermodel.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_to_text.dart';
import '../protector/fill.dart';
import '../services/location.dart';
import 'package:http/http.dart' as http;

const apiKey = 'b56387afa1f8e32ae9fca47abdbf86e8';
const bgColor = Color(0xff00A67E);
const textColor = Color(0xffFEFDFC);
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title

  importance: Importance.high,
);

class LoadingScreen extends StatefulWidget {
  final String accessToken;
  const LoadingScreen({super.key, required this.accessToken});
  // final locationWeather;
  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  SpeechToText speechToText = SpeechToText();
  late bool mlret;
  Future<void> MLApi(String anstext) async {
    const url = 'http://34.125.92.151:8000/';
    const url2 = 'STT/STT';
    String url3 = 'prediction/$anstext';
    final stturl = Uri.parse(url + url2);
    final predicturl = Uri.parse(url + url3);
    final headers = {"accept": "application/json"};
    final response = await http.get(stturl, headers: headers);
    final response2 = await http.get(predicturl, headers: headers);
    if (response2.statusCode == 200) {
      print("responsebody 출력");
      print(response2.body);
      if (double.parse(response2.body) == 1) {
        print("반환값 1.0");
        mlret = true;
        alarmPillApi(mlret);
      } else {
        print("반환값 0.0");
        mlret = false;
        alarmPillApi(mlret);
      }
    } else {
      print(response.body);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('response status code is ${response.statusCode}'),
                content: const Text('실패'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('ok'))
                ],
              ));
    }
  }

  Future<void> alarmPillApi(bool accept) async {
    print("alarmPillApi 시작");
    var url = Uri.parse('http://34.168.149.159:8080/alarm/pill?pill=$accept');
    // http://34.168.149.159:8080/my-page/family?accept=true&userFamilyId=1
    final headers = {
      "accept": "*/*",
      "Authorization": "$_accessToken",
    };
    print("patch직전");
    var response = await http
        .patch(url, headers: headers, body: {'accept': accept.toString()});
    if (response.statusCode == 200) {
      print("alarmPillApi 성공 response.body");
      print(response.body);
    } else {
      print("alarmPillApi 실패 response.body");
      print(response.body);
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getLocationData();
    });
    _accessToken = widget.accessToken;
    FCM();
    PillApi();
    getCalendar();
    init();
    PostFcm();
    _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    FirebaseMessaging.instance
        .getToken()
        .then((value) => print('Token:$value'));
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {}
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showNotification(message);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // Handle notification message when app is open
    });
  }

  Future<void> patchAlarm(bool pill) async {
    const String url1 = 'http://34.168.149.159:8080/alarm/pill?pill=';
    String url2 = '$pill';
    final urlparse = Uri.parse(url1);
    final headers = {
      "accept": "*/*",
      "Authorization": "$_accessToken",
    };
    var response =
        await http.patch(Uri.parse(url1 + url2), headers: headers, body: {
      'fillCheck': pill.toString(),
    });

    if (response.statusCode == 200) {
      print("patchalarm 성공 response.body");
      print(response.body);
    } else {
      print("patchalarm 실패 response.body");
      print(response.body);
    }
  }

  Future<void> FCM() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  String formatDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  List<Fill> _fills = [];
  List<Event> _events = [];
  late FlutterLocalNotificationsPlugin _localNotificationsPlugin;
  String? _accessToken;
  DateTime selectedDate = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  WeatherModel weather = WeatherModel();
  int? temperature;
  Icon? weatherIcon;
  String? weatherexplain;
  bool iseventChecked = false;
  var isListening = false;
  var text = '버튼을 꾹 누르고 말해보세요';
  String resulttext = "";
  final stt.SpeechToText _speech = stt.SpeechToText();

  Location location = Location();
  Map<String, dynamic> weatherData = {};

  void getLocationData() async {
    print('geolocation호출');
    await location.getCurrentLocation();
    NetworkHelper networkHelper = NetworkHelper(
        'https://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric');
    var fetchedData = await networkHelper.getData();
    setState(() {
      weatherData = fetchedData;
    });
    updatedUI(weatherData);
  }

  void updatedUI(dynamic weatherData) {
    print("updatedUI호출");
    double temp = weatherData['main']['temp'];
    temperature = temp.floor();
    var condition = weatherData['weather'][0]['id'];
    weatherIcon = weather.getWeatherIcon(condition);
    weatherexplain = weather.getMessage(condition);
    print(temperature);
    print(weatherIcon);
    print(weatherexplain);
  }

  Future<void> CheckPillApi(bool check, int fillId) async {
    var url = Uri.parse(
        'http://34.168.149.159:8080/old/fillInfo/$fillId?accept=$check');
    final headers = {
      "accept": "*/*",
      "Authorization": "$_accessToken",
    };
    var response = await http.patch(url,
        headers: headers,
        body: {'accept': check.toString(), 'userFamilyId': fillId.toString()});
    if (response.statusCode == 200) {
      print("CheckPillApi 성공 response.body");
      print(response.body);
    } else {
      print("CheckPillApi 실패 response.body");
      print(response.body);
    }
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
      "accept": "*/*",
      "Authorization": "$_accessToken",
    };
    final response = await http.get(careurl, headers: headers);
    final List<dynamic> data = json.decode(response.body);
    print(data);
    setState(() {
      _events = data.map((json) => Event.fromJson(json)).toList();
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = AndroidNotificationDetails(channel.id, channel.name,
        priority: Priority.high, importance: Importance.high, showWhen: false);
    final platform = NotificationDetails(android: android);
    await _localNotificationsPlugin.show(notification.hashCode,
        notification?.title, notification?.body, platform,
        payload: message.data.toString());
  }

  String? devicetoken;
  //get device token
  Future getDeviceToken() async {
    FirebaseMessaging FirebaseMessage = FirebaseMessaging.instance;
    String? deviceToken = await FirebaseMessage.getToken();
    return deviceToken;
  }

  init() async {
    devicetoken = await getDeviceToken();
    print("### PRINT DEVICE TOKEN ####");
    print(devicetoken);
  }

  Future<void> PostFcm() async {
    await init();
    if (devicetoken == null) {
      print('device token is null');
      return;
    }
    String url = 'http://34.168.149.159:8080/auth/fcm';
    final headers = {
      "Authorization": "$_accessToken",
      "Content-Type": "application/json"
    };
    final response = await http.post(Uri.parse(url),
        headers: headers, body: jsonEncode(devicetoken).replaceAll('"', ''));
    print(devicetoken);

    if (response.statusCode == 200) {
      print('fcmtoken 저장 완료');
      print(response.body);
    } else {
      print('fcmtoken 저장 실패');
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 35,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    )
                  ],
                ),
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
                        children: const [
                          Text(
                            '오늘의 일정',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _events.length,
                          itemBuilder: (BuildContext context, int index) {
                            final event = _events[index];
                            if (event.date == formatDate) {
                              return CheckboxListTile(
                                value: event.isChecked,
                                onChanged: ((value) {
                                  setState(() {
                                    event.isChecked = value!;
                                  });
                                }),
                                title: Text(event.name),
                                subtitle: Text(event.time),
                              );
                            } else {
                              return const Text('');
                            }
                          }),
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
                        children: const [
                          Text(
                            '답변하기',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Column(
                        children: [
                          const Text('답변하기'),
                          FloatingActionButton(
                            child: GestureDetector(
                              onTapDown: (details) async {
                                if (!isListening) {
                                  var available =
                                      await speechToText.initialize();
                                  if (available) {
                                    isListening = true;
                                    speechToText.listen(
                                      onResult: (result) {
                                        setState(() {
                                          text = result.recognizedWords;
                                          resulttext = text;
                                        });
                                        print("onpressed");
                                        print(text.toString());
                                        MLApi(text.toString());
                                      },
                                    );
                                  }
                                }
                              },
                              onTapUp: (details) {
                                setState(() {
                                  isListening = false;
                                });
                                speechToText.stop();
                              },
                              child: CircleAvatar(
                                backgroundColor: bgColor,
                                radius: 35,
                                child: Icon(
                                  isListening ? Icons.mic : Icons.mic_none,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
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
                        children: const [
                          Text(
                            '오늘의 날씨',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Transform.scale(
                            scale: 1.3,
                            child: Transform.translate(
                                offset: const Offset(-5, -2),
                                child: weatherIcon //weatherIcon,
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  //'18도',
                                  '$temperature 도',
                                  style: TextStyle(
                                      fontSize: 28,
                                      color: Colors.teal.shade700,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  // '가벼운 산책 어떠세요',
                                  '$weatherexplain',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.teal.shade700,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
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
                        children: const [
                          Text(
                            '약 복용',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _fills.length,
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                            value: _fills[index]
                                .isChecked, // 각 요소의 isChecked 값을 사용
                            onChanged: (value) {
                              setState(() {
                                _fills[index].isChecked =
                                    value ?? false; // isChecked 값을 업데이트
                                print(_fills[index]
                                    .fillId); //이 형태가 fillid각각 접근 가능
                                // print("fills : $_fills"); //불가능
                                CheckPillApi(_fills[index].isChecked,
                                    _fills[index].fillId ?? 0);
                              });
                            },
                            title: Text(_fills[index].fillName),
                            subtitle: Text(_fills[index].fillTime),
                          );
                        },
                      )
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
