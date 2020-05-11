part of 'prayer_zone_bloc.dart';

abstract class PrayerZoneState extends Equatable {
  const PrayerZoneState();
}

// common

class PrayerZoneLoading extends PrayerZoneState {
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
  final List<PrayerTimeZone> zone;
  PrayerZoneLoadSuccess(this.zone);
  @override
  List<Object> get props => [
        this.zone,
      ];
}

class PrayerZoneSetSuccess extends PrayerZoneState {
  @override
  List<Object> get props => [];
}
