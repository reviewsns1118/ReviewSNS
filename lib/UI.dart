import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'main.dart';
import 'timeline_page.dart';
import 'search_page.dart';
import 'post_page.dart';
import 'Account_page.dart';

class UI extends StatefulWidget {
  UI(this.page, {super.key});
  final int page;
  @override
  _UIState createState() => _UIState(page);
}

class _UIState extends State<UI> with RouteAware {
  _UIState(this._currentIndex);
  int _currentIndex;
  List<Widget> pages = [
      TimelinePage(),
      SearchPage(),
      PostPage(),
      AccountPage(),
    ];
  List<IconData> _icon = [
    Icons.account_circle,
    Icons.account_circle,
    Icons.account_circle,
    Icons.logout,
  ];
  List<FontStyle> fontstyle=[
    FontStyle.italic,
    FontStyle.normal,
    FontStyle.normal,
    FontStyle.italic,
  ];
  String userid="Guest";
  Future<void> getUser() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      userid=snapshot.data()!["userid"]??"Guest";
    });
  }
  List<String> title=[
    "Thoughts",
    "検索",
    "レビューする作品を選択",
    "",
  ];

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
    await getUser();
    title[3]=userid;
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
              foregroundColor: Colors.white),
          onPressed: () async {
            if (_currentIndex == 3) {
              await FirebaseAuth.instance.signOut();
              // ログイン画面に遷移＋チャット画面を破棄
              context.goNamed('start');
            } else {
              setState(() {
                _currentIndex = 3;
              });
            }
          },
          icon: Icon(_icon[_currentIndex]),
        ),
        // タイトルテキスト
        title: Text(
          title[_currentIndex],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: fontstyle[_currentIndex],
          ),
        ),
        centerTitle: true,
        // 右側のアイコン一覧
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'timeline',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'account',
          ),
        ],
      ),
    );
  }
}