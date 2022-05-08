import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:veto/screens/post_screen.dart';
import 'package:veto/widgets/home/feed/comment_Icon.dart';
import 'package:veto/widgets/home/feed/like_Icon.dart';
import '../../profile/profile_picture.dart';
import 'package:timeago/timeago.dart' as timeago;

class Post extends StatefulWidget {
  final String content;
  final String username;
  final String userId;
  final String postId;
  final List likes;
  final Timestamp createdAt;
  bool isUsable;
  bool isBill;

  Post(
      {this.isBill = false,
      this.isUsable = true,
      required this.content,
      required this.username,
      required this.likes,
      required this.postId,
      required this.userId,
      required this.createdAt,
      Key? key})
      : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('fr', timeago.FrMessages());
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor, width: 0.5),
      ),
      child: InkWell(
        onTap: () {
          if (widget.isUsable) {
            Navigator.push(context,
                MaterialPageRoute<void>(builder: (BuildContext context) {
              return PostScreen(
                //TODO
                content: widget.content,
                createdAt: widget.createdAt,
                likes: widget.likes,
                postId: widget.postId,
                userId: widget.userId,
                username: widget.username,
                isBill: widget.isBill,
              );
            }));
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfilePicture(userId: widget.userId),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(widget.username)),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            timeago.format(widget.createdAt.toDate(),
                                locale: 'fr'),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Text(
                        widget.content,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.isUsable) ...[
                            SizedBox(
                              width: 20,
                            ),
                            LikeIcon(
                                postId: widget.postId, isBill: widget.isBill),
                            SizedBox(
                              width: 40,
                            ),
                            CommentIcon(
                              //TODO
                              isBill: true,
                              ParentPostId: widget.postId,
                              content: widget.content,
                              createdAt: widget.createdAt,
                              likes: widget.likes,
                              userId: widget.userId,
                              username: widget.username,
                            ),
                            SizedBox(
                              width: 80,
                            )
                          ] else ...[
                            Icon(
                              Icons.favorite,
                              color: widget.likes.contains(
                                      FirebaseAuth.instance.currentUser!.uid)
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            Icon(Icons.chat),
                          ]
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
/*
    Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor, width: 0.5),
      ),
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 17, horizontal: 10),
          child: Row(
            children: [
              ProfilePicture(),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(widget.username),
                      Text(
                        "@${widget.username}",
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                      child: Text(widget.content,
                          style: TextStyle(
                            fontSize: 25,
                          ))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  */
  }
}
