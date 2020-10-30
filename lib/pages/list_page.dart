import 'package:cryptolist/data/remote/remote.dart';
import 'package:cryptolist/pages/crypto_page.dart';
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Future<List<Crypto>> _future;

  @override
  void initState() {
    _load();

    super.initState();
  }

  void _load() {
    _future = getCryptos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currencies'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _load();
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              final List<Crypto> cryptos = snapshot.data;

              return CryptoListWidget(cryptos: cryptos);
            }

            return Center(
              child: Text(
                'Error, please reload ...',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CryptoListWidget extends StatefulWidget {
  const CryptoListWidget({
    @required this.cryptos,
  });

  final List<Crypto> cryptos;

  @override
  _CryptoListWidgetState createState() => _CryptoListWidgetState();
}

class _CryptoListWidgetState extends State<CryptoListWidget> {
  final TextEditingController _controller = TextEditingController();
  List<Crypto> _filteredCryptos;

  @override
  void initState() {
    _filteredCryptos = widget.cryptos;

    super.initState();
  }

  @override
  void dispose() {
    _controller.value = TextEditingValue.empty;
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(8.0),
              prefixIcon: Icon(Icons.search),
              suffixIcon: _controller.text.isEmpty
                  ? null
                  : IconButton(
                      icon: Icon(Icons.cancel_outlined),
                      onPressed: () {
                        setState(() {
                          _controller.text = '';
                          _filteredCryptos = widget.cryptos;
                        });
                      },
                    ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide(
                  width: 1.0,
                  color: Colors.black,
                  style: BorderStyle.solid,
                ),
              ),
            ),
            textInputAction: TextInputAction.search,
            maxLines: 1,
            autocorrect: false,
            autofocus: false,
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            onChanged: (_) {
              setState(() {
                _filter();
              });
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              final crypto = _filteredCryptos[index];

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
                    Text(crypto.name),
                    Text(
                      '${crypto.priceUsd.toStringAsFixed(3)}\$',
                    ),
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(crypto.assetId),
                    Text(
                      'Monthly ${crypto.volume1MthUsd.toStringAsFixed(1)}\$',
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CryptoPage(crypto: crypto),
                    ),
                  );
                },
              );
            },
            itemCount: _filteredCryptos.length,
          ),
        ),
      ],
    );
  }

  void _filter() {
    final text = _controller.text.trim().toLowerCase();
    if (text.isEmpty) {
      _filteredCryptos = widget.cryptos;
    } else {
      _filteredCryptos = widget.cryptos
          .where((e) =>
              e.assetId.toLowerCase().contains(text) ||
              e.name.toLowerCase().contains(text))
          .toList();
    }
  }
}
