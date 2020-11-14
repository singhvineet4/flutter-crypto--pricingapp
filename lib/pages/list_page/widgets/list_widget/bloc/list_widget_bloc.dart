import 'package:bloc/bloc.dart';
import 'package:cryptolist/data/remote/remote.dart';
import 'package:cryptolist/pages/list_page/widgets/list_widget/bloc/list_widget_event.dart';
import 'package:cryptolist/pages/list_page/widgets/list_widget/bloc/list_widget_state.dart';
import 'package:meta/meta.dart';

export 'package:cryptolist/pages/list_page/widgets/list_widget/bloc/list_widget_event.dart';
export 'package:cryptolist/pages/list_page/widgets/list_widget/bloc/list_widget_state.dart';

class ListWidgetBloc extends Bloc<ListWidgetEvent, ListWidgetState> {
  final List<Crypto> allCryptos;

  ListWidgetBloc({@required this.allCryptos})
      : super(ListWidgetStateFull(
          cryptos: allCryptos,
        ));

  @override
  Stream<ListWidgetState> mapEventToState(ListWidgetEvent event) async* {
    if (event is ListWidgetEventClearFilter) {
      yield ListWidgetStateFull(
        cryptos: allCryptos,
      );
    } else if (event is ListWidgetEventFilter) {
      final lowerText = event.filterText.trim().toLowerCase();
      final cryptos = allCryptos
          .where((e) =>
              e.assetId.toLowerCase().contains(lowerText) ||
              e.name.toLowerCase().contains(lowerText))
          .toList();
      if (cryptos.isEmpty) {
        yield ListWidgetStateFilteredEmpty(
          filterText: event.filterText,
        );
      } else {
        yield ListWidgetStateFilteredFound(
          filterText: event.filterText,
          cryptos: cryptos,
        );
      }
    }
  }
}
