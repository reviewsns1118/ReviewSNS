import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'infoupdate.dart';

class Tweet {
  final String nickname;
  final String iconUrl;
  final String work;
  final String imageURL;
  final int score;
  final String genre; // ジャンルを追加
  bool favorite; // お気に入りを追加
  final String postid;
  Tweet(this.nickname, this.iconUrl, this.work, this.imageURL, this.score,
      this.genre, this.favorite, this.postid);
}

// ジャンルに応じたアイコンを取得する関数
IconData getIconForGenre(String genre) {
  switch (genre) {
    case '映画':
      return Icons.movie;
    case '文庫本':
      return Icons.library_books;
    case '漫画':
      return Icons.menu_book;
    case 'アニメ':
      return Icons.rocket_launch;
    case 'ゲーム':
      return Icons.sports_esports;
    default:
      return Icons.device_unknown; // デフォルトのアイコン
  }
}

// スコアに応じて色を取得する関数
Color getColorForScore(int score) {
  // スコアを整数に変換。不正な値があれば0とする

  if (score >= 90 && score <= 100) {
    return Color(0xFFFFD700); // 金色
  } else if (score >= 80 && score <= 89) {
    return Colors.red; // 赤色
  } else if (score >= 60 && score <= 79) {
    return Colors.blue; // 青色
  } else {
    return Colors.white; // 白色
  }
}

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Future<Map<String, dynamic>?> getDoc(String col, String doc) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection(col).doc(doc).get();
    return snapshot.data();
  }

  Future<List<String>> getlist() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (snapshot.data()?["favorite"] == null)
      return [];
    else {
      return snapshot.data()?["favorite"].cast<String>();
    }
  }

  Future<List<Tweet>> fmodels(String category,String order) async {
    String orderfie;
    bool orderbool;
    if(order=='投稿日時の新しい順'){
      orderfie="date";
      orderbool=true;
    }
    else if(order=='投稿日時の古い順'){
      orderfie="date";
      orderbool=false;
    }
    else if(order=='評価の高い順'){
      orderfie="score";
      orderbool=true;
    }
    else {
      orderfie="score";
      orderbool=false;
    }
    List postlist = [];
    List<String> favoritelist = await getlist();
    await FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy(orderfie,descending: orderbool)
        .get()
        .then(
          (QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach(
              (doc) {
                postlist.add(doc.data());
              },
            ),
          },
        );
    List<Tweet> models = [];
    for (int i = 0; i < min(20, postlist.length); i++) {
      Map<String, dynamic>? work = await getDoc("works", postlist[i]["work"]);
      if (work?["genre"] == category) {
        Map<String, dynamic>? user = await getDoc("users", postlist[i]["uid"]);
        models.add(Tweet(
          user?["nickname"],
          'assets/images/icon${(i % 11) + 1}.png',
          work?["title"],
          work?["imageURL"],
          postlist[i]["score"],
          work?["genre"],
          favoritelist.contains(postlist[i]["postid"]),
          postlist[i]["postid"],
        ));
      }
    }

    return models;
  }

