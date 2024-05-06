import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wotastagram/UI.dart';
import 'package:wotastagram/main.dart';

class Infoupdate extends StatefulWidget {
  @override
  State<Infoupdate> createState() => _InfoupdateState();
}

class _InfoupdateState extends State<Infoupdate> with RouteAware {
  String nickname = "";
  String introduction = "";

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
  Future<void> didPush() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      nickname = snapshot.data()?["nickname"];
      introduction = snapshot.data()?["introduction"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,

        // タイトルテキスト
        title: const Text(
          'Thoughts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        // 右側のアイコン一覧
      ),
      backgroundColor: Colors.black,
      body: Center(
          child: Column(children: <Widget>[
        const Icon(
          Icons.account_circle,
          color: Colors.white,
        ),
        //ニックネーム入力
        TextFormField(
          style: const TextStyle(
            color: Colors.white,
          ),
          initialValue: nickname,
          decoration: const InputDecoration(labelText: 'ニックネーム'),
          onChanged: (String value) {
            nickname = value;
          },
        ),
        TextFormField(
          style: const TextStyle(
            color: Colors.white,
          ),
          initialValue: introduction,
          decoration: const InputDecoration(labelText: '自己紹介文'),
          onChanged: (String value) {
            introduction = value;
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: const Text('更新'),
          onPressed: () async {
            FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({
              'nickname': nickname,
              'nicknameOption': await _createNameOption(nickname),
              'introduction': introduction,
            });
            context.goNamed(
              "home",
              extra: 3,
            );
          },
        ),
      ])),
    );
  }

  Future<List<String>> _createNameOption(String value) async {
    var nickname = value;
    var nicknameList = <String>[];
//繰り返す回数
    for (int i = nickname.length; i > 0; i--) {
      final getTitle = nickname.substring(0, i);
      nicknameList.add(getTitle);
      nickname = value;
    }
    return nicknameList;
  }
}
