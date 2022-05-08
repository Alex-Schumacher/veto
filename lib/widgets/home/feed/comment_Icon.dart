import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:veto/screens/comment_screen.dart';

class CommentIcon extends StatefulWidget {
  final String ParentPostId;
  final String content;
  final String username;
  final List likes;
  final String userId;
  final Timestamp createdAt;
  final bool isBill;
  const CommentIcon(
      {this.isBill = false,
      required this.content,
      required this.createdAt,
      required this.likes,
      required this.userId,
      required this.username,
      required this.ParentPostId,
      Key? key})
      : super(key: key);

  @override
  State<CommentIcon> createState() => _CommentIconState();
}

class _CommentIconState extends State<CommentIcon> {
  void UpdateMain() {}

  @override
  Widget build(BuildContext context) {
    return Container(
        child: InkWell(
      child: Padding(padding: EdgeInsets.all(10), child: Icon(Icons.chat)),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext builder) => CommentScreen(
                onSubmitted: () => UpdateMain(),
                parentPostId: widget.ParentPostId,
                content: widget.content,
                createdAt: widget.createdAt,
                likes: widget.likes,
                userId: widget.userId,
                username: widget.username,
                isbill: widget.isBill,
              ),
            ));
      },
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ));
  }
}
