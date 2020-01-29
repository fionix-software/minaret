class PrayerTimeZone {
  // field
  String code;
  String state;
  String region;
  bool isSelected;
  // method
  PrayerTimeZone({
    this.code,
    this.state,
    this.region,
    this.isSelected,
  });
  // factory
  factory PrayerTimeZone.fromJson(Map<String, dynamic> parsedJson) {
    return PrayerTimeZone(
      code: parsedJson['code'],
      state: parsedJson['state'],
      region: parsedJson['region'],
      isSelected: parsedJson['isSelected'],
    );
  }
}
