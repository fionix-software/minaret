import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

import 'package:waktuku/about.dart';
import 'package:waktuku/logic/main_database.dart';
import 'package:waktuku/logic/prayer_time_data_database.dart';
import 'package:waktuku/logic/prayer_time_util.dart';
import 'package:waktuku/logic/prayer_time_zone_database.dart';
import 'package:waktuku/model/prayer_time_data.dart';
import 'package:waktuku/model/prayer_time_zone.dart';
import 'package:waktuku/zone.dart';
import 'package:waktuku/logic/common.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  Widget timeCard(String salatTime, String time) {
    return Card(
      elevation: 0,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Column(
          children: <Widget>[
            Text(salatTime),
            Text(
              time,
              style: TextStyle(fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              FontAwesomeIcons.syncAlt,
              color: appThemeColor,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              FontAwesomeIcons.mapMarker,
              color: appThemeColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ZonePage()),
              );
            },
          ),
          IconButton(
            icon: Icon(
              FontAwesomeIcons.info,
              color: appThemeColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Center(
        child: FutureBuilder(
            future: getPrayerTimeData(),
            builder: (BuildContext context,
                AsyncSnapshot<Tuple3<PrayerTimeZone, PrayerTimeData, ErrorStatusEnum>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.item3 == ErrorStatusEnum.OK) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 40, right: 40, bottom: 40),
                        child: Column(
                          children: <Widget>[
                            Text(
                              snapshot.data.item1.code,
                              style: TextStyle(
                                fontSize: 40,
                                color: appThemeColor,
                              ),
                            ),
                            Text(snapshot.data.item2.date),
                            Text(PrayerTimeUtil.fixHijriCalendar(snapshot.data.item2.hijri)),
                            Text(
                              snapshot.data.item1.region,
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                      timeCard('Imsak', snapshot.data.item2.imsak),
                      timeCard('Subuh', snapshot.data.item2.fajr),
                      timeCard('Syuruk', snapshot.data.item2.syuruk),
                      timeCard('Zohor', snapshot.data.item2.dhuhr),
                      timeCard('Asar', snapshot.data.item2.asr),
                      timeCard('Maghrib', snapshot.data.item2.maghrib),
                      timeCard('Isyak', snapshot.data.item2.isha),
                    ],
                  );
                }
                return Text(errorStatusEnumMap[snapshot.data.item3]);
              }
              return Text('Loading');
            }),
      ),
      backgroundColor: Colors.white,
    );
  }

  Future<Tuple3<PrayerTimeZone, PrayerTimeData, ErrorStatusEnum>> getPrayerTimeData() async {
    // get selected zone
    var getSelectedZoneReturn =
        await DatabaseItemPrayerZone().getSelectedZone(await DatabaseHelper.getInstance.database);
    if (getSelectedZoneReturn.item1 != ErrorStatusEnum.OK) {
      return Tuple3(null, null, getSelectedZoneReturn.item1);
    } else if (getSelectedZoneReturn.item2 == null) {
      return Tuple3(null, null, ErrorStatusEnum.ERROR_GET_SELECTED_ZONE);
    }
    PrayerTimeZone selectedZone = getSelectedZoneReturn.item2;

    // get current selected zone data
    var getPrayerDataFromTodayReturn = await DatabaseItemPrayerTime()
        .getPrayerDataFromDate(await DatabaseHelper.getInstance.database, selectedZone.code, DateTime.now());
    if (getPrayerDataFromTodayReturn.item1 != ErrorStatusEnum.OK) {
      return Tuple3(selectedZone, null, getPrayerDataFromTodayReturn.item1);
    } else if (getPrayerDataFromTodayReturn.item2 == null) {
      return Tuple3(selectedZone, null, ErrorStatusEnum.ERROR_GET_SELECTED_ZONE_DATA);
    }
    PrayerTimeData selectedZoneData = getPrayerDataFromTodayReturn.item2;

    // fix date
    selectedZoneData.date =
        DateFormat('dd MMMM yyyy').format(DateFormat('dd-MMM-yyyy').parse(selectedZoneData.date));

    // return
    return Tuple3(selectedZone, selectedZoneData, ErrorStatusEnum.OK);
  }
}
