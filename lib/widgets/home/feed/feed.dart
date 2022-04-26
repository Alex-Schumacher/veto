import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:veto/widgets/home/feed/post.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:veto/widgets/vote/BillFeed.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

Future<String> getUsername(String id) async {
  var doc = await FirebaseFirestore.instance.collection('users').doc(id).get();

  var username = doc.get('username');

  if (username != null || username != '')
    return username;
  else
    return 'utilisateur non disponible';
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(Duration(seconds: 1), () {
            setState(() {});
          });
        },
        child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, usernameSnapshot) {
              return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .orderBy('dateTime', descending: true)
                      .snapshots(),
                  builder: (builder, postsSnapshot) {
                    if (postsSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final usernames = usernameSnapshot.data?.docs ?? [];
                    final posts = postsSnapshot.data?.docs ?? [];

                    return ListView.builder(
                      itemCount: posts.length,
                        itemBuilder: ((context, index) => Post(
                content: posts[index]['content'],
                username: usernames.firstWhere((element) => element.id == posts[index]['userId']).get('username'), 
                likes: posts[index]['likes'], 
                postId: posts[index].id,
                userId: posts[index]['userId'],
                createdAt: posts[index]['dateTime'],
                )));
                
                    //final List<DocumentSnapshot> documents =
                    //   snapshot.data!.docs.toList();
                  });
            }),
      ),
    );
  }

}
