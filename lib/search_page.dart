import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'writepost.dart';
import 'add_work.dart';
import 'searchfield.dart';

class SearchPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<SearchPage> createState() => _SearchPage();
}

class _SearchPage extends ConsumerState<SearchPage> {
  String col = "user";
  String fie ="nicknameOption";
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
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    col = "users";
                  });
                },
                child: Text("ユーザー"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: col == "users" ? Colors.blue : Colors.white,
                  foregroundColor: col == "users" ? Colors.white : Colors.black,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    col = "tags";
                  });
                },
                child: Text("タグ"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: col == "tags" ? Colors.blue : Colors.white,
                  foregroundColor: col == "tags" ? Colors.white : Colors.black,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    col = "works";
                    fie= "titleOption";
                  });
                },
                child: Text("作品"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: col == "works" ? Colors.blue : Colors.white,
                  foregroundColor: col == "works" ? Colors.white : Colors.black,
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 36,
            ),
            child: TextField(
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              decoration:
                  InputDecoration(fillColor: Colors.white, hintText: '作品を検索'),
              onSubmitted: (query) {
                searchState.searchWhere(query, col, "titleOption");
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WritePost(result[index])),
                    );
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Add()),
                );
              },
              child: Text("作品を追加"))
        ],
      ),
    );
  }
}
