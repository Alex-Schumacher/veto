import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LikeIcon extends StatefulWidget {
  final String postId;
  LikeIcon({required this.postId, Key? key}) : super(key: key);

  @override
  State<LikeIcon> createState() => LikeIconState();
}

class LikeIconState extends State<LikeIcon> {
  late List likes;
  bool _isInit = false;
  late bool _isLiked;
  var userId = FirebaseAuth.instance.currentUser!.uid;

  void isUpvoted() {
    _isLiked = likes.contains(userId);
  }

  void Init() {
  
      isUpvoted();

  }

  void ChangeLike() async {
    var _cacheIsUpvoted = false;
    List list = [userId];
    switch (_isLiked) {
      case false:
        try {
          
         await FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.postId)
              .update(<String, dynamic>{'likes': FieldValue.arrayUnion(list)});
              
        } catch (err) {
          print(err);
          return;
        }

        _cacheIsUpvoted = true;
        break;
      case true:
        try {
          
         await  FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.postId)
              .update(<String, dynamic>{'likes': FieldValue.arrayRemove(list)});
               


          /*FirebaseFirestore.instance
              .collection('bills')
              .doc(widget.id)
              .update
              */
        } catch (err) {
          print('erreur');
          return;
        }
        _cacheIsUpvoted = false;
    }

    
    setState(() {
      switch (_cacheIsUpvoted) {
        case true:
          likes.add(userId);
          break;
        case false:
          likes.remove(userId);
      }

      _isLiked = _cacheIsUpvoted;
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .get(),
        builder: (context, likeQuery) {
         
          
          if (likeQuery.connectionState == ConnectionState.done) {
            likes = likeQuery.data?['likes'];
            Init();
            return Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.favorite,
                          color: _isLiked ? Colors.red : Colors.grey)),
                  onTap: () {
                    ChangeLike();
                  },
                ),
                Text(likes.length.toString()),
              ],
            );
          }
            return Row(
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.favorite, color: Colors.grey)),
                Text('0')
              ],
            );
          
        });
  }
}
