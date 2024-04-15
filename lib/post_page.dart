import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'writepost.dart';
import 'add_work.dart';
import 'searchwork.dart';


class PostPage extends ConsumerWidget {
  const PostPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ListView.builderのitemCountで使用するListのProviderを呼び出す.
    final result = ref.watch(searchResultProvider);
    // Firestoreの映画情報を検索するProviderを呼び出す.
    final searchState = ref.read(searchStateNotifireProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.black,
      body:Column(
        children: [
          
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 36,
            ),
            child: TextField(
              style: TextStyle(
                fontSize:18,
                color: Colors.white, 
              ),
              decoration: InputDecoration(
                fillColor: Colors.white,
                hintText: '作品を検索'
               ),
               onChanged: (query) {
                searchState.searchWhere(query);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: result.length, // リストの数をlengthで数える.
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(
                    result[index]['imageURL'].toString(),
                    height: 60,
                    width: 80,
                  ),
                  title: Text(
                    result[index]['title'].toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WritePost(result[index])),
                    );
                  },
                );
              },
            ),
          ),
          Text(
            "作品が見つからない時は、ここから追加",
            style: TextStyle(
              color: Colors.white
            ),
          ),
          Text("↓",
            style: TextStyle(
              color: Colors.white
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Add()),
              );
            }, 
            child: Text("作品を追加")
          )
        ],
      ),
    );
  }
}