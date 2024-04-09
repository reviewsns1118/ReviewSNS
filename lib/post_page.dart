import 'package:flutter/material.dart';
import 'main.dart';
import 'timeline_page.dart';
import 'search_page.dart';
import 'account_page.dart';


class PostPage extends StatelessWidget {
  int _currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        // 左側のアイコン
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccountPage()),
            );
          },
          icon: Icon(Icons.account_circle),
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
      backgroundColor: Colors.green,
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
          else if(index==3){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccountPage()),
            );
          }
        },
      ),
    );
  }
}