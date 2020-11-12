import 'package:bloc/bloc.dart';
import 'package:cryptolist/data/remote/remote.dart';
import 'package:cryptolist/pages/list/bloc/list_page_event.dart';
import 'package:cryptolist/pages/list/bloc/list_page_state.dart';
import 'package:meta/meta.dart';

export 'package:cryptolist/pages/list/bloc/list_page_event.dart';
export 'package:cryptolist/pages/list/bloc/list_page_state.dart';

class ListPageBloc extends Bloc<ListPageEvent, ListPageState> {
  final Remote remote;

  ListPageBloc({@required this.remote}) : super(ListPageStateEmpty());

  @override
  Stream<ListPageState> mapEventToState(ListPageEvent event) async* {
    if (event is ListPageEventLoad) {
      yield ListPageStateLoading();
      try {
        final cryptos = await remote.getCryptos();
        yield ListPageStateSuccess(cryptos: cryptos);
      } catch (_) {
        yield ListPageStateError();
      }
    }
  }
}
