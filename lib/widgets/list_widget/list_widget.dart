import 'package:cryptolist/data/remote/remote.dart';
import 'package:cryptolist/widgets/list_item_widget/list_item_widget.dart';
import 'package:cryptolist/widgets/list_widget/bloc/list_widget_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListWidget extends StatefulWidget {
  static Widget create({@required List<Crypto> cryptos}) {
    return BlocProvider(
      create: (context) => ListWidgetBloc(
        allCryptos: cryptos,
      ),
      child: ListWidget(),
    );
  }

  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  final TextEditingController _controller = TextEditingController();
  ListWidgetBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<ListWidgetBloc>(context);

    super.initState();
  }

  @override
  void dispose() {
    _controller.value = TextEditingValue.empty;
    _controller.dispose();
    _bloc?.close();

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
                          _clearFilter();
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
                _checkFilter();
              });
            },
          ),
        ),
        BlocBuilder(
          cubit: _bloc,
          builder: (context, state) {
            if (state is ListWidgetStateWithData) {
              final cryptos = state.cryptos;

              return Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final crypto = cryptos[index];

                    return ListItemWidget(crypto: crypto);
                  },
                  itemCount: cryptos.length,
                ),
              );
            }

            // without data
            return Text(
              'No item found.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1,
            );
          },
        ),
      ],
    );
  }

  void _clearFilter() {
    _controller.value = TextEditingValue.empty;
    _bloc.add(ListWidgetEventClearFilter());
  }

  void _checkFilter() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      _clearFilter();
    } else {
      _bloc.add(ListWidgetEventFilter(
        filterText: text,
      ));
    }
  }
}
