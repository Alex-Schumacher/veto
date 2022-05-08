import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:veto/widgets/vote/BillPopupForm.dart';
import '../widgets/vote/BillFeed.dart';

class VoteScreen extends StatefulWidget {
  const VoteScreen({Key? key}) : super(key: key);
  static const RouteName = 'vote';

  @override
  State<VoteScreen> createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  void UpdateBill() {
    setState(() {});
  }

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
        child: RefreshIndicator(
          onRefresh: () {
            return Future.delayed(Duration(seconds: 1), () {
              setState(() {});
            });
          },
          child: Column(
            children: [
              const Text(
                'Ici vous pouvez voter,débattre et introduire des idées chaque semaine.\n Ces idées seront implémentées par la suite dans l\'application.\n ',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              InkWell(
                child: const Text(
                  'Si vous avez envie de nous aider dans le développement, notre repository Github est disponible ici.',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.lightBlue,
                      decoration: TextDecoration.underline),
                ),
                onTap: () {
                  Uri url = Uri.parse(
                      "https://github.com/AlexandreSchumacher-ceff/veto");
                  launchUrl(url);
                },
              ),
              Expanded(child: BillFeed()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        child: Icon(Icons.loupe),
        onPressed: () {
          //TODO
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext builder) => BillPopupForm(
                        onSubmited: UpdateBill,
                      )));
        },
        splashColor: Colors.lightBlueAccent,
      ),
    );
  }
}
