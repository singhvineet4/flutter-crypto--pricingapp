import 'package:bloc/bloc.dart';
import 'package:cryptolist/data/remote/remote.dart';
import 'package:cryptolist/pages/crypto_page/bloc/crypto_page_event.dart';
import 'package:cryptolist/pages/crypto_page/bloc/crypto_page_state.dart';

export 'package:cryptolist/pages/crypto_page/bloc/crypto_page_event.dart';
export 'package:cryptolist/pages/crypto_page/bloc/crypto_page_state.dart';

class CryptoPageBloc extends Bloc<CryptoPageEvent, CryptoPageState> {
  CryptoPageBloc() : super(CryptoPageStateEmpty());

  @override
  Stream<CryptoPageState> mapEventToState(CryptoPageEvent event) async* {
    if (event is CryptoPageEventLoad) {
      yield CryptoPageStateLoading();
      try {
        final assetId = event.assetId;
        final data = await remote.getTimeSeries(assetId: assetId);
        yield CryptoPageStateSuccess(data: data);
      } catch (_) {
        yield CryptoPageStateError();
      }
    }
  }
}
