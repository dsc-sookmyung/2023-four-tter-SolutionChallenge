import 'package:flutter/material.dart';
import 'package:folder/screen/loading_screen.dart';

// import 'package:t_test/screen/old_screen.dart';

import '../screen/oldmyscreen.dart';

class OldBottomMenuHome extends StatefulWidget {
  final String accessToken;
  const OldBottomMenuHome({required this.accessToken, super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  State<OldBottomMenuHome> createState() => _OldBottomMenuHomeState();
}

class _OldBottomMenuHomeState extends State<OldBottomMenuHome> {
  late String _accessToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _accessToken = widget.accessToken;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: OldBottomMenuHome._title,
      home: MyStatefulWidget(accessToken: _accessToken),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  final String accessToken;

  const MyStatefulWidget({required this.accessToken, super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  late final List<Widget> _widgetoptions;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _widgetoptions = [
      LoadingScreen(
        accessToken: widget.accessToken,
      ),
      OldMyScreen(
        accessToken: widget.accessToken,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetoptions.elementAt(_selectedIndex),
      ),
      // bottom navigation 선언
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '나의 판매글',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '마이페이지',
          ),
        ],
        currentIndex: _selectedIndex, // 지정 인덱스로 이동
        selectedItemColor: Colors.lightGreen,
        onTap: _onItemTapped, // 선언했던 onItemTapped
      ),
    );
  }
}
