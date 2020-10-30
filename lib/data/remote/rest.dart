import 'dart:async';
import 'dart:convert' show json;

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

// const _apiKey = 'D79C3290-50F7-4026-83D6-EA0EE1F95210';
const _apiKey = '0FC53B29-D9BB-4BFE-8438-73C33A2D89BC';

const _headers = {
  'X-CoinAPI-Key': _apiKey,
  'Accept': 'application/json',
  'Accept-Encoding': 'deflate, gzip',
};

const _baseUrl = 'https://rest.coinapi.io';

const _timeLimit = Duration(seconds: 15);

@immutable
class ApiException {
  ApiException();
}

@immutable
class _Asset {
  _Asset({
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

  factory _Asset.fromMap(Map<String, dynamic> json) => _Asset(
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
  String toString() {
    return '_Asset{assetId: $assetId, name: $name, typeIsCrypto: $typeIsCrypto, volume1HrsUsd: $volume1HrsUsd, volume1DayUsd: $volume1DayUsd, volume1MthUsd: $volume1MthUsd, priceUsd: $priceUsd, idIcon: $idIcon}';
  }
}

@immutable
class _AssetIcon {
  _AssetIcon({
    @required this.assetId,
    @required this.url,
  });

  final String assetId;
  final String url;

  factory _AssetIcon.fromMap(Map<String, dynamic> json) => _AssetIcon(
        assetId: json["asset_id"],
        url: json["url"],
      );
}

@immutable
class Crypto {
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
}

Future<List<_Asset>> _getAssets() async {
  final response = await http
      .get(
        '$_baseUrl/v1/assets',
        headers: _headers,
      )
      .timeout(_timeLimit);

  if (response.statusCode == 200) {
    final List<dynamic> list = json.decode(response.body);

    return list.map((e) => _Asset.fromMap(e)).toList();
  } else {
    throw 'statusCode != 200';
  }
}

Future<List<_AssetIcon>> _getAssetIcons() async {
  final response = await http
      .get(
        '$_baseUrl/v1/assets/icons/512x512',
        headers: _headers,
      )
      .timeout(_timeLimit);

  if (response.statusCode == 200) {
    final List<dynamic> list = json.decode(response.body);

    return list.map((e) => _AssetIcon.fromMap(e)).toList();
  } else {
    throw 'statusCode != 200';
  }
}

Future<List<Crypto>> getCryptos() async {
  final assets = await _getAssets();
  final assetIcons = await _getAssetIcons();

  final icons = Map.fromIterable(
    assetIcons,
    key: (e) => e.assetId,
    value: (e) => e.url,
  );

  final list = assets
      .where((e) => e.typeIsCrypto)
      .where((e) => e.volume1MthUsd > 1000.0)
      .where((e) => e.name != null)
      .where((e) => e.priceUsd != null)
      .where((e) => icons.containsKey(e.assetId))
      .toList();

  list.sort((a, b) => b.volume1MthUsd.compareTo(a.volume1MthUsd));

  return list
      .take(100)
      .map((e) => Crypto(
            assetId: e.assetId,
            name: e.name,
            volume1HrsUsd: e.volume1HrsUsd,
            volume1DayUsd: e.volume1DayUsd,
            volume1MthUsd: e.volume1MthUsd,
            priceUsd: e.priceUsd,
            iconUrl: icons[e.assetId],
          ))
      .toList();
}

@immutable
class _PriceData {
  _PriceData({
    @required this.timePeriodStart,
    @required this.timePeriodEnd,
    @required this.priceHigh,
    @required this.priceLow,
  });

  final DateTime timePeriodStart;
  final DateTime timePeriodEnd;
  final double priceHigh;
  final double priceLow;

  factory _PriceData.fromMap(Map<String, dynamic> json) => _PriceData(
        timePeriodStart: DateTime.parse(json["time_period_start"]),
        timePeriodEnd: DateTime.parse(json["time_period_end"]),
        priceHigh: json["price_high"]?.toDouble(),
        priceLow: json["price_low"]?.toDouble(),
      );
}

Future<List<_PriceData>> _getPriceSeries({
  @required String assetId,
  String duration = '1DAY',
  int points = 30,
}) async {
  final response = await http
      .get(
        '$_baseUrl/v1/ohlcv/$assetId/USD/latest?period_id=$duration&limit=$points',
        headers: _headers,
      )
      .timeout(_timeLimit);

  print(
      '$_baseUrl/v1/ohlcv/$assetId/USD/latest?period_id=$duration&limit=$points&apiKey=$_apiKey');

  if (response.statusCode == 200) {
    final List<dynamic> list = json.decode(response.body);

    return list.map((e) => _PriceData.fromMap(e)).toList();
  } else {
    throw 'statusCode != 200';
  }
}

@immutable
class TimedData {
  final DateTime time;
  final double data;

  TimedData(this.time, this.data);
}

Future<List<TimedData>> getTimeSeries({
  @required String assetId,
}) async {
  final list = await _getPriceSeries(
    assetId: assetId,
    duration: '1HRS',
    points: 24 * 30,
  );

  return list
      .map((e) => TimedData(
            e.timePeriodEnd,
            (e.priceLow + e.priceHigh) / 2,
          ))
      .toList();
}
