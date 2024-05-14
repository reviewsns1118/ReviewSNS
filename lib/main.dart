import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wotastagram/UI.dart';
import 'package:wotastagram/add_work.dart';
import 'package:wotastagram/firebase_options.dart';
import 'package:wotastagram/infoupdate.dart';
import 'package:wotastagram/login.dart';
import 'package:wotastagram/othersAccount.dart';
import 'package:wotastagram/posts.dart';
import 'package:wotastagram/works.dart';
import 'package:wotastagram/writepost.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();
bool login = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      login = false;
    } else {
      login = true;
    }
  });

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

final goRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: login ? "/home" : "/start",
  routes: [
    GoRoute(
      name: 'start',
      path: '/start',
      routes: [
        GoRoute(
          name: 'register',
          path: 'register',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: RegisterPage(),
          ),
        ),
        GoRoute(
          name: 'login',
          path: 'login',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: LoginPage(),
          ),
        ),
      ],
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: StartPage(),
      ),
    ),
    GoRoute(
      name: 'home',
      path: '/home',
      routes: [
        GoRoute(
          name: 'posts',
          path: 'posts/:postid',
          routes: [
            GoRoute(
          name: 'worksfromposts',
          path: 'works/:workid',
          builder: (context, state) {
            return Works(state.pathParameters["workid"]);
          },
        ),
          ],
          builder: (context, state) {
            return Posts(state.pathParameters["postid"]);
          },
        ),
        GoRoute(
          name: 'works',
          path: 'works/:workid',
          builder: (context, state) {
            return Works(state.pathParameters["workid"]);
          },
        ),
        GoRoute(
          name: 'infoupdate',
          path: 'infoupdate',
          builder: (context, state) {
            return Infoupdate();
          },
        ),
        GoRoute(
          name: 'addwork',
          path: 'addwork',
          routes: [
            GoRoute(
              name: 'writepostfromaddwork',
              path: 'writepost',
              builder: (context, state) {
                return WritePost(state.extra as Map<String, dynamic>?);
              },
            ),
          ],
          builder: (context, state) {
            return Add();
          },
        ),
        GoRoute(
          name: 'writepostfrompost',
          path: 'writepost',
          builder: (context, state) {
            return WritePost(state.extra as Map<String, dynamic>?);
          },
        ),
        GoRoute(
          name: 'writepostfrompostpage',
          path: 'writepost',
          builder: (context, state) {
            return WritePost(state.extra as Map<String, dynamic>?);
          },
        ),
        GoRoute(
          name: 'accounts',
          path: 'accounts/:uid',
          routes: [
            GoRoute(
              name: 'othersposts',
              path: 'posts/:postid',
              builder: (context, state) {
                return Posts(state.pathParameters["postid"]);
              },
            ),
          ],
          builder: (context, state) {
            return OtherAccountPage(state.pathParameters["uid"]!);
          },
        ),
      ],
      builder: (context, state) {
        int index = state.extra.hashCode;
        return UI(index);
      },
    ),
  ],
  //遷移ページがないなどのエラーが発生した時に、このページに行く
  errorPageBuilder: (context, state) => MaterialPage(
    key: state.pageKey,
    child: Scaffold(
      body: Center(
        child: Text(state.error.toString()),
      ),
    ),
  ),
);
