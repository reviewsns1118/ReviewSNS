import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'main.dart';

class Tweet {
  final String nickname;
  final String iconUrl;
  final String work;
  final String imageURL;
  final int score;
  final String genre; // ジャンルを追加
  final bool favorite; // お気に入りを追加
  Tweet(this.nickname, this.iconUrl, this.work, this.imageURL, this.score,
      this.genre, this.favorite);
}

final List<String> genres = [
  '映画',
  '文庫本',
  '漫画',
  'アニメ',
  'ゲーム',
];
// ダミーの作品名リスト
final List<String> sakuhinNames = [
  'Re:ゼロから始める異世界生活',
  '進撃の巨人',
  'ワンピース',
  '鬼滅の刃',
  'ナルト',
  'ハイキュー!!',
  '僕のヒーローアカデミア',
  '呪術廻戦',
  'スライム倒して300年',
  'リゼロ',
  'ソードアート・オンライン',
  '東京リベンジャーズ',
  'ブラッククローバー',
  'チェンソーマン',
  '鋼の錬金術師',
  'スパイファミリー',
  'モブサイコ100',
  'ワールドトリガー',
  'デスノート',
  'フルーツバスケット',
];

// ランダムなスコアを生成する関数
String generateRandomScore() {
  final random = math.Random();
  return (random.nextInt(100) + 1).toString();
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
          style: const TextStyle(fontSize: 12, color: Colors.white), // 文字色を白に設定
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
            child: Icon(
              model.favorite ? Icons.done : Icons.add,
              color: model.favorite ? Colors.green : Colors.white, // 緑色に変更
              size: 24,
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

class TimelinePage extends StatefulWidget {
  const TimelinePage({Key? key}) : super(key: key);
  @override
  State<TimelinePage> createState() => _TimelinePage();
}

class _TimelinePage extends State<TimelinePage> with RouteAware {
  Future<String> getDoc(String col, String doc, String fie) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection(col).doc(doc).get();
    return snapshot.data()![fie];
  }

  Future<List<Tweet>> fmodels() async {
    bool favorite = false;
    List postlist = [];

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
    List<Tweet> models = [];
    for (int i = 0; i < min(20, postlist.length); i++) {
      models.add(Tweet(
        await getDoc("users", postlist[i]["uid"], "nickname"),
        'assets/images/icon${(i % 11) + 1}.png',
        await getDoc("works", postlist[i]["work"], "title"),
        await getDoc("works", postlist[i]["work"], "imageURL"),
        postlist[i]["score"],
        await getDoc("works", postlist[i]["work"], "genre"),
        favorite,
      ));
    }
    return models;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() async {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Scaffoldの背景色を黒に設定
      body: FutureBuilder(
          future: fmodels(),
          builder: (context, snapshot) {
            print("${snapshot.data}あああ");
            List<Tweet>? models=snapshot.data;
            if(models==null)return Text("Now Loading...",style: TextStyle(color: Colors.white),);
            else return GridView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5), // 左右に5ピクセルの余白を追加
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 一行に表示するアイテムの数
                crossAxisSpacing: 0, // アイテム間の水平スペース
                mainAxisSpacing: 0, // アイテム間の垂直スペース
                childAspectRatio: 13 / 13,
              ),
              itemCount: models!.length,
              itemBuilder: (context, index) {
                // ここで各投稿をウィジェットに変換
                print(snapshot.data![index]);
                return modelToWidget(snapshot.data![index]);
              },
            );
          }),
    );
  }
}
