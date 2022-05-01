import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'vote_screen.dart';

class ConnectedScreen extends StatefulWidget {
  const ConnectedScreen({Key? key}) : super(key: key);

  @override
  State<ConnectedScreen> createState() => _ConnectedScreenState();
}

class _ConnectedScreenState extends State<ConnectedScreen> {
  var _index = 0;
  late Widget currentPage = HomeScreen();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Veto',
        theme: ThemeData.dark(),
        routes: {
          HomeScreen.RouteName: (context) => HomeScreen(),
          VoteScreen.RouteName: (context) => VoteScreen(),
          AuthScreen.RouteName: (context) => AuthScreen()
        },
        home: Scaffold(
              
          
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _index,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.how_to_vote), label: "vote"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle_outlined), label: "profil"),
              ],
              onTap: (index) {
                switch (index) {
                  case 0:
                    currentPage = HomeScreen();
                    break;
                  case 1:
                    currentPage = VoteScreen();
                    break;
                  //TODO PROFILE
                  case 2:
                    currentPage = ProfileScreen();
                    break;
                  default:
                    currentPage = HomeScreen();
                    break;
                }
                _index = index;

                setState(() {});
              },
            ),
            body: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, userSnapShot) {
                  return currentPage;
                })));
  }
}
