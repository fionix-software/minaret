class PrayerTimeData {
  // field
  String hijri;
  String zone;
  String date;
  String day;
  String imsak;
  String fajr;
  String syuruk;
  String dhuhr;
  String asr;
  String maghrib;
  String isha;

  // method
  PrayerTimeData({
    this.hijri,
    this.zone,
    this.date,
    this.day,
    this.imsak,
    this.fajr,
    this.syuruk,
    this.dhuhr,
    this.asr,
    this.maghrib,
    this.isha,
  });

  // from json to object
  factory PrayerTimeData.fromJson(Map<String, dynamic> parsedJson) {
    return PrayerTimeData(
      hijri: parsedJson['hijri'],
      zone: parsedJson['zone'],
      date: parsedJson['date'],
      day: parsedJson['day'],
      imsak: parsedJson['imsak'],
      fajr: parsedJson['fajr'],
      syuruk: parsedJson['syuruk'],
      dhuhr: parsedJson['dhuhr'],
      asr: parsedJson['asr'],
      maghrib: parsedJson['maghrib'],
      isha: parsedJson['isha'],
    );
  }

  // from object to map
  Map<String, dynamic> toMap() {
    return {
      'hijri': this.hijri,
      'zone': this.zone,
      'date': this.date,
      'day': this.day,
      'imsak': this.imsak,
      'fajr': this.fajr,
      'syuruk': this.syuruk,
      'dhuhr': this.dhuhr,
      'asr': this.asr,
      'maghrib': this.maghrib,
      'isha': this.isha,
    };
  }
}
