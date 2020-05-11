part of 'prayer_zone_bloc.dart';

abstract class PrayerZoneState extends Equatable {
  const PrayerZoneState();
}

// common

class PrayerZoneRetrieving extends PrayerZoneState {
  @override
  List<Object> get props => [];
}

class PrayerZoneFailed extends PrayerZoneState {
  final String message;
  PrayerZoneFailed(this.message);
  @override
  List<Object> get props => [
        this.message,
      ];
}

// specific

class PrayerZoneLoadSuccess extends PrayerZoneState {
  final bool isFirstTime;
  final List<PrayerTimeZone> zone;
  PrayerZoneLoadSuccess(this.isFirstTime, this.zone);
  @override
  List<Object> get props => [
        this.isFirstTime,
        this.zone,
      ];
}

class PrayerZoneSetSuccess extends PrayerZoneState {
  @override
  List<Object> get props => [];
}
