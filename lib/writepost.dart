import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

class WritePost extends StatefulWidget {
  WritePost(this.document);
  Map<String, dynamic>? document;

  @override
  State<WritePost> createState() => _WritePostState(document);
}

class _WritePostState extends State<WritePost> {
  _WritePostState(this.document);
  Map<String, dynamic>? document;
  int score = 0;
  String rank = 'C';
  Color rank_color = Colors.white;
  Map<String, IconData> genreicon = {
    '映画': Icons.theaters,
    '文庫本': Icons.book,
    '漫画': Icons.menu_book,
    'アニメ': Icons.rocket_launch,
    'ゲーム': Icons.videogame_asset,
  };

  CollectionReference works = FirebaseFirestore.instance.collection('works');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        // タイトルテキスト
        title: Text(
          'Thoughts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Row(children: [
                Icon(
                  genreicon[document!["genre"]],
                  color: Colors.white,
                ),
                Image(
                  image: NetworkImage(document!["imageURL"]),
                  height: 45,
                  width: 60,
                ),
                Text(
                  document!["title"],
                  style: TextStyle(color: Colors.white),
                )
              ]),
            ),
            TextField(
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                fillColor: Colors.white,
                hintText: '点数(0-100点)',
                icon: Text(
                  rank,
                  style: TextStyle(color: rank_color),
                ),
              ),
              onChanged: (String value) {
                setState(() {
                  score = int.parse(value);
                  if (score < 60) {
                    rank = 'C';
                    rank_color = Colors.white;
                  } else if (score < 80) {
                    rank = 'B';
                    rank_color = Colors.blue;
                  } else if (score < 80) {
                    rank = 'A';
                    rank_color = Colors.red;
                  } else {
                    rank = 'S';
                    rank_color = Colors.yellow;
                  }
                });
              },
            ),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                fillColor: Colors.white,
                hintText: '感想を書く',
              ),
              onChanged: (String value) {
                setState(() {
                  score = int.parse(value);
                  if (score < 60) {
                    rank = 'C';
                    rank_color = Colors.white;
                  } else if (score < 80) {
                    rank = 'B';
                    rank_color = Colors.blue;
                  } else if (score < 80) {
                    rank = 'A';
                    rank_color = Colors.red;
                  } else {
                    rank = 'S';
                    rank_color = Colors.yellow;
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
