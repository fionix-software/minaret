class PrayerTimeZone {
  // field
  final String zoneCode;
  final String zoneState;
  final String zoneRegion;

  // method
  PrayerTimeZone({
    this.zoneCode,
    this.zoneState,
    this.zoneRegion,
  });

  // factory
  factory PrayerTimeZone.fromJson(Map<String, dynamic> parsedJson) => PrayerTimeZone(
        zoneCode: parsedJson['zoneCode'],
        zoneState: parsedJson['zoneState'],
        zoneRegion: parsedJson['zoneRegion'],
      );

  // from object to map
  Map<String, dynamic> toMap() => {
        'zoneCode': this.zoneCode,
        'zoneState': this.zoneState,
        'zoneRegion': this.zoneRegion,
      };
}
