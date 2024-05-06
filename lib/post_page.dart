import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'searchfield.dart';



class PostPage extends ConsumerStatefulWidget {

  @override
  ConsumerState<PostPage> createState() => PostPageState();
}

class PostPageState extends ConsumerState<PostPage> {

  String word="";

  @override
  Widget build(BuildContext context) {
    // ListView.builderのitemCountで使用するListのProviderを呼び出す.
    final result = ref.watch(searchResultProvider);
    // Firestoreの映画情報を検索するProviderを呼び出す.
    final searchState = ref.read(searchStateNotifireProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            child: TextField(
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: '作品を検索',
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    // 非フォーカス時の枠線のスタイルを指定
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                onChanged: (query) {
                  setState(() {
                    word=query;
                  });
                  if (query.isEmpty) {
                    searchState.searchWhere(" ", "works", "titleOption");
                  } else {
                    searchState.searchWhere(query, "works", "titleOption");
                  }
                }),
          ),
          Text(
            "${word}の検索結果:${result.length}件の作品",
            style: TextStyle(color: Colors.white),
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
                  onTap: () {
                    context.goNamed('writepostfrompostpage',extra: result[index]);
                  },
                );
              },
            ),
          ),
          Text(
            "作品が見つからない時は、ここから追加",
            style: TextStyle(color: Colors.white),
          ),
          Text(
            "↓",
            style: TextStyle(color: Colors.white),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                context.goNamed('addwork');
              },
              child: Text("作品を追加"))
        ],
      ),
    );
  }
}