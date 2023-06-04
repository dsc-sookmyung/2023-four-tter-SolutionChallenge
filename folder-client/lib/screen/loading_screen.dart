import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:folder/protector/event.dart';
import 'package:folder/services/networking.dart';
import 'package:folder/services/weathermodel.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../protector/fill.dart';
import '../services/location.dart';
import 'package:http/http.dart' as http;
import 'package:weather_icons/weather_icons.dart';

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
    const url = 'http://34.28.46.24:8000/';
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
    var url = Uri.parse('http://34.28.46.24:8080/alarm/pill?pill=$accept');
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
    const String url1 = 'http://34.28.46.24:8080/alarm/pill?pill=';
    String url2 = '$pill';
    //final urlparse = Uri.parse(url1);
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
  // final stt.SpeechToText _speech = stt.SpeechToText();

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
    var url =
        Uri.parse('http://34.28.46.24:8080/old/fillInfo/$fillId?accept=$check');
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
    const String url1 = 'http://34.28.46.24:8080/my-page/fillInfo/';
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
    const String url1 = 'http://34.28.46.24:8080/calendar';
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
    String url = 'http://34.28.46.24:8080/auth/fcm';
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
    setState(() {});
    // getLocationData();
    print("빌드");
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8ED),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color(0xFFF6A45A),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.w600),
                      )
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
                  color: const Color(0xFFFFAD00),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text(
                            '오늘의 날씨',
                            style: TextStyle(
                              color: Colors.white,
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
                              offset: const Offset(-7, -13),
                              child: weatherIcon,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$temperature 도',
                                  style: const TextStyle(
                                      fontSize: 28,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '$weatherexplain',
                                  style: const TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
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
                  color: const Color(0xFFFFF1DD).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text(
                            '오늘의 일정',
                            style: TextStyle(
                              color: Color(0xFFF6A45A),
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                            ),
                          )
                        ],
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _events.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                              height: 10); // 공백을 조정할 수 있는 값으로 설정
                        },
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
                              title: Text(event.name,
                                  style: const TextStyle(fontSize: 30.0)),
                              subtitle: Text(event.time,
                                  style: const TextStyle(fontSize: 30.0)),
                            );
                          } else {
                            return const SizedBox.shrink(); // 공백이 필요 없는 경우
                          }
                        },
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
                  color: const Color(0xFFFBE983).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text(
                            '약 복용',
                            style: TextStyle(
                              color: Color(0xFFFFAD00),
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
                          final fill = _fills[index];
                          final dateTime = DateFormat('HH:mm:ss')
                              .parse(fill.fillTime); // 시간 형식 변환
                          final formattedTime = DateFormat('HH:mm')
                              .format(dateTime); // 변경된 형식으로 포맷

                          return CheckboxListTile(
                            value: _fills[index].isChecked,
                            onChanged: (value) {
                              setState(() {
                                _fills[index].isChecked = value ?? false;
                                print(_fills[index].fillId);
                                CheckPillApi(_fills[index].isChecked,
                                    _fills[index].fillId ?? 0);
                              });
                            },
                            title: Text(
                              _fills[index].fillName,
                              style: const TextStyle(fontSize: 30.0),
                            ),
                            subtitle: Text(
                              formattedTime,
                              style: const TextStyle(fontSize: 30.0),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                      Column(
                        children: [
                          const Text('답변하기',
                              style: TextStyle(
                                  fontSize: 40.0, fontWeight: FontWeight.w500)),
                          const SizedBox(
                            height: 20,
                          ),
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
                                backgroundColor: const Color(0xFFF2CA74),
                                radius: 35,
                                child: Icon(
                                    isListening ? Icons.mic : Icons.mic_none,
                                    color: Colors.white),
                              ),
                            ),
                            onPressed: () {},
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text('"다 먹었어"라고 답변해보세요',
                              style: TextStyle(fontSize: 20.0)),
                          const SizedBox(
                            height: 20,
                          ),
                          //Text(text),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
