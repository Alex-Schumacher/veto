import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';

import '../../screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class PopupForm extends StatefulWidget {
 final  VoidCallback onSubmited;
  PopupForm({required this.onSubmited, Key? key}) : super(key: key);

  @override
  State<PopupForm> createState() => _PopupFormState();
}

class _PopupFormState extends State<PopupForm> {
  final _formKey = GlobalKey<FormState>();

  var _content = '';

  CollectionReference posts = FirebaseFirestore.instance.collection('posts');
  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
  
      posts
          .add({
            'dateTime': Timestamp.now(),
            'userId': FirebaseAuth.instance.currentUser!.uid,
            'content': _content,
            'likes' : FieldValue.arrayUnion(List.empty()),

          })
          .then((value) => print('post Added'))
          .catchError((err) {
            print(err);
          });

      ///Utiliser les variables pour la requête d'authentification
    }
  }

  @override
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
                            _content.isEmpty || _content.length >= 255
                                ? Theme.of(context).disabledColor
                                : Colors.lightBlue)),
                    child: Text("Submit"),
                    onPressed: () {
                      if (_content.isNotEmpty && _content.length < 255) {
                        _trySubmit();
                        widget.onSubmited();
                        Navigator.of(context).pop();
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext builder) {
                              var _errorText = "";
                              if (_content.isEmpty)
                                _errorText =
                                    "Vous devez avoir au moins un charactère pour pouvoir envoyer un post";
                              if (_content.length >= 255)
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
                          labelText: "Votre message", alignLabelWithHint: true),
                      validator: (value) {
                        if (value!.isEmpty && value.length >= 255) {
                          //TODO: RAJOUTER UNE LISTE DE MOTS INTERDITS
                          return 'Veuillez écrire un message pour pouvoir l\'envoyer';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _content = value;
                        });
                      },
                      onSaved: (value) {
                        if (value!.isNotEmpty && value.length >= 255) {
                          _content = value;
                          print(_content);
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
