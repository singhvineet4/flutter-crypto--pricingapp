import 'package:cryptolist/data/remote/remote.dart';
import 'package:cryptolist/pages/crypto_page/widgets/chart_widget/chart_widget.dart';
import 'package:cryptolist/pages/crypto_page/widgets/price_widget/price_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

typedef Widget CryptoPageCreator(BuildContext context, {Crypto crypto});

class CryptoPage extends StatefulWidget {
  final Crypto crypto;

  CryptoPage({@required this.crypto});

  @override
  _CryptoPageState createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  Future _future;

  Future _launchWebsite() async {
    try {
      final url = 'https://www.google.com/search?q=${widget.crypto.name}';
      if (await canLaunch(url)) {
        await launch(url);
      }
    } catch (_) {}
  }

  void _loadData() {
    _future = remote.getTimeSeries(assetId: widget.crypto.assetId);
  }

  @override
  void initState() {
    _loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.crypto.name),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _loadData();
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                child: Hero(
                  tag: 'crypto_${widget.crypto.assetId}_icon',
                  child: Image.network(
                    widget.crypto.iconUrl,
                    fit: BoxFit.contain,
                    height: 128.0,
                    width: 128.0,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 128.0,
                        width: 128.0,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          shape: BoxShape.circle,
                        ),
                      );
                    },
                  ),
                ),
                onTap: _launchWebsite,
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                widget.crypto.assetId,
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 16.0,
              ),
              PriceWidget(
                name: 'Price',
                price: widget.crypto.priceUsd,
              ),
              PriceWidget(
                name: 'Monthly',
                price: widget.crypto.volume1MthUsd,
              ),
              PriceWidget(
                name: 'Daily',
                price: widget.crypto.volume1DayUsd,
              ),
              PriceWidget(
                name: 'Hourly',
                price: widget.crypto.volume1HrsUsd,
              ),
              SizedBox(
                height: 32.0,
              ),
              Expanded(
                child: Center(
                  child: FutureBuilder(
                    future: _future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return CircularProgressIndicator();
                      }

                      if (snapshot.hasData) {
                        final List<TimedData> data = snapshot.data;

                        return ChartWidget.create(data);
                      }

                      return Text(
                        'Error, please reload ...',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 32.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
