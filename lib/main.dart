import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:veto/screens/connected_screen.dart';
import 'package:veto/screens/profile_screen.dart';
import 'package:veto/screens/vote_screen.dart';
import 'package:veto/widgets/vote/BillFeed.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapShot) {
          if (userSnapShot.hasData) {
            return ConnectedScreen();
          }
          return AuthScreen();
        },
      ),
    );
  }
}
