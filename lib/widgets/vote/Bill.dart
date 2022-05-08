import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:veto/screens/bill_screen.dart';

class Bill extends StatefulWidget {
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

  Bill(
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
  State<Bill> createState() => _BillState();
}

class _BillState extends State<Bill> {
  bool _isInit = false;
  late bool _isUpvoted;
  var userId = FirebaseAuth.instance.currentUser!.uid;

  void isUpvoted() {
    _isUpvoted = widget.upvotes.contains(userId);
  }

  void Init() {
    if (!_isInit) {
      isUpvoted();
      _isInit = true;
    }
  }

  void ChangeUpvote() async {
    var _cacheIsUpvoted = false;
    List list = [widget.userId];
    switch (_isUpvoted) {
      case false:
        try {
          FirebaseFirestore.instance.collection('bills').doc(widget.id).update(
              <String, dynamic>{'upvotes': FieldValue.arrayUnion(list)});
        } catch (err) {
          print(err);
          return;
        }

        _cacheIsUpvoted = true;
        break;
      case true:
        try {
          FirebaseFirestore.instance.collection('bills').doc(widget.id).update(
              <String, dynamic>{'upvotes': FieldValue.arrayRemove(list)});
          /*FirebaseFirestore.instance
              .collection('bills')
              .doc(widget.id)
              .update
              */
        } catch (err) {
          print(err);
          return;
        }
        _cacheIsUpvoted = false;
    }
    setState(() {
      switch (_cacheIsUpvoted) {
        case true:
          widget.upvotes.add(userId);
          break;
        case false:
          widget.upvotes.remove(userId);
      }

      _isUpvoted = _cacheIsUpvoted;
    });
  }

  @override
  Widget build(BuildContext context) {
    Init();
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.arrow_upward,
                      color: _isUpvoted
                          ? Colors.blue
                          : Theme.of(context).hintColor),
                ),
                onTap: () {
                  ChangeUpvote();
                  //   isUpvoted = !isUpvoted;
                  //  if (isUpvoted) add = -1;
                },
              ),
              Text(widget.upvotes.length.toString()),
            ],
          ),
          Expanded(
            child: InkWell(
              onTap: (() {
                if (widget.isUsable) {
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => BillScreen(
                                Billname: widget.Billname,
                                billContent: widget.billContent,
                                billPseudoCode: widget.billPseudoCode,
                                date: widget.date,
                                id: widget.id,
                                isUsable: widget.isUsable,
                                parentBill: widget.parentBill,
                                upvotes: widget.upvotes,
                                userId: widget.userId,
                                username: widget.username,
                              )));
                }
              }),
              child: Card(
                child: ListTile(
                  title: Text(widget.Billname),
                  subtitle: Text(widget.username),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
