import 'dart:convert' show json;

import 'package:cryptolist/data/remote/service/model/asset.dart';
import 'package:cryptolist/data/remote/service/model/asset_icon.dart';
import 'package:cryptolist/data/remote/service/model/price_data.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

export 'package:cryptolist/data/remote/service/model/asset.dart';
export 'package:cryptolist/data/remote/service/model/asset_icon.dart';
export 'package:cryptolist/data/remote/service/model/price_data.dart';

@immutable
class Service {
  static const _apiKey = '0FC53B29-D9BB-4BFE-8438-73C33A2D89BC';
  // static const _apiKey = '632DCAFE-4D53-4D25-84FC-DA14CC10CB75';
  // change the api key @ck 6/11/2021

  static const _headers = {
    'X-CoinAPI-Key': _apiKey,
    'Accept': 'application/json',
    'Accept-Encoding': 'deflate, gzip',
  };

  static const _baseUrl = 'https://rest.coinapi.io';

  static const _timeLimit = Duration(seconds: 30);

  const Service();

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
      final List<dynamic> list = json.decode(response.body); //take data in list

      return list.map((e) => PriceData.fromMap(e)).toList();
    } else {
      throw 'statusCode != 200';
    }
  }
}
