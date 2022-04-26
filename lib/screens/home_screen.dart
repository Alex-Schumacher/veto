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
        title: Text("Veto - page principal"),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                value: 'Logout',
                child: Row(
                  children: [
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                    ),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              )
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'Logout') {
                FirebaseAuth.instance.signOut();
                setState(() {});
              }
            },
          ),
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
                builder: (BuildContext builder) => PopupForm(onSubmited: () => UpdateMain(),),
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
