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
  UpdateFeed() {
    setState(() {});
  }

  late List<QueryDocumentSnapshot<Object?>> usernames;

  var userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('users').get(),
          builder: (context, queryUsernames) {
            return FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('bills').get(),
              builder: (builder, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    queryUsernames.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && queryUsernames.hasData) {
                    usernames = queryUsernames.data!.docs.toList();
                    final List<DocumentSnapshot> documents =
                        snapshot.data!.docs.toList();
                    return ListView(
                      children: Mapping(documents),
                    );
                  }
                }
                return CircularProgressIndicator();
              },
            );
          }),
    );
  }

  List<Widget> Mapping(List<DocumentSnapshot<Object?>> documents) {
    documents.sort((a, b) {
      List aVotes = a['upvotes'];
      List bVotes = b['upvotes'];
      return aVotes.length.compareTo(bVotes.length);
    });
    documents = documents.reversed.toList();
    return documents.map((doc) {
      if (doc['parentBillId'] == "rootBill") {
        return Bill(
          isUsable: true,
          Billname: doc['billName'],
          billPseudoCode: doc['billPseudoCode'],
          date: doc['dateTime'],
          parentBill: doc['parentBillId'],
          username: usernames
              .firstWhere((element) => element.id == doc['userId'])
              .get('username'),
          billContent: doc['billContent'],
          id: doc.id,
          upvotes: doc['upvotes'] as List,
          userId: userId,
        );
      } else
        return Container();
    }).toList();
  }
}
