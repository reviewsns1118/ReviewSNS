import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'account_page.dart';

class Infoupdate extends StatelessWidget {
  Infoupdate(this.nickname,this.introduction);
  String nickname = '';
  String introduction='';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        
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
      ),
      backgroundColor: Colors.black,
      body:Center(
        child: Column(

          children: <Widget>[
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
              decoration: InputDecoration(labelText: 'ニックネーム'),
              onChanged: (String value) {
                nickname=value;
              },
            ),
            TextFormField(
              style: const TextStyle(
                color: Colors.white,
                
              ),
              initialValue: introduction,
              decoration: InputDecoration(labelText: '自己紹介文'),
              onChanged: (String value) {
                introduction=value;
              },
            ),
            ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('更新'),
                  onPressed: () async {
                    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                      'nickname': nickname,
                      'introduction': introduction,
                    });
                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return AccountPage();
                      }),
                    );
                  },
                ),
          ]
        )
      ),
    );
  }
}