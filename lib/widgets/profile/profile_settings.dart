import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:veto/widgets/profile/profile_picture.dart';

class ProfileSettings extends StatefulWidget {
  final String username;
  final String email;
  final String userId;
  const ProfileSettings(
      {required this.email,
      required this.username,
      required this.userId,
      Key? key})
      : super(key: key);

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

var _storageRef = FirebaseStorage.instance.ref();

Future uploadImageToFirebase(BuildContext context) async {
  var _profilePictureRef = _storageRef
      .child('ProfilePictures/' + FirebaseAuth.instance.currentUser!.uid);

  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile == null) {
    return;
  }
  var databaseData = true;
  try {
    await _profilePictureRef.getData();
  } catch (err) {
    databaseData = false;
  }

  if (databaseData) {
    _profilePictureRef.delete();
  }

  final _imageFile = File(pickedFile.path);
  try {
    _profilePictureRef.putFile(_imageFile);
  } catch (err) {
    print("profile_erreur");
  }
}

class _ProfileSettingsState extends State<ProfileSettings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: InkWell(
                    child: Center(
                      child: ProfilePicture(
                        size: 100,
                        userId: FirebaseAuth.instance.currentUser!.uid,
                      ),
                    ),
                    onTap: () {
                      uploadImageToFirebase(context);
                      setState(() {});
                    },
                  ),
                ),
                Text('changer de photo de profil')
              ],
            ),
            color: Theme.of(context).cardColor,
          ),
          SizedBox(height: 40),
          Text(widget.username),
          SizedBox(
            height: 10,
          ),

          // FirebaseFirestore.instance.collection('users').doc(widget.userId).update({'username': newUsername });

          Text(widget.email),
        ],
      ),
    );
  }
}
