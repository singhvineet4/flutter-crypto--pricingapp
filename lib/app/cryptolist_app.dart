import 'package:cryptolist/data/remote/remote.dart';
import 'package:cryptolist/pages/crypto/crypto_page.dart';
import 'package:cryptolist/pages/list/bloc/list_page_bloc.dart';
import 'package:cryptolist/pages/list/list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class CryptolistApp extends StatelessWidget {
  final Remote remote;

  const CryptolistApp({@required this.remote});

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
      home: BlocProvider(
        create: (context) => ListPageBloc(
          remote: remote,
        ),
        child: ListPage(
          cryptoPageCreator: (context, {crypto}) => CryptoPage(
            remote: remote,
            crypto: crypto,
          ),
        ),
      ),
    );
  }
}
