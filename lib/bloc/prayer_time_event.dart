part of 'prayer_time_bloc.dart';

abstract class PrayerTimeEvent extends Equatable {
  const PrayerTimeEvent();
}

class PrayerTimeLoad extends PrayerTimeEvent {
  final DateTime loadDate;
  PrayerTimeLoad([this.loadDate]);
  @override
  List<Object> get props => [
        this.loadDate,
      ];
}

class PrayerTimeRefresh extends PrayerTimeEvent {
  @override
  List<Object> get props => [];
}