// モデルをウィジェットに変換する関数
  Widget modelToWidget(Tweet model) {
    // obiウィジェット：アイコンとユーザー名を横に並べる
    final obi = Row(
      children: [
        Container(
          padding: EdgeInsets.all(1), // 枠とアイコンの間のスペース
          decoration: BoxDecoration(
            shape: BoxShape.circle, // 枠の形状を円形にする
            border: Border.all(
              color: Colors.grey, // 枠線の色を灰色にする
              width: 1.0, // 枠線の幅を2.0にする
            ),
          ),
          child: CircleAvatar(
            radius: 14, // アイコンのサイズを設定
            backgroundImage: NetworkImage(model.iconUrl), // ユーザーの画像を表示
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            model.nickname,
            style:
                const TextStyle(fontSize: 12, color: Colors.white), // 文字色を白に設定
          ),
        ),
      ],
    );

    // naiyouウィジェット：作品名、作品画像、評価スコアを縦に並べる
    final naiyou = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
              horizontal: 8, vertical: 8), // 画像の枠の外側に左右上下に余白を追加
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey, // 枠の色を指定
              width: 2, // 枠の太さを指定
            ),
            borderRadius: BorderRadius.circular(8), // 枠の角を丸くする（オプション）
          ),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(model.imageURL, fit: BoxFit.cover),
            ),
          ),
        ),
        Text(
          model.work,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.white), // 文字色を白に設定
        ),
        SizedBox(height: 8), // 作品名とスコアの間に8ピクセルの余白を追加
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0), // 左端のアイコンに左側の余白を追加
              child: Icon(
                getIconForGenre(model.genre), // ジャンルに応じたアイコンを取得
                color: Colors.white,
                size: 24,
              ),
            ),
            Row(
                mainAxisSize: MainAxisSize.min, // 必要最小限の幅を使用
                children: [
                  Text(
                    '${model.score}', // スコアの値
                    style: TextStyle(
                      color: getColorForScore(model.score), // スコアに応じた色
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // "点"表示（白色で少し小さな文字サイズ）
                  Text(
                    '点',
                    style: TextStyle(
                      color: Colors.white, // 白色を指定
                      fontSize: 12, // スコアよりも小さな文字サイズ
                    ),
                  ),
                ]),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: Icon(model.favorite ? Icons.done : Icons.add),
                color: model.favorite ? Colors.green : Colors.white, // 緑色に変更
                onPressed: () {
                  if (!model.favorite) {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({
                      'favorite': FieldValue.arrayUnion([model.postid])
                    });
                    setState(() {
                      model.favorite = true;
                    });
                  } else {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({
                      'favorite': FieldValue.arrayRemove([model.postid])
                    });
                    setState(() {
                      model.favorite = false;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );

    // obiとnaiyouをColumnで縦に並べる
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          obi,
          naiyou,
        ],
      ),
    );
  }

  String dropdownValue = '投稿日時の新しい順'; // 初期選択値を設定

  Future<String> getUser(String s) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return snapshot.data()![s] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: CircleAvatar(
                    backgroundImage: NetworkImage(
                        FirebaseAuth.instance.currentUser?.photoURL ?? ''),
                    radius: 35,
                  ),
                  color: Colors.white,
                  iconSize: 80,
                  onPressed: () async {
                    String nickname = await getUser('nickname');
                    String introduction = await getUser('introduction');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Infoupdate(nickname, introduction),
                      ),
                    );
                  },
                ),
              ],
            ),
            // 既存の情報
            FutureBuilder(
              future: getUser('nickname'),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Text(
                  snapshot.data ?? "Guest",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold), // 太字に変更
                );
              },
            ),
            FutureBuilder(
              future: getUser('introduction'),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Text(
                  snapshot.data ?? "",
                  style: const TextStyle(color: Colors.white),
                );
              },
            ),
            // タブバーとコンテンツ
            Expanded(
              child: Column(
                children: [
                  Container(
                    color: Colors.black,
                    child: TabBar(
                      indicatorColor: Colors.white, // 選択されているタブの色を白に設定
                      labelColor: Colors.white, // 選択されているタブのタブ名の色を白に設定
                      indicatorSize:
                          TabBarIndicatorSize.tab, // インジケーターのサイズをタブのサイズに設定
                      tabs: [
                        Tab(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.rocket_launch), // アイコンを追加
                              SizedBox(width: 5), // アイコンとテキストの間にスペースを追加
                              Text('Anime'), // タブ1
                            ],
                          ),
                        ),
                        Tab(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.menu_book), // アイコンを追加
                              SizedBox(width: 5), // アイコンとテキストの間にスペースを追加
                              Text('Comic'), // タブ2
                            ],
                          ),
                        ),
                        Tab(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.sports_esports), // アイコンを追加
                              SizedBox(width: 5), // アイコンとテキストの間にスペースを追加
                              Text('Game'), // タブ3
                            ],
                          ),
                        ),
                        Tab(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.local_movies), // アイコンを追加
                              SizedBox(width: 5), // アイコンとテキストの間にスペースを追加
                              Text('Movie'), // タブ4
                            ],
                          ),
                        ),
                        Tab(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.music_note), // アイコンを追加
                              SizedBox(width: 5), // アイコンとテキストの間にスペースを追加
                              Text('Music'), // タブ5
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // タブ1の内容
                        buildDropdown('アニメ'),
                        // タブ2の内容
                        buildDropdown('漫画'),
                        // タブ3の内容
                        buildDropdown('ゲーム'),
                        // タブ4の内容
                        buildDropdown('映画'),
                        // タブ5の内容
                        buildDropdown('音楽'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropdown(String category) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: PopupMenuButton<String>(
            initialValue: dropdownValue,
            color: Colors.black, // ポップアップメニューの背景色を黒に設定
            onSelected: (String value) {
              setState(() {
                dropdownValue = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: '投稿日時の新しい順',
                  child: Text(
                    '投稿日時の新しい順',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: '投稿日時の古い順',
                  child: Text(
                    '投稿日時の古い順',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: '評価の高い順',
                  child: Text(
                    '評価の高い順',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: '評価の低い順',
                  child: Text(
                    '評価の低い順',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ];
            },
            child: Row(
              children: [
                Text(
                  dropdownValue,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: FutureBuilder(
              future: fmodels(category,dropdownValue),
              builder: (context, snapshot) {
                List<Tweet>? models = snapshot.data;
                if (models == null)
                  return Text(
                    "Now Loading...",
                    style: TextStyle(color: Colors.white),
                  );
                else
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5), // 左右に5ピクセルの余白を追加
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 一行に表示するアイテムの数
                      crossAxisSpacing: 0, // アイテム間の水平スペース
                      mainAxisSpacing: 0, // アイテム間の垂直スペース
                      childAspectRatio: 13 / 13,
                    ),
                    itemCount: models!.length,
                    itemBuilder: (context, index) {
                      // ここで各投稿をウィジェットに変換

                      return modelToWidget(snapshot.data![index]);
                    },
                  );
              }),
        ),
      ],
    );
  }
}
