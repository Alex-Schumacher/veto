import 'package:flutter/material.dart';
import '../../profile/profile_picture.dart';

class Post extends StatefulWidget {
  final String content;
  final String username;

  Post(this.content, this.username, {Key? key}) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> { 
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor, width: 0.5),
        
      ),
      
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 17,horizontal: 10),
          child: Row(
            children: [
              ProfilePicture(),
              SizedBox(
                width: 10,
                
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(widget.username),
                      
                      Text(
                        "@${widget.username}",
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            
                            ),
              
                      )
                    ],
                  ),
                  SizedBox(height: 5,),
                  Expanded(child: Text(widget.content,style: TextStyle(fontSize: 25,))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
