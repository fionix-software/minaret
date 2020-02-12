import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuple/tuple.dart';

import 'package:waktuku/logic/common.dart';
import 'package:waktuku/logic/main_database.dart';
import 'package:waktuku/logic/prayer_time_data_database.dart';
import 'package:waktuku/logic/prayer_time_util.dart';
import 'package:waktuku/logic/prayer_time_zone_database.dart';
import 'package:waktuku/model/prayer_time_zone.dart';

class ZonePage extends StatefulWidget {
  // constructor argument
  final bool firstTime;
  ZonePage({Key key, this.firstTime: false}) : super(key: key);
  // create state
  @override
  State<StatefulWidget> createState() {
    return ZonePageState();
  }
}

class ZonePageState extends State<ZonePage> {
  @override
  Widget build(BuildContext context) {
    // setting key and parameter
    final GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();
    // return scaffold
    return Scaffold(
      key: _scaffold,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: (widget.firstTime)
            ? Container()
            : IconButton(
                icon: Icon(
                  FontAwesomeIcons.arrowLeft,
                  color: appThemeColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 40,
          right: 40,
          bottom: 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Zone',
              style: TextStyle(
                fontSize: 40,
                color: appThemeColor,
              ),
            ),
            Text('Click on the zone to select.'),
            Text('Pick your zone by state\'s district.'),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
                future: getZoneList(),
                builder: (BuildContext context, AsyncSnapshot<Tuple2<ErrorStatusEnum, List<PrayerTimeZone>>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemBuilder: (BuildContext context, int position) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  _showSelectZoneConfirmation(
                                      _scaffold, widget.firstTime, snapshot.data.item2.elementAt(position).code);
                                },
                                child: Text(
                                  snapshot.data.item2.elementAt(position).code,
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: (snapshot.data.item2.elementAt(position).isSelected == 1)
                                        ? appThemeColor
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              Text(
                                snapshot.data.item2.elementAt(position).state +
                                    ' - ' +
                                    snapshot.data.item2.elementAt(position).region,
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: snapshot.data.item2.length,
                    );
                  }
                  return Text('Loading');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Tuple2<ErrorStatusEnum, List<PrayerTimeZone>>> getZoneList() async {
    // get zone list
    return await DatabaseItemPrayerZone().getList(await DatabaseHelper.getInstance.database);
  }

  // exit confirmation upon exit
  void _showSelectZoneConfirmation(GlobalKey<ScaffoldState> scaffold, bool firstTime, String zone) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select zone"),
          content: Text("Are you sure to select $zone?"),
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
                prepareChangeSelectedZone(zone).then((onValue) {
                  if (onValue != ErrorStatusEnum.OK) {
                    scaffold.currentState.showSnackBar(SnackBar(
                      content: Text('Failed to change zone'),
                    ));
                  }
                }).whenComplete(() {
                  setState(() {});
                  if (firstTime) {
                    // back to check page
                    Navigator.pushReplacementNamed(context, '/check');
                  } else {
                    // back to home
                    Navigator.of(context).pop();
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<ErrorStatusEnum> prepareChangeSelectedZone(String zone) async {
    // retrieve zone data
    var retrieveSelectedZoneDataReturn = await PrayerTimeUtil.retrieveZoneData('year', zone);
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
    // set selected zone
    if (await DatabaseItemPrayerZone().setSelectedZone(await DatabaseHelper.getInstance.database, zone) !=
        ErrorStatusEnum.OK) {
      return ErrorStatusEnum.ERROR_SET_SELECTED_ZONE;
    }
    return ErrorStatusEnum.OK;
  }
}
