import 'package:flutter/material.dart';

import 'home.dart';
import 'profile.dart';
import 'forum.dart';
import 'report.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});
  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final List<Widget> widgetList = const [
    Profile(),
    Home(),
    Report(),
  ];

  int index = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: mainGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: index,
            onTap: (value) {
              setState(() {
                index = value;
              });
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedIconTheme: const IconThemeData(size: 38),
            unselectedIconTheme: const IconThemeData(size: 36),
            items: [
              navBarItem(
                icon: Icons.grid_view_rounded,
                state: 0,
              ),
              navBarItem(
                icon: Icons.home_rounded,
                state: 1,
              ),
              navBarItem(
                icon: Icons.sensors_rounded,
                state: 2,
              ),
            ]),
        body: SafeArea(
            child: IndexedStack(
          index: index,
          children: widgetList,
        )),
      ),
    );
  }

  BottomNavigationBarItem navBarItem({
    required IconData icon,
    required int state,
  }) {
    return BottomNavigationBarItem(
      tooltip: 'Home',
      icon: ShaderMask(
        shaderCallback: (Rect rect) {
          if (state == index) {
            return activeGradient.createShader(rect);
          } else {
            return inactiveGradient.createShader(rect);
          }
        },
        child: Icon(
          icon,
          color: state == index
              ? Colors.white
              : const Color.fromRGBO(64, 65, 101, 1),
        ),
      ),
      label: '',
    );
  }
}
