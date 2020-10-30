import 'package:cryptolist/data/remote/remote.dart';
import 'package:cryptolist/pages/list/list_widget.dart';
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

              return ListWidget(cryptos: cryptos);
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
