import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  final String userId;
  const ProfilePicture({required this.userId, Key? key}) : super(key: key);

  Future<String> getUserProfilePicture() async {
    final imageRef =
        FirebaseStorage.instance.ref().child('ProfilePictures/' + userId);
    
    var url;
    try {
      url = await imageRef.getDownloadURL();
    } catch (err) {
      print("erreur");
      url = "N/A";
    }

    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: new BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255), shape: BoxShape.circle),
      child: FutureBuilder<String>(
          future: getUserProfilePicture(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                if (snapshot.data != "N/A") {
                  return CircleAvatar(
                      foregroundImage: NetworkImage(snapshot.data!));
                }
              }
              return CircleAvatar(
                foregroundImage:
                    Image.asset('assets/images/DefaultProfilePicture.png')
                        .image,
                backgroundColor: Colors.grey,
              );
            }

            return CircleAvatar(
              backgroundColor: Theme.of(context).hintColor,
            );
          }),
    );
  }
}
