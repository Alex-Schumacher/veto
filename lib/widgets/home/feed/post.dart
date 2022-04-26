import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../profile/profile_picture.dart';
import 'package:timeago/timeago.dart' as timeago;

class Post extends StatefulWidget {
  final String content;
  final String username;
  final String userId;
  final String postId;
  final List likes;
  final Timestamp createdAt;

  Post(
      {required this.content,
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
        onTap: () {},
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfilePicture(),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(widget.username),
                          SizedBox(
                            width: 10,
                          ),
                          Text(timeago.format(widget.createdAt.toDate(),locale: 'fr'),overflow: TextOverflow.ellipsis,),
                        ],
                      ),
                      Text(
                        widget.content,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [Icon(Icons.chat),Icon(Icons.favorite,),],)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );

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
  }
}
