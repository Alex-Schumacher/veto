import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:veto/screens/vote_screen.dart';
import 'package:veto/widgets/vote/BillFeed.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Veto',
      theme: ThemeData.dark(),
      home:  Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home),label: "home"),
              BottomNavigationBarItem(icon: Icon(Icons.how_to_vote),label: "vote"),

            ],
            



        ),
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, userSnapShot) {
              if (userSnapShot.hasData) {
                return HomeScreen();
              }
              return AuthScreen();
            },
          ),
      ),
      
    );
  }
}
