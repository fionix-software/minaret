part of 'prayer_zone_bloc.dart';

abstract class PrayerZoneState extends Equatable {
  const PrayerZoneState();
}

class PrayerZoneLoading extends PrayerZoneState {
  @override
  List<Object> get props => [];
}

class PrayerZoneLoadSuccess extends PrayerZoneState {
  final List<PrayerTimeZone> zone;
  PrayerZoneLoadSuccess(this.zone);

  @override
  List<Object> get props => [
        this.zone,
      ];
}

class PrayerZoneRefreshSuccess extends PrayerZoneState {
  final List<PrayerTimeZone> zone;
  PrayerZoneRefreshSuccess(this.zone);
  @override
  List<Object> get props => [
        this.zone,
      ];
}

class PrayerZoneSetSuccess extends PrayerZoneState {
  @override
  List<Object> get props => [];
}

class PrayerZoneError extends PrayerZoneState {
  final String errorMessage;
  PrayerZoneError(this.errorMessage);

  @override
  List<Object> get props => [
        this.errorMessage,
      ];
}

class PrayerZoneUnknownState extends PrayerZoneState {
  @override
  List<Object> get props => [];
}
