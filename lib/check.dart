import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:waktuku/logic/common.dart';
import 'package:waktuku/logic/main_database.dart';
import 'package:waktuku/logic/prayer_time_data_database.dart';
import 'package:waktuku/logic/prayer_time_util.dart';
import 'package:waktuku/logic/prayer_time_zone_database.dart';
import 'package:waktuku/model/prayer_time_data.dart';
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
        padding: EdgeInsets.only(bottom: 40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                FontAwesomeIcons.syncAlt,
                size: 40,
                color: appThemeColor,
              ),
              FutureBuilder(
                  future: loadPrayerDataStatus(),
                  builder: (BuildContext context, AsyncSnapshot<ErrorStatusEnum> snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          errorStatusEnumMap[snapshot.data],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: appThemeColor,
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          "Loading",
                          style: TextStyle(
                            fontSize: 20,
                            color: appThemeColor,
                          ),
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  // loading
  Future<ErrorStatusEnum> loadPrayerDataStatus() async {
    // get item prayer list
    List<PrayerTimeZone> zoneList = List<PrayerTimeZone>();
    var getListReturnValue = await DatabaseItemPrayerZone().getList(await DatabaseHelper.getInstance.database);
    if (getListReturnValue.item1 != ErrorStatusEnum.OK) {
      return ErrorStatusEnum.ERROR_GET_ZONE_LIST;
    }

    // check list
    zoneList = getListReturnValue.item2;
    if (zoneList.isEmpty) {
      // fetch data
      var parsedZoneListReturnValue = await PrayerTimeUtil.getZoneList();
      if (parsedZoneListReturnValue.item1 != ErrorStatusEnum.OK || parsedZoneListReturnValue.item2.isEmpty) {
        return ErrorStatusEnum.ERROR_RETRIEVE_ZONE_LIST;
      }
      // add data into database
      zoneList = parsedZoneListReturnValue.item2;
      zoneList.forEach((item) async {
        DatabaseItemPrayerZone().insert(await DatabaseHelper.getInstance.database,
            {'code': item.code, 'state': item.state, 'region': item.region, 'isSelected': 0});
      });
    }

    // get selected zone
    var getSelectedZoneReturnValue =
        await DatabaseItemPrayerZone().getSelectedZone(await DatabaseHelper.getInstance.database);
    if (getSelectedZoneReturnValue.item1 != ErrorStatusEnum.OK) {
      return ErrorStatusEnum.ERROR_GET_SELECTED_ZONE;
    }

    // populate selected zone
    PrayerTimeZone selectedZone = getSelectedZoneReturnValue.item2;
    if (selectedZone == null) {
      if (DatabaseItemPrayerZone().setSelectedZone(await DatabaseHelper.getInstance.database, 'SGR01') !=
          ErrorStatusEnum.OK) {
        return ErrorStatusEnum.ERROR_SET_SELECTED_ZONE;
      }
      getSelectedZoneReturnValue =
          await DatabaseItemPrayerZone().getSelectedZone(await DatabaseHelper.getInstance.database);
      if (getSelectedZoneReturnValue.item1 != ErrorStatusEnum.OK || getSelectedZoneReturnValue.item2 == null) {
        return ErrorStatusEnum.ERROR_GET_SELECTED_ZONE;
      }
      selectedZone = getSelectedZoneReturnValue.item2;
    }

    // get selected zone data
    var getSelectedZoneListData = await DatabaseItemPrayerTime().getList(await DatabaseHelper.getInstance.database);
    if (getSelectedZoneReturnValue.item1 != ErrorStatusEnum.OK) {
      return ErrorStatusEnum.ERROR_GET_SELECTED_ZONE_DATA_LIST;
    }

    // populate data
    List<PrayerTimeData> dataList = getSelectedZoneListData.item2;
    if (dataList.isEmpty) {
      // fetch data
      var getZoneDataReturnValue = await PrayerTimeUtil.getZoneData('year', selectedZone.code);
      if (getZoneDataReturnValue.item1 != ErrorStatusEnum.OK || getZoneDataReturnValue.item2.isEmpty) {
        return ErrorStatusEnum.ERROR_RETRIEVE_ZONE_DATA;
      }
      // add data into database
      getZoneDataReturnValue.item2.forEach((item) async {
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
    }

    // get current selected zone data
    var getSelectedZoneDataToday =
        await DatabaseItemPrayerTime().getPrayerDataFromDate(await DatabaseHelper.getInstance.database, DateTime.now());
    if (getSelectedZoneReturnValue.item1 != ErrorStatusEnum.OK || getSelectedZoneDataToday.item2 == null) {
      return ErrorStatusEnum.ERROR_GET_SELECTED_ZONE_DATA;
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
