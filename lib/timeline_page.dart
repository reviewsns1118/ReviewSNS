import 'package:flutter/material.dart';
import 'main.dart';
import 'search_page.dart';
import 'post_page.dart';
import 'account_page.dart';

class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: Text("timeline"),)
    );
  }
}