import 'package:flutter/material.dart';


import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/vote/BillFeed.dart';


class VoteScreen extends StatefulWidget {
  const VoteScreen({ Key? key }) : super(key: key);

  @override
  State<VoteScreen> createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(

        title: Text("Veto - Votation"),
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
        child: BillFeed(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        child: Icon(Icons.add),
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