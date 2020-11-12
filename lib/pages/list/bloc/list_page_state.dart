import 'package:cryptolist/data/remote/remote.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class ListPageState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class ListPageStateEmpty extends ListPageState {}

@immutable
class ListPageStateLoading extends ListPageState {}

@immutable
class ListPageStateSuccess extends ListPageState {
  final List<Crypto> cryptos;

  ListPageStateSuccess({@required this.cryptos});

  @override
  List<Object> get props => [cryptos];
}

@immutable
class ListPageStateError extends ListPageState {}
