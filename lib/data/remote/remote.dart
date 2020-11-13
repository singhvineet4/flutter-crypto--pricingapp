import 'package:cryptolist/data/remote/model/crypto.dart';
import 'package:cryptolist/data/remote/model/time_data.dart';
import 'package:cryptolist/data/remote/service/service.dart';
import 'package:meta/meta.dart';

export 'package:cryptolist/data/remote/model/crypto.dart';
export 'package:cryptolist/data/remote/model/time_data.dart';

// todo change this
const remote = Remote(
  service: Service(),
);

class Remote {
  final Service service;

  const Remote({@required this.service});

  Future<List<Crypto>> getCryptos() async {
    final assets = await service.getAssets();
    final assetIcons = await service.getAssetIcons();

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
    final list = await service.getPriceSeries(
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
}
