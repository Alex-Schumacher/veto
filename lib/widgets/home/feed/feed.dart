import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:veto/widgets/home/feed/post.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('posts').get(),
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
    );
  }

  List<Card> Mapping(List<DocumentSnapshot<Object?>> documents) {
    documents.sort((a, b) {
      Timestamp aTime = a['dateTime'];
      Timestamp bTime = b['dateTime'];
      return aTime.compareTo(bTime);
    });
    documents = documents.reversed.toList();
    return documents
        .map((doc) => Card(
              child: ListTile(
                title: Text(doc['content']),
                subtitle: Text(doc['userId']),
              ),
            ))
        .toList();
  }
}
