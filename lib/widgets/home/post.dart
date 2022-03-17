import 'package:flutter/material.dart';
import '../profile/profile_picture.dart';


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
    return Stack(
      alignment: Alignment.topLeft,
children: <Widget>[

  InkWell(
    child: Column(mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
         
        children: [
          ProfilePicture(),
          Text(widget.username,textAlign: TextAlign.left,style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
        ],
       


      )
       ,
      Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
        color: Color( 0x330066 ),
        borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        child: Container(child: Column(children: [
            
            Container(child:  Text(widget.content,textAlign: TextAlign.left),)
    
        ],
        mainAxisAlignment: MainAxisAlignment.end,
        
        ))),
         
    ],
    
    
     ),
    
  )
],

      
    );
  }
}
