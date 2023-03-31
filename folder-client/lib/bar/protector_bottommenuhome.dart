import 'package:flutter/material.dart';
import 'package:folder/screen/caremyscreen.dart';
import 'package:folder/screen/loading_screen.dart';
import 'package:folder/screen/oldmyscreen.dart';
import 'package:folder/screen/protector_homescreen.dart';

class ProtectorBottomMenuHome extends StatefulWidget {
  final String accessToken;

  const ProtectorBottomMenuHome({required this.accessToken});

  static const String _title = 'Flutter Code Sample';

  @override
  State<ProtectorBottomMenuHome> createState() =>
      _ProtectorBottomMenuHomeState();
}

class _ProtectorBottomMenuHomeState extends State<ProtectorBottomMenuHome> {
  late String _accessToken;

  @override
  void initState() {
    super.initState();
    _accessToken = widget.accessToken;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ProtectorBottomMenuHome._title,
      home: MyStatefulWidget(accessToken: _accessToken),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  final String accessToken;

  const MyStatefulWidget({required this.accessToken});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = [
      ProtectorHomeScreen(accessToken: widget.accessToken),
      CareMyScreen(accessToken: widget.accessToken)
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
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'today report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '마이페이지',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightGreen,
        onTap: _onItemTapped,
      ),
    );
  }
}
