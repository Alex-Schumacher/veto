import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:veto/widgets/vote/Bill.dart';

class BillFeed extends StatefulWidget {
  const BillFeed({Key? key}) : super(key: key);

  @override
  State<BillFeed> createState() => _BillFeedState();
}

class _BillFeedState extends State<BillFeed> {
  UpdateFeed(){
    setState(() {
      
    });
  }

  var userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(Duration(seconds: 1), () {
            setState(() {});
          });
        },
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('bills').get(),
          builder: (builder, snapshot) {
            if (snapshot.hasData) {
              final List<DocumentSnapshot> documents =
                  snapshot.data!.docs.toList();
              return ListView(
                children: Mapping(documents),
              );
            } else
              return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  List<Bill> Mapping(List<DocumentSnapshot<Object?>> documents) {
    documents.sort((a, b) {
      List aVotes = a['upvotes'];
      List bVotes = b['upvotes'];
      return aVotes.length.compareTo(bVotes.length);
    });
    documents = documents.reversed.toList();
    return documents
        .map((doc) => Bill(
              content: doc['billContent'],
              id: doc.id,
              upvotes: doc['upvotes'] as List,
              userId: userId,
            ))
        .toList();
  }
}
