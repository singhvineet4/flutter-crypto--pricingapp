import 'package:cryptolist/data/remote/remote.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ListWidgetState extends Equatable {
  @override
  List<Object> get props => [];
}

mixin ListWidgetStateWithData on ListWidgetState {
  List<Crypto> get cryptos;

  @override
  List<Object> get props => [cryptos];
}

mixin ListWidgetStateWithFilter on ListWidgetState {
  String get filterText;

  @override
  List<Object> get props => [filterText];
}

@immutable
class ListWidgetStateFull extends ListWidgetState with ListWidgetStateWithData {
  final List<Crypto> cryptos;

  ListWidgetStateFull({@required this.cryptos});

  @override
  List<Object> get props => [cryptos];
}

@immutable
abstract class ListWidgetStateFiltered extends ListWidgetState
    with ListWidgetStateWithFilter {
  final String filterText;

  ListWidgetStateFiltered({@required this.filterText});

  @override
  List<Object> get props => [filterText];
}

@immutable
class ListWidgetStateFilteredEmpty extends ListWidgetStateFiltered {
  ListWidgetStateFilteredEmpty({@required String filterText})
      : super(filterText: filterText);
}

@immutable
class ListWidgetStateFilteredFound extends ListWidgetStateFiltered
    with ListWidgetStateWithData {
  final List<Crypto> cryptos;

  ListWidgetStateFilteredFound({
    @required String filterText,
    @required this.cryptos,
  }) : super(filterText: filterText);

  @override
  List<Object> get props => [
        filterText,
        cryptos,
      ];
}
