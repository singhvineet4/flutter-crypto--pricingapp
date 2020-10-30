import 'dart:convert' show json;

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

const _apiKey = '0FC53B29-D9BB-4BFE-8438-73C33A2D89BC';

const _headers = {
  'X-CoinAPI-Key': _apiKey,
  'Accept': 'application/json',
  'Accept-Encoding': 'deflate, gzip',
};

const _baseUrl = 'https://rest.coinapi.io';

const _timeLimit = Duration(seconds: 30);

@immutable
class Asset {
  Asset({
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
}

@immutable
class AssetIcon {
  AssetIcon({
    @required this.assetId,
    @required this.url,
  });

  final String assetId;
  final String url;

  factory AssetIcon.fromMap(Map<String, dynamic> json) => AssetIcon(
        assetId: json["asset_id"],
        url: json["url"],
      );
}

@immutable
class PriceData {
  PriceData({
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
}

Future<List<Asset>> getAssets() async {
  final response = await http
      .get(
        '$_baseUrl/v1/assets',
        headers: _headers,
      )
      .timeout(_timeLimit);

  if (response.statusCode == 200) {
    final List<dynamic> list = json.decode(response.body);

    return list.map((e) => Asset.fromMap(e)).toList();
  } else {
    throw 'statusCode != 200';
  }
}

Future<List<AssetIcon>> getAssetIcons() async {
  final response = await http
      .get(
        '$_baseUrl/v1/assets/icons/512x512',
        headers: _headers,
      )
      .timeout(_timeLimit);

  if (response.statusCode == 200) {
    final List<dynamic> list = json.decode(response.body);

    return list.map((e) => AssetIcon.fromMap(e)).toList();
  } else {
    throw 'statusCode != 200';
  }
}

Future<List<PriceData>> getPriceSeries({
  @required String assetId,
  String duration = '1DAY',
  int points = 30,
}) async {
  final response = await http
      .get(
        '$_baseUrl/v1/ohlcv/$assetId/USD/latest?'
        'period_id=$duration&limit=$points',
        headers: _headers,
      )
      .timeout(_timeLimit);

  if (response.statusCode == 200) {
    final List<dynamic> list = json.decode(response.body);

    return list.map((e) => PriceData.fromMap(e)).toList();
  } else {
    throw 'statusCode != 200';
  }
}
