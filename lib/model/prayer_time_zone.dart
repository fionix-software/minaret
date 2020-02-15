class PrayerTimeZone {
  // field
  String code;
  String state;
  String region;
  int isSelected;
  
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

  // from object to map
  Map<String, dynamic> toMap() {
    return {
      'code': this.code,
      'state': this.state,
      'region': this.region,
      'isSelected': (this.isSelected == null) ? 0 : this.isSelected,
    };
  }
}
