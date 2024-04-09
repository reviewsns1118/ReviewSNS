import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'main.dart';
import 'timeline_page.dart';
import 'search_page.dart';
import 'post_page.dart';
import 'login.dart';
import 'infoupdate.dart';
import 'firebase_options.dart';


class AccountPage extends StatelessWidget {
  int _currentIndex = 3;
  Future<String> getDoc(String s) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return snapshot.data()![s]??"";
  }
  
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        // 左側のアイコン
        leading: IconButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          icon: Icon(Icons.logout),
          onPressed: () async {
            // ログアウト処理
            // 内部で保持しているログイン情報等が初期化される
            // （現時点ではログアウト時はこの処理を呼び出せばOKと、思うぐらいで大丈夫です）
            await FirebaseAuth.instance.signOut();
            // ログイン画面に遷移＋チャット画面を破棄
            await Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) {
                return StartPage();
              }),
            );
          },
        ),
        // タイトルテキスト
        title: Text(
          'Thoughts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        // 右側のアイコン一覧
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      
      body:Center(
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: getDoc('userid'),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                return Text(
                  snapshot.data??"Guest",
                  style: TextStyle(color: Colors.white)
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.account_circle),
              color: Colors.white,
              onPressed: () async {
                String nickname=await getDoc('nickname');
                String introduction=await getDoc('introduction');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Infoupdate(nickname,introduction)),
                );
              },
            ),
            FutureBuilder(
              future: getDoc('nickname'),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                return Text(
                  snapshot.data??"Guest",
                  style: TextStyle(color: Colors.white)
                );
              },
            ),
            FutureBuilder(
              future: getDoc('introduction'),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                return Text(
                  snapshot.data??"",
                  style: TextStyle(color: Colors.white)
                );
              },
            ),
          ],
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor:Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today),
          label:'timeline',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search),
          label:'search',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.add),
          label:'post',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle),
          label:'account',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          if(index==0){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TimelinePage()),
            );
          }
          else if(index==1){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchPage()),
            );
          }
          else if(index==2){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostPage()),
            );
          }
        },
      ),
    );
  }
}