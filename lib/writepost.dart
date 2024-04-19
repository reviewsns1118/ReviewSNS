import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main.dart';
import 'UI.dart';
import 'timeline_page.dart';

final writeprovider = Provider((ref) => "write");

class WritePost extends ConsumerStatefulWidget {
  final Map<String, dynamic>? document;
  WritePost(this.document);

  @override
  ConsumerState<WritePost> createState() => _WritePost(document);
}

class _WritePost extends ConsumerState<WritePost> with RouteAware {
  final Map<String, dynamic>? document;
  _WritePost(this.document);
  int score = 0;
  String rank = 'C';
  String feel = "";
  Color rank_color = Colors.white;
  Map<String, IconData> genreicon = {
    '映画': Icons.theaters,
    '文庫本': Icons.book,
    '漫画': Icons.menu_book,
    'アニメ': Icons.rocket_launch,
    'ゲーム': Icons.videogame_asset,
  };
  bool netabare = false;
  bool ending = false;
  List<String> usingtags = [];
  List<dynamic> poptag = [];

  DocumentReference<Map<String, dynamic>> posts =
      FirebaseFirestore.instance.collection('posts').doc();

  Future<Map<String, dynamic>?> getDoc(
      DocumentReference<Map<String, dynamic>> d) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await d.get();
    return snapshot.data();
  }

  Future<void> searchWhere(String query, String col, String fie) async {
    final result = await FirebaseFirestore.instance
        .collection(col)
        .where(fie, isEqualTo: query)
        .get();
    // リストに、検索して取得したデータを保存する.
    for (final doc in result.docs) {
      poptag.add(doc["tagname"]);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    searchWhere(document!["docid"], "tags", "work");
    poptag.sort((a, b) => b["usenum"].compareTo(a["usenum"]));
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
                  feel = value;
                });
              },
            ),
            Row(
              children: [
                Checkbox(
                  fillColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.white),
                  value: netabare,
                  onChanged: (value) {
                    setState(() {
                      netabare = value!;
                    });
                  },
                  checkColor: Colors.blue,
                ),
                Text(
                  "ネタバレ注意",
                  style: TextStyle(color: Colors.white),
                ),
                Checkbox(
                  fillColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.white),
                  value: ending,
                  onChanged: (value) {
                    setState(() {
                      ending = value!;
                    });
                  },
                  checkColor: Colors.blue,
                ),
                Text(
                  "最後まで見た",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            Text(
              "上位のタグ",
              style: TextStyle(color: Colors.white),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: min(10, poptag.length), // リストの数をlengthで数える.
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    "#${poptag[index]}",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onTap: () {
                    if (usingtags.length <= 10)
                      setState(() {
                        usingtags.add(poptag[index]);
                      });
                  },
                );
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 36,
              ),
              child: TextField(
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                decoration:
                    InputDecoration(fillColor: Colors.white, hintText: 'タグを追加'),
                onSubmitted: (query) {
                  setState(() {
                    if (usingtags.length <= 10) usingtags.add(query);
                  });
                },
              ),
            ),
            Text("追加するタグ(最大10個まで)"),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: usingtags.length, // リストの数をlengthで数える.
              itemBuilder: (context, index) {
                return ListTile(
                  title: TextButton(
                    child: Text("#${usingtags[index]}"),
                    onPressed: () {
                      setState(() {
                        usingtags.remove(usingtags[index]);
                      });
                    },
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () async {
                posts.set({
                  'score': score,
                  'feel': feel,
                  'uid': FirebaseAuth.instance.currentUser!.uid,
                  'work': document!['docid'],
                  "tags": usingtags,
                  "netabare": netabare,
                  "ending": ending,
                  "postid": posts.id,
                  "date": DateTime.now(),
                });
                for (int i = 0; i < usingtags.length; i++) {
                  DocumentReference<Map<String, dynamic>> tags =
                      FirebaseFirestore.instance
                          .collection('tags')
                          .doc(document!['docid'] + usingtags[i]);
                  Map<String, dynamic>? tagmap = await getDoc(tags);
                  tags.get().then((docSnapshot) => {
                        if (docSnapshot.exists)
                          {
                            // 既に登録されているドキュメントの場合
                            tags.update({
                              'usenum': FieldValue.increment(1),
                            })
                          }
                        else
                          {
                            // 登録されてない新しいドキュメントの場合
                            tags.set({
                              'tagname': usingtags[i],
                              'usenum': 1,
                              'work': document!['docid'],
                            })
                          }
                      });
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UI(TimelinePage())),
                );
              },
              child: Text("投稿"),
            )
          ],
        ),
      ),
    );
  }
}
