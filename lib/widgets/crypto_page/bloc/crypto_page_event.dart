import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class CryptoPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class CryptoPageEventLoad extends CryptoPageEvent {
  final String assetId;

  CryptoPageEventLoad({@required this.assetId});

  @override
  List<Object> get props => [assetId];
}
