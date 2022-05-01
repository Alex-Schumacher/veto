import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:veto/widgets/home/feed/comment_Icon.dart';
import 'package:veto/widgets/home/feed/like_Icon.dart';
import 'package:veto/widgets/home/feed/post.dart';

import '../widgets/profile/profile_picture.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostScreen extends StatefulWidget {
  final String content;
  final String username;
  final String userId;
  final String postId;
  final List likes;
  final Timestamp createdAt;
  const PostScreen(
      {required this.content,
      required this.createdAt,
      required this.likes,
      required this.postId,
      required this.userId,
      required this.username,
      Key? key})
      : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: RefreshIndicator(
          onRefresh: () {
            return Future.delayed(Duration(seconds: 1), () {
              setState(() {});
            });
          },
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ProfilePicture(
                                userId: FirebaseAuth.instance.currentUser!.uid),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Text(
                              widget.username,
                              style: TextStyle(
                                  fontSize: 24, color: Colors.lightBlue),
                            )),
                            Text(
                              timeago.format(widget.createdAt.toDate(),
                                  locale: 'fr'),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          widget.content,
                          style: TextStyle(fontSize: 30),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            LikeIcon(postId: widget.postId),
                            CommentIcon(
                              ParentPostId: widget.postId,
                              content: widget.content,
                              createdAt: widget.createdAt,
                              likes: widget.likes,
                              userId: widget.userId,
                              username: widget.username,
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: (context, usernameSnapshot) {
                    return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .where('parentPostId',
                                isNull: false, isEqualTo: widget.postId)
                            .snapshots(),
                        builder: (context, postsQuery) {
                          if (postsQuery.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          final usernames = usernameSnapshot.data?.docs ?? [];
                          final posts = postsQuery.data?.docs ?? [];

                          return ListView.builder(
                            shrinkWrap: true,
                              itemCount: posts.length,
                              itemBuilder: ((context, index) => Post(
                                    content: posts[index]['content'],
                                    username: usernames
                                        .firstWhere((element) =>
                                            element.id ==
                                            posts[index]['userId'])
                                        .get('username'),
                                    likes: posts[index]['likes'],
                                    postId: posts[index].id,
                                    userId: posts[index]['userId'],
                                    createdAt: posts[index]['dateTime'],
                                  )));

                          /* return StreamBuilder<QuerySnapshot>(
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
                        */
                        });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
