import 'package:cryptolist/data/remote/remote.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class CryptoPageState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class CryptoPageStateEmpty extends CryptoPageState {}

@immutable
class CryptoPageStateLoading extends CryptoPageState {}

@immutable
class CryptoPageStateSuccess extends CryptoPageState {
  final List<TimedData> data;

  CryptoPageStateSuccess({@required this.data});

  @override
  List<Object> get props => [data];
}

@immutable
class CryptoPageStateError extends CryptoPageState {}
