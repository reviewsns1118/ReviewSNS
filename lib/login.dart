import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

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
                    context.goNamed('register');
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
                    context.goNamed('login');
                  },
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 200,
                // ユーザー登録ボタン
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('developerlogin'),
                  onPressed: () async {
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    await auth.signInWithEmailAndPassword(
                      email: "reviewsns1118@gmail.com",
                      password: "Reiji_saikou",
                    );
                    // ログインに成功した場合
                    // チャット画面に遷移＋ログイン画面を破棄
                    context.goNamed(
                      'home',
                      extra: 0,
                    );
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

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // メッセージ表示用
  String infoText = '';

  // 入力したメールアドレス・パスワード
  String nickname = '';

  String userid = '';

  String email = '';

  String password = '';

  final CollectionReference users = FirebaseFirestore.instance.collection('users');

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
                  nickname = value;
                },
              ),
              //ユーザーID入力
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-z0-9]')),
                ],
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(labelText: 'ユーザーID'),
                onChanged: (String value) {
                  userid = value;
                },
              ),
              // メールアドレス入力
              TextFormField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(labelText: 'メールアドレス'),
                onChanged: (String value) {
                  email = value;
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
                  password = value;
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
                      UserCredential result =
                          await auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      final user = result.user;
                      users.doc(user?.uid).set({
                        'uid': user?.uid,
                        'nickname': nickname,
                        'nicknameOption': await _createNameOption(nickname),
                        'userid': userid,
                        'useridOption': await _createNameOption(userid),
                        'email': email,
                      });
                      // ユーザー登録に成功した場合
                      // チャット画面に遷移＋ログイン画面を破棄
                      context.goNamed(
                        'home',
                        extra: 0,
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

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                  email = value;
                },
                //initialValue: "reviewsns1118@gmail.com",
              ),
              // パスワード入力
              TextFormField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                onChanged: (String value) {
                  password = value;
                },
                //initialValue: "Reiji_saikou",
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
                      context.goNamed(
                        'home',
                        extra: 0,
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