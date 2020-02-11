import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.times,
            color: appThemeColor,
          ),
          onPressed: () {
            _showExitConfirmation();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 40),
        child: Center(
          child: FutureBuilder(
              future: loadPrayerDataStatus(),
              builder: (BuildContext context, AsyncSnapshot<ErrorStatusEnum> snapshot) {
                // set icon and text
                String message = "Loading";
                Icon icon = Icon(FontAwesomeIcons.syncAlt, size: 40, color: appThemeColor);
                if (snapshot.hasData) {
                  message = errorStatusEnumMap[snapshot.data];
                  if (snapshot.data != ErrorStatusEnum.OK) {
                    icon = Icon(FontAwesomeIcons.thumbsDown, size: 40, color: appThemeColor);
                  } else {
                    icon = Icon(FontAwesomeIcons.thumbsUp, size: 40, color: appThemeColor);
                    // go to /home when finish
                    SchedulerBinding.instance.scheduleFrameCallback((callback) {
                      // delay is needed to make sure user can finish read the status enum string
                      Future.delayed(const Duration(seconds: 1), () {
                        Navigator.pushReplacementNamed(context, '/home');
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
    if (getSelectedZoneReturn.item1 != ErrorStatusEnum.OK) {
      return ErrorStatusEnum.ERROR_GET_SELECTED_ZONE;
    }

    // populate selected zone
    PrayerTimeZone selectedZone = getSelectedZoneReturn.item2;
    if (selectedZone == null) {
      // set zone
      if (DatabaseItemPrayerZone().setSelectedZone(await DatabaseHelper.getInstance.database, 'SGR01') !=
          ErrorStatusEnum.OK) {
        return ErrorStatusEnum.ERROR_SET_SELECTED_ZONE;
      }
      // get the selected zone after set the selected zone
      getSelectedZoneReturn = await DatabaseItemPrayerZone().getSelectedZone(await DatabaseHelper.getInstance.database);
      if (getSelectedZoneReturn.item1 != ErrorStatusEnum.OK) {
        return getSelectedZoneReturn.item1;
      } else if (getSelectedZoneReturn.item2 == null) {
        return ErrorStatusEnum.ERROR_GET_SELECTED_ZONE;
      }
      selectedZone = getSelectedZoneReturn.item2;
    }

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

  // exit confirmation upon exit
  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Exit"),
          content: Text("Are you sure exit the application?"),
          actions: <Widget>[
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            ),
          ],
        );
      },
    );
  }
}
