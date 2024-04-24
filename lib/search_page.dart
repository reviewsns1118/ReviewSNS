import 'package:cloud_firestore/cloud_firestore.dart';
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
  String col = "users";
  String fie = "nicknameOption";
  String image = "photoURL";
  String name = "nickname";
  String genre = "";
  List<dynamic> doclist = [];
  List<dynamic> tagwork = [];
  Future<Map<String, dynamic>?> getDoc(String s) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('works').doc(s).get();
    return snapshot.data();
  }

  Future<void> searchWhere(
      String query, String col, String fie, String genre) async {
    doclist = [];
    tagwork = [];
    final result = await FirebaseFirestore.instance
        .collection(col)
        .where(fie, arrayContains: query)
        .get();
    // リストに、検索して取得したデータを保存する.
    for (final doc in result.docs) {
      if (col == "tags") {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection("works")
                .doc(doc["work"])
                .get();
        if (snapshot.data()!["genre"] == genre || genre == "")
          setState(() {
            tagwork.add(snapshot.data());
            doclist.add(doc);
          });
      } else if (col == "works") {
        if (doc["genre"] == genre || genre == "") {
          setState(() {
            doclist.add(doc);
          });
        }
      } else {
        setState(() {
          doclist.add(doc);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    fie = "nicknameOption";
                    image = "photoURL";
                    name = "nickname";
                    genre = "";
                    doclist = [];
                    tagwork = [];
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
                    fie = "tagOption";
                    image = "imageURL";
                    name = "title";
                    genre = "";
                    doclist = [];
                    tagwork = [];
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
                    fie = "titleOption";
                    image = "imageURL";
                    name = "title";
                    genre = "";
                    doclist = [];
                    tagwork = [];
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
          col == "works" || col == "tags"
              ? Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          genre = "";
                        });
                      },
                      child: Text("全て"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            genre == "" ? Colors.blue : Colors.white,
                        foregroundColor:
                            genre == "" ? Colors.white : Colors.black,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          genre = "映画";
                          doclist = [];
                          tagwork = [];
                        });
                      },
                      child: Text("映画"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            genre == "映画" ? Colors.blue : Colors.white,
                        foregroundColor:
                            genre == "映画" ? Colors.white : Colors.black,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          genre = "文庫本";
                          doclist = [];
                          tagwork = [];
                        });
                      },
                      child: Text("文庫本"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            genre == "文庫本" ? Colors.blue : Colors.white,
                        foregroundColor:
                            genre == "文庫本" ? Colors.white : Colors.black,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          genre = "漫画";
                          doclist = [];
                          tagwork = [];
                        });
                      },
                      child: Text("漫画"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            genre == "漫画" ? Colors.blue : Colors.white,
                        foregroundColor:
                            genre == "漫画" ? Colors.white : Colors.black,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          genre = "アニメ";
                          doclist = [];
                          tagwork = [];
                        });
                      },
                      child: Text("アニメ"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            genre == "アニメ" ? Colors.blue : Colors.white,
                        foregroundColor:
                            genre == "アニメ" ? Colors.white : Colors.black,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          genre = "ゲーム";
                          doclist = [];
                          tagwork = [];
                        });
                      },
                      child: Text("ゲーム"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            genre == "ゲーム" ? Colors.blue : Colors.white,
                        foregroundColor:
                            genre == "ゲーム" ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          fie = "nicknameOption";
                          doclist = [];
                          tagwork = [];
                        });
                      },
                      child: Text("ユーザー名"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: fie == "nicknameOption"
                            ? Colors.blue
                            : Colors.white,
                        foregroundColor: fie == "nicknameOption"
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          fie = "useridOption";
                          doclist = [];
                          tagwork = [];
                        });
                      },
                      child: Text("ユーザーID"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            fie == "useridOption" ? Colors.blue : Colors.white,
                        foregroundColor:
                            fie == "useridOption" ? Colors.white : Colors.black,
                      ),
                    ),
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
              onSubmitted: (query) async {
                searchWhere(query, col, fie, genre);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: doclist.length, // リストの数をlengthで数える.
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(
                    col == "tags"
                        ? tagwork[index]["imageURL"] ?? Colors.white
                        : doclist[index][image],
                    height: 60,
                    width: 80,
                  ),
                  title: Text(
                    col == "tags"
                        ? tagwork[index]["title"] ?? ""
                        : doclist[index][name],
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Text(
                    col == "tags" ? doclist[index]["tagname"] ?? "" : "",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
