import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wotastagram/UI.dart';
import 'package:wotastagram/add_work.dart';
import 'package:wotastagram/infoupdate.dart';
import 'package:wotastagram/login.dart';
import 'package:wotastagram/main.dart';
import 'package:wotastagram/othersAccount.dart';
import 'package:wotastagram/posts.dart';
import 'package:wotastagram/writepost.dart';

final goRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: "/",
  routes: [
    GoRoute(
      name: 'initial',
      path: '/',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: InitialPage(),
      ),
    ),
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
          builder: (context, state) {
            return Posts(state.pathParameters["postid"]);
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
