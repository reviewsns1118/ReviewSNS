import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'infoupdate.dart';


class AccountPage extends StatelessWidget {
  Future<String> getDoc(String s) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return snapshot.data()![s]??"";
  }
  const AccountPage({super.key});  
  @override

  Widget build(BuildContext context) {
    return Scaffold(
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
      )
    );
  }
}