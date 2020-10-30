import 'package:cryptolist/data/remote/service.dart';
import 'package:meta/meta.dart';

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

@immutable
class TimedData {
  final DateTime time;
  final double data;

  TimedData(this.time, this.data);
}

Future<List<Crypto>> getCryptos() async {
  final assets = await getAssets();
  final assetIcons = await getAssetIcons();

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

Future<List<TimedData>> getTimeSeries({
  @required String assetId,
}) async {
  final list = await getPriceSeries(
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
