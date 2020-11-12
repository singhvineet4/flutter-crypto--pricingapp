import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Crypto extends Equatable {
  Crypto({
    @required this.assetId,
    @required this.name,
    @required this.volume1HrsUsd,
    @required this.volume1DayUsd,
    @required this.volume1MthUsd,
    @required this.priceUsd,
    @required this.iconUrl,
  }) {
    ArgumentError.checkNotNull(assetId);
    ArgumentError.checkNotNull(name);
    ArgumentError.checkNotNull(volume1HrsUsd);
    ArgumentError.checkNotNull(volume1DayUsd);
    ArgumentError.checkNotNull(volume1MthUsd);
    ArgumentError.checkNotNull(priceUsd);
    ArgumentError.checkNotNull(iconUrl);
  }

  final String assetId;
  final String name;
  final double volume1HrsUsd;
  final double volume1DayUsd;
  final double volume1MthUsd;
  final double priceUsd;
  final String iconUrl;

  @override
  List<Object> get props => [
        assetId,
        name,
        volume1HrsUsd,
        volume1DayUsd,
        volume1MthUsd,
        priceUsd,
        iconUrl,
      ];
}
