import 'package:flutter/material.dart';


import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/vote/BillFeed.dart';


class VoteScreen extends StatefulWidget {
  const VoteScreen({ Key? key }) : super(key: key);
  static  const RouteName = 'vote';

  @override
  State<VoteScreen> createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text(
          'bulletin',
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
        child: BillFeed(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        child: Icon(Icons.loupe),
        onPressed: () {
          //TODO
       /*   Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext builder) => PopupForm()));
        */
        },
        splashColor: Colors.lightBlueAccent,
      ),
    );
  }
}