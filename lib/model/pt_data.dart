import 'package:minaret/model/pt_zone.dart';

class PrayerTimeData extends PrayerTimeZone {
  // field
  final String hijri;
  final String date;
  final String day;
  final String imsak;
  final String fajr;
  final String syuruk;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  // method
  PrayerTimeData({
    String zoneCode,
    String zoneState,
    String zoneRegion,
    this.hijri,
    this.date,
    this.day,
    this.imsak,
    this.fajr,
    this.syuruk,
    this.dhuhr,
    this.asr,
    this.maghrib,
    this.isha,
  }) : super(zoneCode: zoneCode, zoneState: zoneState, zoneRegion: zoneRegion);

  // from json to object
  factory PrayerTimeData.fromJson(Map<String, dynamic> parsedJson) => PrayerTimeData(
        zoneCode: parsedJson['zoneCode'],
        zoneState: parsedJson['zoneState'],
        zoneRegion: parsedJson['zoneRegion'],
        hijri: parsedJson['hijri'],
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

  // from object to map
  Map<String, dynamic> toMap() => {
        'zoneCode': this.zoneCode,
        'zoneState': this.zoneState,
        'zoneRegion': this.zoneRegion,
        'hijri': this.hijri,
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
