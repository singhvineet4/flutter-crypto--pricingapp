import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class PriceData extends Equatable {
  const PriceData({
    @required this.timePeriodStart,
    @required this.timePeriodEnd,
    @required this.priceHigh,
    @required this.priceLow,
  });

  final DateTime timePeriodStart;
  final DateTime timePeriodEnd;
  final double priceHigh;
  final double priceLow;

  factory PriceData.fromMap(Map<String, dynamic> json) => PriceData(
        timePeriodStart: DateTime.parse(json["time_period_start"]),
        timePeriodEnd: DateTime.parse(json["time_period_end"]),
        priceHigh: json["price_high"]?.toDouble(),
        priceLow: json["price_low"]?.toDouble(),
      );

  @override
  List<Object> get props => [
        timePeriodStart,
        timePeriodEnd,
        priceHigh,
        priceLow,
      ];
}
