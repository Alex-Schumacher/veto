import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BillFeed extends StatefulWidget {
  const BillFeed({Key? key}) : super(key: key);

  @override
  State<BillFeed> createState() => _BillFeedState();
}

class _BillFeedState extends State<BillFeed> {
  bool isUpvoted = false;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }

  List<Container> Mapping(List<DocumentSnapshot<Object?>> documents) {
    documents.sort((a, b) {
      int aVotes = a['upvotes'];
      int bVotes = b['upvotes'];
      return aVotes.compareTo(bVotes);
    });
    documents = documents.reversed.toList();
    return documents
        .map((doc) => Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    child: Icon(Icons.arrow_upward,
                        color: isUpvoted
                            ? Colors.blue
                            : Theme.of(context).hintColor),
                    onTap: () {
                      setState(() {
                        var add = 1;
                        isUpvoted = !isUpvoted;
                        if (isUpvoted) add = -1;
                        FirebaseFirestore.instance
                            .collection('bills')
                            .doc(doc.id)
                            .update({'upvotes': doc['upvotes'] + add});
                      });
                    },
                  ),
                  Expanded(
                    child: Card(
                      child: ListTile(
                        title: Text(doc['billContent']),
                        subtitle: Text(doc['upvotes'].toString()),
                      ),
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }
}
