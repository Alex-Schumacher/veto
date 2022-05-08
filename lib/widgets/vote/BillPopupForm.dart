import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BillPopupForm extends StatefulWidget {
  final VoidCallback onSubmited;
  const BillPopupForm({required this.onSubmited, Key? key}) : super(key: key);

  @override
  State<BillPopupForm> createState() => _BillPopupFormState();
}

class _BillPopupFormState extends State<BillPopupForm> {
  final _formKey = GlobalKey<FormState>();

  var _content = '';
  var _name = '';
  var _code = '';

  CollectionReference bills = FirebaseFirestore.instance.collection('bills');
  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();

      bills
          .add({
            'dateTime': Timestamp.now(),
            'userId': FirebaseAuth.instance.currentUser!.uid,
            'billName': _name,
            'billContent': _content,
            'billPseudoCode': _code,
            'upvotes': FieldValue.arrayUnion(List.empty()),
            'parentBillId': 'rootBill',
          })
          .then((value) => print('post Added'))
          .catchError((err) {
            print('erreur');
          });
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
                            _content.isEmpty ||
                                    _content.length >= 255 ||
                                    _name.isEmpty ||
                                    _name.length >= 80
                                ? Theme.of(context).disabledColor
                                : Colors.lightBlue)),
                    child: Text("Submit"),
                    onPressed: () {
                      if ((_content.isNotEmpty && _content.length < 255) &&
                          (_name.isNotEmpty && _name.length < 80)) {
                        _trySubmit();
                        widget.onSubmited();
                        Navigator.of(context).pop();
                      } else {
                        showDialog(
                            useRootNavigator: false,
                            context: context,
                            builder: (BuildContext builder) {
                              var _errorText = "";

                              if (_name.isEmpty) {
                                _errorText += "*Vous devez avoir un titre.\n";
                              } else if (_name.length >= 80) {
                                _errorText +=
                                    "*Vous ne pouvez pas avoir plus de 80 charactères dans votre titre.\n";
                              }

                              if (_content.isEmpty)
                                _errorText +=
                                    "*Vous devez décrire votre idée pour pouvoir la proposer .";
                              else if (_content.length >= 255)
                                _errorText +=
                                    "*Vous ne pouvez pas avoir plus de 255 charactères sur votre post.";

                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32))),
                                content: Text(
                                  _errorText,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context).errorColor),
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
                child: Material(
              child: TextFormField(
                key: ValueKey('billName'),
                minLines: 1,
                maxLines: 2,
                decoration: InputDecoration(
                    labelText: 'Décrivez en quelque mots votre idée'),
                validator: (value) {
                  if (value!.isEmpty || value.length > 80) {
                    return "Veuillez définir le titre en dessous de 80 charactères";
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
                onSaved: (value) {
                  if (value!.isNotEmpty && value.length >= 80) {
                    _content = value;
                  }
                },
              ),
            )),

            Form(
                key: _formKey,
                child: Expanded(
                  child: Material(
                    child: TextFormField(
                      key: ValueKey('billContent'),
                      minLines: null,
                      maxLines: null,
                      expands: true,
                      autocorrect: true,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          labelText: "Présentez votre idée",
                          alignLabelWithHint: true),
                      validator: (value) {
                        if (value!.isEmpty || value.length >= 255) {
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
                        }
                      },
                    ),
                  ),
                )),
            Form(
                child: Expanded(
                    child: Material(
              child: TextFormField(
                key: ValueKey('code'),
                minLines: null,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                    labelText:
                        "Si vous avez envie,écrivez votre pseudo-code ici",
                    alignLabelWithHint: true),
                onChanged: (value) {
                  setState(() {
                    _code = value;
                  });
                },
                onSaved: (value) {
                  if (value!.isEmpty) {
                    value = "";
                  }
                  _content = value;
                },
              ),
            )))
            //TODO: ajouter un cercle montrant combien il reste de mots
          ],
        ),
      ),
    );
  }
}
