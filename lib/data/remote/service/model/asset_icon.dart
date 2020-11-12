import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class AssetIcon extends Equatable {
  const AssetIcon({
    @required this.assetId,
    @required this.url,
  });

  final String assetId;
  final String url;

  factory AssetIcon.fromMap(Map<String, dynamic> json) => AssetIcon(
        assetId: json["asset_id"],
        url: json["url"],
      );

  @override
  List<Object> get props => [
        assetId,
        url,
      ];
}
