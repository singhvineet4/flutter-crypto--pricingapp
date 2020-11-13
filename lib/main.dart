import 'package:cryptolist/app/cryptolist_app.dart';
import 'package:cryptolist/data/remote/remote.dart';
import 'package:cryptolist/data/remote/service/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

void main() {
  EquatableConfig.stringify = false;

  runApp(
    CryptolistApp(
      remote: Remote(
        service: Service(),
      ),
    ),
  );
}
