import 'package:cryptolist/data/remote/remote.dart';
import 'package:cryptolist/pages/crypto_page/crypto_page.dart';
import 'package:flutter/material.dart';

class ListWidget extends StatefulWidget {
  final List<Crypto> cryptos;

  const ListWidget({
    @required this.cryptos,
  });

  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CryptoPage.create(
                        crypto: crypto,
                      ),
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
