import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'router.dart';
import 'posts.dart';
import 'writepost.dart';
import 'add_work.dart';
import 'UI.dart';
import 'login.dart';
import 'firebase_options.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

Future<void> main() async {
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
  MyApp({super.key});

  

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routerDelegate: goRouter.routerDelegate,
        routeInformationParser: goRouter.routeInformationParser,
        routeInformationProvider: goRouter.routeInformationProvider,
        theme: ThemeData(
          // Materialデザインのバージョンを設定
          useMaterial3: false,
        ),
        title: 'Wotastagram',
      );
}

class InitialPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // スプラッシュ画面などに書き換えても良い
              return const SizedBox();
            }
            if (snapshot.hasData) {
              // User が null でなない、つまりサインイン済みのホーム画面へ
              context.goNamed(
                'home',
                extra: 0,
              );
              return UI(0);
            }
            // User が null である、つまり未サインインのサインイン画面へ
            context.goNamed('start');
            return StartPage();
          },
        );
}
}