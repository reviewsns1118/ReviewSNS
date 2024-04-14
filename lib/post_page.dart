import 'package:flutter/material.dart';
import 'add_work.dart';


class PostPage extends StatelessWidget {
  const PostPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:Column(
        children: [
          
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 36,
            ),
            child: TextField(
              style: TextStyle(
                fontSize:18,
                color: Colors.white, 
              ),
              decoration: InputDecoration(
                fillColor: Colors.white,
                hintText: '作品を検索'
               ),
               onSubmitted: (String value){
                print(value);
               },
            ),
          ),
          Text(
            "作品が見つからない時は、ここから追加",
            style: TextStyle(
              color: Colors.white
            ),
          ),
          Text("↓",
            style: TextStyle(
              color: Colors.white
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Add()),
              );
            }, 
            child: Text("作品を追加")
          )
        ],
      ),
    );
  }
}