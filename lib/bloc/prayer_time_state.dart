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

class PrayerTimeSuccess extends PrayerTimeState {
  final PrayerTimeData zoneData;
  PrayerTimeSuccess(this.zoneData);
  @override
  List<Object> get props => [
        this.zoneData,
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

class PrayerTimeNotInitialized extends PrayerTimeState {
  PrayerTimeNotInitialized();
  @override
  List<Object> get props => [];
}
