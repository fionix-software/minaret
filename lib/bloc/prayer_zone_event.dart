part of 'prayer_zone_bloc.dart';

abstract class PrayerZoneEvent extends Equatable {
  const PrayerZoneEvent();
}

class PrayerZoneLoad extends PrayerZoneEvent {
  @override
  List<Object> get props => [];
}

class PrayerZoneSet extends PrayerZoneEvent {
  final String zoneCode;
  PrayerZoneSet(this.zoneCode);
  @override
  List<Object> get props => [
        this.zoneCode,
      ];
}
