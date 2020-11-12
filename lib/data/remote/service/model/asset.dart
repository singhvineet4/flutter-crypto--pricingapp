import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Asset extends Equatable {
  const Asset({
    @required this.assetId,
    @required this.name,
    @required this.typeIsCrypto,
    @required this.volume1HrsUsd,
    @required this.volume1DayUsd,
    @required this.volume1MthUsd,
    @required this.priceUsd,
    @required this.idIcon,
  });

  final String assetId;
  final String name;
  final bool typeIsCrypto;
  final double volume1HrsUsd;
  final double volume1DayUsd;
  final double volume1MthUsd;
  final double priceUsd;
  final String idIcon;

  factory Asset.fromMap(Map<String, dynamic> json) => Asset(
        assetId: json["asset_id"],
        name: json["name"],
        typeIsCrypto: json["type_is_crypto"] == 1,
        volume1HrsUsd: json["volume_1hrs_usd"]?.toDouble(),
        volume1DayUsd: json["volume_1day_usd"]?.toDouble(),
        volume1MthUsd: json["volume_1mth_usd"]?.toDouble(),
        priceUsd: json["price_usd"]?.toDouble(),
        idIcon: json["id_icon"],
      );

  @override
  List<Object> get props => [
        assetId,
        name,
        typeIsCrypto,
        volume1HrsUsd,
        volume1DayUsd,
        volume1MthUsd,
        priceUsd,
        idIcon,
      ];
}
