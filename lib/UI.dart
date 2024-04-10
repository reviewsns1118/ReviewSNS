import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main.dart';
import 'timeline_page.dart';
import 'search_page.dart';
import 'post_page.dart';
import 'Account_page.dart';
import 'login.dart';
import 'infoupdate.dart';
import 'firebase_options.dart';

class UI extends StatefulWidget {
  @override
  _UIState createState() => _UIState();
}

class _UIState extends State<UI> {
 late List<Widget> pages;
 int _currentIndex = 0;

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
          onPressed: () {
            setState(() {
              _currentIndex = 3;
            });        },
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