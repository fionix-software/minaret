part of 'prayer_zone_bloc.dart';

abstract class PrayerZoneEvent extends Equatable {
  const PrayerZoneEvent();
}

class PrayerZoneRetrieve extends PrayerZoneEvent {
  @override
  List<Object> get props => [];
}

class PrayerZoneSet extends PrayerZoneEvent {
  final PrayerTimeZone zone;
  PrayerZoneSet(this.zone);
  @override
  List<Object> get props => [
        this.zone,
      ];
}