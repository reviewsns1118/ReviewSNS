import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wotastagram/UI.dart';
import 'main.dart';
import 'timeline_page.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          'Thoughts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 200,
                // ユーザー登録ボタン
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('ユーザー登録'),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 200,
                // ログイン登録ボタン
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: Text('ログイン'),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterPage extends StatelessWidget {
  // メッセージ表示用
  String infoText = '';
  // 入力したメールアドレス・パスワード
  String nickname = '';
  String userid = '';
  String email = '';
  String password = '';
  CollectionReference users = FirebaseFirestore.instance.collection('users');



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          ' 新規登録',
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //ニックネーム入力
              TextFormField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(labelText: 'ニックネーム'),
                onChanged: (String value) {
                  nickname=value;
                },
              ),
              //ユーザーID入力
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-z0-9]')
                  ),
                ],
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(labelText: 'ユーザーID'),
                onChanged: (String value) {
                  userid=value;
                },
              ),
              // メールアドレス入力
              TextFormField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(labelText: 'メールアドレス'),
                onChanged: (String value) {
                  email=value;
                },
              ),
              // パスワード入力
              TextFormField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                onChanged: (String value) {
                  password=value;
                },
              ),
              Container(
                padding: EdgeInsets.all(8),
                // メッセージ表示
                child: Text(infoText),
              ),
              Container(
                width: double.infinity,
                // ユーザー登録ボタン
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('登録'),
                  onPressed: () async {
                    try {
                      // メール/パスワードでユーザー登録
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      UserCredential result = await auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      final user = result.user;
                      users.doc(user?.uid).set({
                        'uid': user?.uid,
                        'nickname': nickname,
                        'userid': userid,
                        'email': email,
                      });
                      // ユーザー登録に成功した場合
                      // チャット画面に遷移＋ログイン画面を破棄
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return UI(TimelinePage());
                        }),
                      );
                    } catch (e) {
                      // ユーザー登録に失敗した場合
                      infoText = "登録に失敗しました：${e.toString()}";
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  // メッセージ表示用
  String infoText = '';
  // 入力したメールアドレス・パスワード
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          ' ログイン',
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // メールアドレス入力
              TextFormField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(labelText: 'メールアドレス'),
                onChanged: (String value) {
                  email=value;
                },
              ),
              // パスワード入力
              TextFormField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                onChanged: (String value) {
                  password=value;
                },
              ),
              Container(
                padding: EdgeInsets.all(8),
                // メッセージ表示
                child: Text(infoText),
              ),
              Container(
                width: double.infinity,
                // ログイン登録ボタン
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('ログイン'),
                  onPressed: () async {
                    try {
                      // メール/パスワードでログイン
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      await auth.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      // ログインに成功した場合
                      // チャット画面に遷移＋ログイン画面を破棄
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return UI(TimelinePage());
                        }),
                      );
                    } catch (e) {
                      // ログインに失敗した場合
                      infoText = "ログインに失敗しました：${e.toString()}";
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}