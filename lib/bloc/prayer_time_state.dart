part of 'prayer_time_bloc.dart';

abstract class PrayerTimeState extends Equatable {
  const PrayerTimeState();
}

class PrayerTimeLoading extends PrayerTimeState {
  @override
  List<Object> get props => [];
}

class PrayerTimeRetrieving extends PrayerTimeState {
  @override
  List<Object> get props => [];
}

class PrayerTimeLoadSuccess extends PrayerTimeState {
  final PrayerTimeZone zone;
  final PrayerTimeData zoneData;
  PrayerTimeLoadSuccess(this.zone, this.zoneData);
  @override
  List<Object> get props => [
        this.zone,
        this.zoneData,
      ];
}

class PrayerTimeError extends PrayerTimeState {
  final String errorMessage;
  PrayerTimeError(this.errorMessage);
  @override
  List<Object> get props => [
        this.errorMessage
      ];
}

class PrayerTimeDataNotInitialized extends PrayerTimeState {
  @override
  List<Object> get props => [];
}

class PrayerTimeDataUnknownState extends PrayerTimeState {
  @override
  List<Object> get props => [];
}
