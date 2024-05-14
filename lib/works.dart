import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'main.dart';
import 'package:url_launcher/url_launcher.dart';

class Works extends StatefulWidget {
  Works(this.workid);
  final String? workid;
  @override
  WorksState createState() => WorksState(workid);
}

class WorksState extends State<Works> with RouteAware {
  WorksState(this.workid);
  String? workid;
  Map<String, dynamic>? work;
  List<dynamic> tags = [];

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
  Future<void> didPush() async {}

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: postwidget(),
            builder: (context, snapshot) {
              Widget? models = snapshot.data;
              return models ??
                  Text(
                    "Now Loading...",
                    style: TextStyle(color: Colors.white),
                  );
            },
          ),
          FutureBuilder(
            future: otherpost(),
            builder: (context, snapshot) {
              List? models = snapshot.data ?? [];
              return Expanded(
                child: ListView.builder(
                  itemCount: models.length, // リストの数をlengthで数える.
                  itemBuilder: (context, index) {
                    return models[index] ??
                        Text(
                          "Now Loading...",
                          style: TextStyle(color: Colors.white),
                        );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<Widget> postwidget() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection("works").doc(workid).get();
    work = snapshot.data();
    await FirebaseFirestore.instance
        .collection('tags')
        .where('work', isEqualTo: workid)
        .get()
        .then(
          (QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach(
              (doc) {
                tags.add(doc.data());
              },
            ),
          },
        );
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                getIconForGenre(work?["genre"] ?? ""),
                color: Colors.white,
              ),
              Text(
                work?["title"] ?? "",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          Image(
            image: NetworkImage(work?["imageURL"]),
            height: 150,
            width: 200,
          ),
          TextButton(
            onPressed: () {
              launchUrl(Uri.parse(work?["imageref"]),
                  mode: LaunchMode.platformDefault,
                  webOnlyWindowName: '_blank');
            },
            child: Text("画像引用元URL"),
          ),
          /*RichText(
            text: TextSpan(
              children: [
                TextSpan(text: "平均：", style: TextStyle(color: Colors.white)),
                TextSpan(
                    text: post?["score"].toString(),
                    style: TextStyle(color: getColorForScore(post?["score"]))),
                TextSpan(text: "点", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),*/
          Text(
            "タグ一覧",
            style: TextStyle(color: Colors.white),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: tags.length, // リストの数をlengthで数える.
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Text(
                    "#" + tags[index]["tagname"],
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              );
            },
          ),
          Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('このページを共有'),
                onPressed: () async {
                  final data = ClipboardData(text: Uri.base.toString());
                  await Clipboard.setData(data);
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('この作品をレビューする'),
                onPressed: () async {
                  context.goNamed(
                    "writepostfrompost",
                    extra: work,
                  );
                },
              ),
            ],
          ),
          Text(
            "感想一覧",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Future<List> otherpost() async {
    List postlist = [];
    List otherpost = [];
    await FirebaseFirestore.instance
        .collection('posts')
        .where('work', isEqualTo: workid)
        .orderBy("date", descending: true)
        .get()
        .then(
          (QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach(
              (doc) {
                otherpost.add(doc.data());
              },
            ),
          },
        );
    for (int i = 0; i < otherpost.length; i++) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection("users")
          .doc(otherpost[i]!["uid"])
          .get();
      Map<String, dynamic>? otheruser = snapshot.data();
      var formatter = DateFormat('yyyy/MM/dd HH:mm');
      String formatted =
          formatter.format(otherpost[i]?["date"].toDate()); // DateからString

      postlist.add(GestureDetector(
        onTap: () {
          setState(() {
            context.goNamed(
              'posts',
              pathParameters: {'postid': otherpost[i]["postid"]},
            );
          });
        },
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14, // アイコンのサイズを設定
                  backgroundImage:
                      NetworkImage(otheruser?["photoURL"]), // ユーザーの画像を表示
                  backgroundColor: Color.fromARGB(255, Random().nextInt(256),
                      Random().nextInt(256), Random().nextInt(256)),
                ),
                Text(
                  otheruser?["nickname"],
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: otherpost[i]?["score"].toString(),
                          style: TextStyle(
                              color: getColorForScore(otherpost[i]?["score"]))),
                      TextSpan(
                          text: "点", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                Text(
                  formatted,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Text(
              otherpost[i]?["feel"],
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ));
    }

    return postlist;
  }
}
