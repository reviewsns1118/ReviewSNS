import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

class TimelinePage extends StatefulWidget {
  const TimelinePage({Key? key}) : super(key: key);
  @override
  State<TimelinePage> createState() => _TimelinePage();
}

class _TimelinePage extends State<TimelinePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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

  Future<List<Tweet>> fmodels() async {
    List postlist = [];
    List<String> favoritelist = await getlist();

    await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('date') // 追加日昇順に並び替え
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
    postlist = List.from(postlist.reversed);
    List<Tweet> models = [];
    for (int i = 0; i < min(20, postlist.length); i++) {
      Map<String, dynamic>? user = await getDoc("users", postlist[i]["uid"]);
      Map<String, dynamic>? work = await getDoc("works", postlist[i]["work"]);
      models.add(Tweet(
        user?["nickname"],
        user?["photoURL"],
        work?["title"],
        work?["imageURL"],
        postlist[i]["score"],
        work?["genre"],
        favoritelist.contains(postlist[i]["postid"]),
        postlist[i]["postid"],
      ));
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
            backgroundColor: Color.fromARGB(255, Random().nextInt(256), Random().nextInt(256), Random().nextInt(256)),
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
    return InkWell(
      onTap: () {
        context.goNamed(
          'posts',
          pathParameters: {'postid': model.postid},
        );
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            obi,
            naiyou,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black, // Scaffoldの背景色を黒に設定
      body: FutureBuilder(
          future: fmodels(),
          builder: (context, snapshot) {
            List<Tweet>? models = snapshot.data;
            if (models == null)
              return Text(
                "Now Loading...",
                style: TextStyle(color: Colors.white),
              );
            else
              return GridView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5), // 左右に5ピクセルの余白を追加
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 一行に表示するアイテムの数
                  crossAxisSpacing: 0, // アイテム間の水平スペース
                  mainAxisSpacing: 0, // アイテム間の垂直スペース
                  childAspectRatio: 13 / 13,
                ),
                itemCount: models.length,
                itemBuilder: (context, index) {
                  // ここで各投稿をウィジェットに変換

                  return modelToWidget(snapshot.data![index]);
                },
              );
          }),
    );
  }
}
