import 'dart:math' as math;

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cryptolist/data/remote/remote.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CryptoPage extends StatefulWidget {
  final Crypto crypto;

  CryptoPage({@required this.crypto});

  @override
  _CryptoPageState createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  Future _future;

  void _launchWebsite() {
    try {
      launch(
        'https://www.google.com/search?q=${widget.crypto.name}, ${widget.crypto.assetId}',
      );
    } catch (e) {
      print(e);
    }
  }

  void _loadData() {
    _future = getTimeSeries(assetId: widget.crypto.assetId);
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
              RowPairWidget(
                name: 'Price',
                price: widget.crypto.priceUsd,
              ),
              RowPairWidget(
                name: 'Monthly',
                price: widget.crypto.volume1MthUsd,
              ),
              RowPairWidget(
                name: 'Daily',
                price: widget.crypto.volume1DayUsd,
              ),
              RowPairWidget(
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

                      print(snapshot.error);

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

class RowPairWidget extends StatelessWidget {
  RowPairWidget({
    @required this.name,
    @required this.price,
  });

  final String name;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.headline6,
        ),
        Text(
          '${price.toStringAsFixed(3)}\$',
          style: Theme.of(context).textTheme.headline6,
        ),
      ],
    );
  }
}

class ChartWidget extends StatelessWidget {
  final List<charts.Series<TimedData, DateTime>> seriesList;
  final double min;
  final double max;

  ChartWidget(this.seriesList, this.min, this.max);

  factory ChartWidget.create(List<TimedData> data) {
    final series = charts.Series<TimedData, DateTime>(
      id: 'Price',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (TimedData e, _) => e.time,
      measureFn: (TimedData e, _) => e.data,
      data: data,
    );

    final numbers = data.map((e) => e.data).toList();
    final min = numbers.reduce(math.min);
    final max = numbers.reduce(math.max);
    final dist = max - min;

    return ChartWidget(
      [
        series,
      ],
      min - dist / 5,
      max + dist / 5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: false,
      dateTimeFactory: charts.LocalDateTimeFactory(),
      behaviors: [
        charts.PanAndZoomBehavior(),
      ],
      primaryMeasureAxis: charts.NumericAxisSpec(
        viewport: charts.NumericExtents.fromValues([
          min,
          max,
        ]),
      ),
    );
  }
}
