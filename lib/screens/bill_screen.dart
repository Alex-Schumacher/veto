import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veto/widgets/home/feed/comment_Icon.dart';
import 'package:veto/widgets/home/feed/post.dart';
import 'package:veto/widgets/profile/profile_picture.dart';
import 'package:veto/widgets/vote/Bill.dart';
import 'package:timeago/timeago.dart' as timeago;

class BillScreen extends StatefulWidget {
  String id;
  String billContent;
  String Billname;
  String billPseudoCode;
  String parentBill;
  Timestamp date;
  List upvotes;
  String userId;
  String username;
  bool isUsable;
  BillScreen(
      {required this.isUsable,
      required this.username,
      required this.Billname,
      required this.billPseudoCode,
      required this.date,
      required this.parentBill,
      required this.userId,
      required this.id,
      required this.billContent,
      required this.upvotes,
      Key? key})
      : super(key: key);

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () {
          return Future.delayed(Duration(seconds: 1), () {
            setState(() {});
          });
        },
        child: Material(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ProfilePicture(userId: widget.userId, size: 70),
                        Column(
                          children: [
                            Text(
                              widget.username,
                              style: TextStyle(
                                  color: Colors.lightBlue, fontSize: 25),
                            ),
                            Text(
                              timeago.format(widget.date.toDate(),
                                  locale: 'fr'),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
                Text(
                  'Explication',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
                Text(
                  widget.billContent,
                  style: TextStyle(fontSize: 22),
                ),
                if (widget.billPseudoCode != "") ...{
                  Divider(),
                  Text(
                    'PseudoCode',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                },
                Text(widget.billPseudoCode, style: TextStyle(fontSize: 22)),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flex(direction: Axis.vertical),
                    CommentIcon(
                      ParentPostId: widget.id,
                      content: widget.billContent,
                      createdAt: widget.date,
                      likes: widget.upvotes,
                      userId: widget.userId,
                      username: widget.username,
                      isBill: true,
                    ),
                  ],
                ),
                Divider(),
                Text(
                  'Commentaires',
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .snapshots(),
                      builder: (context, usernameSnapshot) {
                        return StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('bills')
                                .where('parentBillId',
                                    isNull: false, isEqualTo: widget.id)
                                .snapshots(),
                            builder: (context, billsQuery) {
                              if (billsQuery.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }
                              final usernames =
                                  usernameSnapshot.data?.docs ?? [];
                              final billsUnordered =
                                  billsQuery.data?.docs ?? [];
                              final bills = Mapping(billsUnordered);
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: bills.length,
                                  itemBuilder: ((context, index) => Post(
                                        content: bills[index]['billContent'],
                                        username: usernames
                                            .firstWhere((element) =>
                                                element.id ==
                                                bills[index]['userId'])
                                            .get('username'),
                                        likes: bills[index]['upvotes'],
                                        postId: bills[index].id,
                                        userId: bills[index]['userId'],
                                        createdAt: bills[index]['dateTime'],
                                        isUsable: true,
                                        isBill: true,
                                      )));
                            });
                      }),
                ),
              ],
            ),
          ),
        ));
  }

  List Mapping(List<DocumentSnapshot<Object?>> documents) {
    documents.sort((a, b) {
      List aVotes = a['upvotes'];
      List bVotes = b['upvotes'];
      return aVotes.length.compareTo(bVotes.length);
    });
    documents = documents.reversed.toList();
    return documents;
  }
}
