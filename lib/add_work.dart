import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'writepost.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  State<Add> createState() => AddWork();
}

class AddWork extends State<Add> {
  String isSelectedValue = '映画';
  String title = '';
  String author = '';
  String imageURL = '';
  String imageref = '';
  Map<String, String> authors = {
    '映画': '監督',
    '文庫本': '作者',
    '漫画': '作者',
    'アニメ': '制作会社',
    'ゲーム': '制作会社',
  };

  DocumentReference<Map<String, dynamic>> works =
      FirebaseFirestore.instance.collection('works').doc();
  Future<Map<String, dynamic>?> getDoc() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await works.get();
    return snapshot.data();
  }

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
                child: Text(
                  "タイトル(必須)",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              TextField(
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                    fillColor: Colors.white, hintText: '作品名を入力'),
                onChanged: (String value) {
                  title = value;
                },
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "ジャンル(必須)",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 36,
                ),
                child: DropdownButton(
                  dropdownColor: Colors.grey,
                  items: const [
                    DropdownMenuItem(
                      value: '映画',
                      child: Text(
                        "映画",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DropdownMenuItem(
                      value: '文庫本',
                      child: Text(
                        "文庫本",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DropdownMenuItem(
                      value: '漫画',
                      child: Text(
                        "漫画",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'アニメ',
                      child: Text(
                        "アニメ",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'ゲーム',
                      child: Text(
                        "ゲーム",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      isSelectedValue = value!;
                    });
                  },
                  value: isSelectedValue,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  authors[isSelectedValue] ?? "作者",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              TextField(
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintText: '${authors[isSelectedValue]}を入力'),
                onChanged: (String value) {
                  author = value;
                },
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "サムネイル(アスペクト比 4:3 推奨)",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              TextField(
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                    fillColor: Colors.white, hintText: '画像のアドレス'),
                onChanged: (String value) {
                  setState(() {
                    imageURL = value;
                  });
                },
              ),
              TextField(
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                    fillColor: Colors.white, hintText: '引用元URL'),
                onChanged: (String value) {
                  imageref = value;
                },
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "画像のプレビュー",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Image(
                image: NetworkImage(imageURL),
                height: 150,
                width: 200,
              ),
              ElevatedButton(
                onPressed: () async {
                  works.set({
                    'title': title,
                    'genre': isSelectedValue,
                    'author': author,
                    'imageURL': imageURL,
                    'imageref': imageref,
                  });
                  Map<String, dynamic>? d = await getDoc();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WritePost(d)),
                  );
                },
                child: Text("追加"),
              )
            ],
          ),
        )
    );
  }
}
