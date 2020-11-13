import 'package:cryptolist/data/remote/remote.dart';
import 'package:cryptolist/pages/crypto_page/bloc/crypto_page_bloc.dart';
import 'package:cryptolist/pages/crypto_page/widgets/chart_widget/chart_widget.dart';
import 'package:cryptolist/pages/crypto_page/widgets/price_widget/price_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

typedef Widget CryptoPageCreator(BuildContext context, {Crypto crypto});

class CryptoPage extends StatefulWidget {
  static Widget create({@required Crypto crypto}) {
    return BlocProvider(
      create: (context) => CryptoPageBloc(),
      child: CryptoPage(
        crypto: crypto,
      ),
    );
  }

  final Crypto crypto;

  CryptoPage({@required this.crypto});

  @override
  _CryptoPageState createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  CryptoPageBloc _bloc;

  Future _launchWebsite() async {
    try {
      final url = 'https://www.google.com/search?q=${widget.crypto.name}';
      if (await canLaunch(url)) {
        await launch(url);
      }
    } catch (_) {}
  }

  void _loadData() {
    _bloc.add(CryptoPageEventLoad(
      assetId: widget.crypto.assetId,
    ));
  }

  @override
  void initState() {
    _bloc = BlocProvider.of<CryptoPageBloc>(context);

    _loadData();

    super.initState();
  }

  @override
  void dispose() {
    _bloc?.close();
    super.dispose();
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
                  child: BlocBuilder(
                    cubit: _bloc,
                    builder: (context, state) {
                      if (state is CryptoPageStateLoading) {
                        return CircularProgressIndicator();
                      }

                      if (state is CryptoPageStateError) {
                        return Text(
                          'Error, please reload ...',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        );
                      }

                      if (state is CryptoPageStateSuccess) {
                        return ChartWidget.create(
                          data: state.data,
                        );
                      }

                      // CryptoPageStateEmpty
                      return Container();
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
