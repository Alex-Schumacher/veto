import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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

  if (_profilePictureRef.getData() != null) {
    _profilePictureRef.delete();
  }

  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  final _imageFile = File(pickedFile!.path);
  try {
    _profilePictureRef.putFile(_imageFile);
  } catch (err) {
    print("erreur");
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
              children: [
                Center(
                  child: InkWell(
                    child: ProfilePicture(
                      userId: FirebaseAuth.instance.currentUser!.uid,
                    ),
                    onTap: () {
                      uploadImageToFirebase(context);
                    },
                  ),
                ),
                Text('changer de photo de profil')
              ],
            ),
            color: Colors.black,
          ),
          Text(widget.username),
          Text('changer de nom d\'utilisateur'),

          // FirebaseFirestore.instance.collection('users').doc(widget.userId).update({'username': newUsername });

          Text(widget.email),
        ],
      ),
    );
  }
}
