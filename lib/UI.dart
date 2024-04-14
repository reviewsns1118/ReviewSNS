import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'timeline_page.dart';
import 'search_page.dart';
import 'post_page.dart';
import 'Account_page.dart';


class UI extends StatefulWidget {
  UI(this.page);
  Widget page;
  @override
  _UIState createState() => _UIState(page);
}

class _UIState extends State<UI> {
  _UIState(this.page);
  Widget page;
  late List<Widget> pages;
  int _currentIndex = 0;
  IconData _icon=Icons.account_circle;
  Color _color=Colors.black;

@override
void initState() {
  pages = [
    TimelinePage(),
    SearchPage(),
    PostPage(),
    AccountPage(),
  ];
  super.initState();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        // 左側のアイコン
        leading: IconButton(
          style: IconButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: _color
          ),
          onPressed: () async {
            if(_currentIndex==3){
              await FirebaseAuth.instance.signOut();
              // ログイン画面に遷移＋チャット画面を破棄
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return StartPage();
                }),
              );
            }
            else {
              setState(() {
              page=AccountPage();
              _color=Colors.red;
              _icon=Icons.logout;
              _currentIndex=3;
            });
            }
          },
          icon: Icon(_icon),
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
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black, 
        selectedItemColor: Colors.white, 
        unselectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex=index;
            page = pages[index];
            if(index==3){
              _color=Colors.red;
              _icon=Icons.logout;
            }
            else {
              _color=Colors.black;
              _icon=Icons.account_circle;
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label:'timeline',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label:'search',
          ),          
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label:'post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label:'account',
          ),
        ],
      ),
    );
  }
}