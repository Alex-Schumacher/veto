import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:veto/widgets/home/feed/post.dart';

class CommentScreen extends StatefulWidget {
  final VoidCallback onSubmitted;
  final String parentPostId;  
  final String content;
  final String username;
  final List likes;
  final String userId;
  final Timestamp createdAt; 
  const CommentScreen(
      {required this.content,required this.createdAt,required this.likes,required this.userId,required this.username,required this.parentPostId, required this.onSubmitted, Key? key})
      : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final _formKey = GlobalKey<FormState>();

  var _comment = '';
  @override
  CollectionReference postsReference =
      FirebaseFirestore.instance.collection('posts');

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();

      postsReference
          .add({
            'dateTime': Timestamp.now(),
            'userId': FirebaseAuth.instance.currentUser!.uid,
            'content': _comment,
            'likes': FieldValue.arrayUnion(List.empty()),
            'parentPostId': widget.parentPostId
          })
          .then((value) => print('comment added'))
          .catchError((err) {
            print('erreur');
          });
    }
  }

  Widget build(BuildContext context) {
    var _isLoading = false;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkResponse(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.close),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            _comment.isEmpty || _comment.length >= 255
                                ? Theme.of(context).disabledColor
                                : Colors.lightBlue)),
                    child: Text("Submit"),
                    onPressed: () {
                      if (_comment.isNotEmpty && _comment.length < 255) {
                        _trySubmit();
                        widget.onSubmitted();
                        Navigator.of(context).pop();
                      } else {
                        showDialog(
                          useRootNavigator: false,
                            context: context,
                            builder: (BuildContext builder) {
                              var _errorText = "";
                              if (_comment.isEmpty)
                                _errorText =
                                    "Vous devez avoir au moins un charactère pour pouvoir envoyer un post";
                              if (_comment.length >= 255)
                                _errorText =
                                    "Vous ne pouvez pas avoir plus de 255 charactères sur votre post";
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32))),
                                content: Text(
                                  _errorText,
                                  style: TextStyle(fontSize: 20),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        setState(() {});
                                      },
                                      child: Text(
                                        "ok",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ))
                                ],
                              );
                            });
                      }
                    },
                  ),
                ),
              ],
            ),

          
        Post(isUsable: false,content: widget.content, username: widget.username, likes: widget.likes, postId: widget.parentPostId, userId: widget.userId, createdAt: widget.createdAt),
                    

                  
          

            Form(
                key: _formKey,
                child: Expanded(
                  child: Material(
                    child: TextFormField(
                      minLines: null,
                      maxLines: null,
                      expands: true,
                      key: ValueKey('content'),
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          labelText: "Votre commentaire", alignLabelWithHint: true),
                      validator: (value) {
                        if (value!.isEmpty && value.length >= 255) {
                          //TODO: RAJOUTER UNE LISTE DE MOTS INTERDITS
                          return 'Veuillez écrire un message pour pouvoir l\'envoyer';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _comment = value;
                        });
                      },
                      onSaved: (value) {
                        if (value!.isNotEmpty && value.length >= 255) {
                          _comment = value;
                          print(_comment);
                        }
                      },
                    ),
                  ),
                )),
            //TODO: ajouter un cercle montrant combien il reste de mots
          ],
        ),
      ),
    );
  }
}
