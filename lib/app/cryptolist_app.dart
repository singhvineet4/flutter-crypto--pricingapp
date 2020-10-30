import 'package:cryptolist/pages/list_page.dart';
import 'package:flutter/material.dart';

class CryptolistApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final base = ThemeData.light();

    final theme = base.copyWith(
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
    );

    return MaterialApp(
      title: 'CryptoList',
      theme: theme,
      home: ListPage(),
    );
  }
}
