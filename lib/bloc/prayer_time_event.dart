part of 'prayer_time_bloc.dart';

abstract class PrayerTimeEvent extends Equatable {
  const PrayerTimeEvent();
}

class PrayerTimeLoad extends PrayerTimeEvent {
  @override
  List<Object> get props => [];
}

class PrayerTimeRefresh extends PrayerTimeEvent {
  @override
  List<Object> get props => [];
}