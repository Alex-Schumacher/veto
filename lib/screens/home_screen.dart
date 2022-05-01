import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veto/widgets/home/feed/feed.dart';
import '../widgets/home/PopupForm.dart';
import 'package:veto/widgets/home/feed/post.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const RouteName = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void UpdateMain() {
    setState(() {});
  }

  GlobalKey<_HomeScreenState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'feed',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlue),
        ),
        actions: [
          InkWell(
            child: Icon(Icons.logout),
            onTap: () {
              FirebaseAuth.instance.signOut();
              setState(() {});
            },
          )
        ],
      ),
      body: Container(
        child: Feed(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext builder) => PopupForm(
                  onSubmited: () => UpdateMain(),
                ),
              ));
        },
        splashColor: Colors.lightBlueAccent,
      ),
    );

    /*ListView.builder(
        itemCount: 10, //à changà avec le nombre de tweet voulu,
        itemBuilder: ((context, index) => Post(username,content)) ), 
        */
  }
}
