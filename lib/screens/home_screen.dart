import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text("Veto"),
      actions: [
        DropdownButton(
          icon: Icon(
            Icons.more_vert,
            color: Theme.of(context).primaryIconTheme.color,
          ),
          items: [
            DropdownMenuItem<Row>(
                child: Row(
              children: [
                Icon(
                  Icons.exit_to_app,
                  color: Colors.black,
                ),
                SizedBox(width: 8),
                Text('Logout')
              ],
            ))
          ],
          onChanged: (itemIdentifier) {
            if (itemIdentifier == 'Logout') {
              FirebaseAuth.instance.signOut();
              setState(() {
                
              });
            }
          },
        ),
      ],
    ));
  }
}
