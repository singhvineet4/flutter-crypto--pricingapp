import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class TimedData extends Equatable {
  final DateTime time;
  final double data;

  TimedData(this.time, this.data) {
    ArgumentError.checkNotNull(time);
    ArgumentError.checkNotNull(data);
  }

  @override
  List<Object> get props => [
        time,
        data,
      ];
}
