part of 'calendar_bloc.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();
}

class CalendarLoading extends CalendarState {
  @override
  List<Object> get props => [];
}

class CalendarLoadSuccess extends CalendarState {
  final DateTime startDate, endDate;
  CalendarLoadSuccess(this.startDate, this.endDate);
  @override
  List<Object> get props => [
        this.startDate,
        this.endDate,
      ];
}

class CalendarLoadFailed extends CalendarState {
  final String message;
  CalendarLoadFailed(this.message);
  @override
  List<Object> get props => [
        this.message,
      ];
}
