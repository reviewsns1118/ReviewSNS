import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wotastagram/timeline_page.dart';
import 'UI.dart';
import 'login.dart';
import 'firebase_options.dart';
final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
      ProviderScope(
        child: MyApp(),
      ),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter app',
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // スプラッシュ画面などに書き換えても良い
              return const SizedBox();
            }
            if (snapshot.hasData) {
              // User が null でなない、つまりサインイン済みのホーム画面へ
              return UI(TimelinePage());
            }
            // User が null である、つまり未サインインのサインイン画面へ
            return StartPage();
          },
        ),
        navigatorObservers: [
          routeObserver,// <-- ここにrouteObserverを設置
        ],
      );
}

