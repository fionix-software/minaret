part of 'prayer_time_bloc.dart';

abstract class PrayerTimeState extends Equatable {
  const PrayerTimeState();
}

// common

class PrayerTimeFailed extends PrayerTimeState {
  final String message;
  PrayerTimeFailed(this.message);
  @override
  List<Object> get props => [
        this.message
      ];
}

// specific

class PrayerTimeLoading extends PrayerTimeState {
  @override
  List<Object> get props => [];
}

class PrayerTimeRetrieving extends PrayerTimeState {
  @override
  List<Object> get props => [];
}

class PrayerTimeLoadSuccess extends PrayerTimeState {
  final PrayerTimeData zoneData;
  PrayerTimeLoadSuccess(this.zoneData);
  @override
  List<Object> get props => [
        this.zoneData,
      ];
}

class PrayerTimeRefreshSuccess extends PrayerTimeState {
  final PrayerTimeData zoneData;
  PrayerTimeRefreshSuccess(this.zoneData);
  @override
  List<Object> get props => [
        this.zoneData,
      ];
}
