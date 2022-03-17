import 'package:flutter/material.dart';
import 'package:veto/widgets/home/post.dart';


class Feed extends StatelessWidget {
  const Feed({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Post("test content", "username1"),
            Post("test contentasdf", "username2"),
            Post("test contentasdfasédflkjasdfléajsdf", "u234234"),
            Post("a", "23459807324"),
            Post("pog", "548587585"),
            Post("pog2", "548587585"),
            Post("pog3", "548587585"),
          ],

        ),

      ),
    );
  }
}