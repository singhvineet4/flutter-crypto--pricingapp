import 'package:cryptolist/pages/crypto/crypto_page.dart';
import 'package:cryptolist/pages/list/bloc/list_page_bloc.dart';
import 'package:cryptolist/pages/list/widgets/list/list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListPage extends StatefulWidget {
  final CryptoPageCreator cryptoPageCreator;

  const ListPage({@required this.cryptoPageCreator});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  ListPageBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<ListPageBloc>(context);

    _load();

    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();

    super.dispose();
  }

  void _load() {
    _bloc.add(ListPageEventLoad());
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
        child: BlocBuilder(
          cubit: _bloc,
          builder: (context, state) {
            if (state is ListPageStateLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ListPageStateError) {
              return Center(
                child: Text(
                  'Error, please reload ...',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              );
            }

            if (state is ListPageStateSuccess) {
              return ListWidget(
                cryptoPageCreator: widget.cryptoPageCreator,
                cryptos: state.cryptos,
              );
            }

            // ListPageStateEmpty
            return Container();
          },
        ),
      ),
    );
  }
}
