import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class ListWidgetEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class ListWidgetEventClearFilter extends ListWidgetEvent {}

@immutable
class ListWidgetEventFilter extends ListWidgetEvent {
  final String filterText;

  ListWidgetEventFilter({@required this.filterText}) {
    if (filterText.isEmpty) {
      throw 'filterText is empty!';
    }
  }

  @override
  List<Object> get props => [filterText];
}
