import 'package:flutter/material.dart';
import 'package:veto/widgets/profile/profile_picture.dart';

class ProfileSettings extends StatefulWidget {
  final String username;
  final String email;
  final String userId;
  const ProfileSettings({required this.email,required this.username,required this.userId,Key? key}) : super(key: key);

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Center(
            child: ProfilePicture(),
          )
        ],
      ),
    );
  }
}
