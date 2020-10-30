import 'package:flutter/material.dart';

import 'file:///C:/Android/fws/cryptolist/lib/pages/list/list_page.dart';

class CryptolistApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CryptoList',
      theme: ThemeData.light().copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.blue,
        accentColor: Colors.tealAccent,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          elevation: 0.0,
          shadowColor: Colors.transparent,
          color: Colors.white,
          actionsIconTheme: IconThemeData(
            color: Colors.black,
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.black,
              fontSize: 32.0,
            ),
          ),
        ),
      ),
      home: ListPage(),
    );
  }
}
