import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:waktuku/logic/common.dart';
import 'package:waktuku/logic/main_database.dart';
import 'package:waktuku/logic/prayer_time_data_database.dart';
import 'package:waktuku/logic/prayer_time_util.dart';
import 'package:waktuku/logic/prayer_time_zone_database.dart';
import 'package:waktuku/model/prayer_time_zone.dart';

class CheckingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CheckingPageState();
  }
}

class CheckingPageState extends State<CheckingPage> {
  // build widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(left: 40, right: 40, bottom: 40),
        child: Center(
          child: FutureBuilder(
              future: loadPrayerDataStatus(),
              builder: (BuildContext context, AsyncSnapshot<ErrorStatusEnum> snapshot) {
                // set icon and text
                String message = "Loading";
                Icon icon = Icon(FontAwesomeIcons.syncAlt, size: 40, color: appThemeColor);
                if (snapshot.hasData) {
                  message = errorStatusEnumMap[snapshot.data];
                  if (snapshot.data == ErrorStatusEnum.ERROR_GET_SELECTED_ZONE) {
                    // delay is needed to make sure user can finish read the status enum string
                    Future.delayed(const Duration(seconds: 1), () {
                      Navigator.pushReplacementNamed(context, '/zone/first-time');
                    });
                  } else if (snapshot.data != ErrorStatusEnum.OK) {
                    icon = Icon(FontAwesomeIcons.thumbsDown, size: 40, color: appThemeColor);
                  } else {
                    icon = Icon(FontAwesomeIcons.thumbsUp, size: 40, color: appThemeColor);
                    // go to /home when finish
                    SchedulerBinding.instance.scheduleFrameCallback((callback) {
                      // delay is needed to make sure user can finish read the status enum string
                      Future.delayed(const Duration(seconds: 1), () {
                        Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
                      });
                    });
                  }
                }
                // return widget
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    icon,
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: appThemeColor,
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  // loading
  Future<ErrorStatusEnum> loadPrayerDataStatus() async {
    // get zone list
    var getZoneListReturn = await DatabaseItemPrayerZone().getList(await DatabaseHelper.getInstance.database);
    if (getZoneListReturn.item1 != ErrorStatusEnum.OK) {
      return ErrorStatusEnum.ERROR_GET_ZONE_LIST;
    }

    // check zone list
    List<PrayerTimeZone> zoneList = getZoneListReturn.item2;
    if (zoneList.isEmpty) {
      // fetch data
      var retrieveZoneListReturn = await PrayerTimeUtil.retrieveZoneList();
      if (retrieveZoneListReturn.item1 != ErrorStatusEnum.OK) {
        return retrieveZoneListReturn.item1;
      } else if (retrieveZoneListReturn.item2.isEmpty) {
        return ErrorStatusEnum.ERROR_RETRIEVE_ZONE_LIST;
      }
      // add data into database
      zoneList = retrieveZoneListReturn.item2;
      zoneList.forEach((item) async {
        DatabaseItemPrayerZone().insert(await DatabaseHelper.getInstance.database,
            {'code': item.code, 'state': item.state, 'region': item.region, 'isSelected': 0});
      });
    }

    // get selected zone
    var getSelectedZoneReturn =
        await DatabaseItemPrayerZone().getSelectedZone(await DatabaseHelper.getInstance.database);
    if (getSelectedZoneReturn.item1 != ErrorStatusEnum.OK || getSelectedZoneReturn.item2 == null) {
      return ErrorStatusEnum.ERROR_GET_SELECTED_ZONE;
    }
    PrayerTimeZone selectedZone = getSelectedZoneReturn.item2;

    // get current selected zone data
    var getPrayerDataFromTodayReturn = await DatabaseItemPrayerTime()
        .getPrayerDataFromDate(await DatabaseHelper.getInstance.database, selectedZone.code, DateTime.now());
    if (getPrayerDataFromTodayReturn.item1 != ErrorStatusEnum.OK) {
      return getSelectedZoneReturn.item1;
    } else if (getPrayerDataFromTodayReturn.item2 == null) {
      // retrieve zone data
      var retrieveSelectedZoneDataReturn = await PrayerTimeUtil.retrieveZoneData('year', selectedZone.code);
      if (retrieveSelectedZoneDataReturn.item1 != ErrorStatusEnum.OK) {
        return retrieveSelectedZoneDataReturn.item1;
      } else if (retrieveSelectedZoneDataReturn.item2.isEmpty) {
        return ErrorStatusEnum.ERROR_RETRIEVE_ZONE_DATA;
      }
      // add data into database
      retrieveSelectedZoneDataReturn.item2.forEach((item) async {
        DatabaseItemPrayerTime().insert(await DatabaseHelper.getInstance.database, {
          'hijri': item.hijri,
          'zone': item.zone,
          'date': item.date,
          'day': item.day,
          'imsak': item.imsak,
          'fajr': item.fajr,
          'syuruk': item.syuruk,
          'dhuhr': item.dhuhr,
          'asr': item.asr,
          'maghrib': item.maghrib,
          'isha': item.isha,
        });
      });
      // get the zone data after retrieve
      getPrayerDataFromTodayReturn = await DatabaseItemPrayerTime()
          .getPrayerDataFromDate(await DatabaseHelper.getInstance.database, selectedZone.code, DateTime.now());
      if (getPrayerDataFromTodayReturn.item1 != ErrorStatusEnum.OK) {
        return getPrayerDataFromTodayReturn.item1;
      } else if (getPrayerDataFromTodayReturn.item2 == null) {
        return ErrorStatusEnum.ERROR_GET_SELECTED_ZONE_DATA;
      }
    }

    // finished
    return ErrorStatusEnum.OK;
  }
}
