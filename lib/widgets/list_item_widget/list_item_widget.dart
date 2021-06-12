import 'package:cryptolist/data/remote/remote.dart';
import 'package:cryptolist/widgets/crypto_page/crypto_page.dart';
import 'package:flutter/material.dart';

class ListItemWidget extends StatelessWidget {
  ListItemWidget({@required this.crypto});

  final Crypto crypto;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hero(
        tag: 'crypto_${crypto.assetId}_icon',
        child: Image.network(
          crypto.iconUrl,
          fit: BoxFit.contain,
          height: 48.0,
          width: 48.0,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 48.0,
              width: 48.0,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                shape: BoxShape.circle,
              ),
            );
          },
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            crypto.name,
            style: TextStyle(color: Colors.black, fontSize: 15),
            //provided textStyle with size to fix the over hided pixel issues @ck 6/11/21
          ),
          Text(
            '${crypto.priceUsd.toStringAsFixed(3)}\$',
            style: TextStyle(color: Colors.black, fontSize: 15),
            //provided textStyle with size to fix the over hided pixel issues @ck 6/11/21
          ),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            crypto.assetId,
            style: TextStyle(color: Colors.black, fontSize: 12),
            //provided textStyle with size to fix the over hided pixel issues @ck 6/11/21
          ),
          Text(
            'Monthly ${crypto.volume1MthUsd.toStringAsFixed(1)}\$',
            style: TextStyle(color: Colors.black, fontSize: 12),
            //provided textStyle with size to fix the over hided pixel issues @ck 6/11/21
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CryptoPage.create(
              crypto: crypto,
            ),
          ),
        );
      },
    );
  }
}
