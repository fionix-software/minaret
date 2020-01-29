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
  // factory
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
}
