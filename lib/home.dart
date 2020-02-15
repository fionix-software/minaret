import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuple/tuple.dart';

import 'package:minaret/logic/common.dart';
import 'package:minaret/logic/prayer_time_util.dart';
import 'package:minaret/model/prayer_time_data.dart';
import 'package:minaret/model/prayer_time_zone.dart';
import 'package:minaret/widget/appbar.dart';
import 'package:minaret/widget/centered.dart';
import 'package:minaret/widget/scaffold.dart';
import 'package:minaret/widget/text_title_big.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return buildScaffold(
      buildAppBar(
        context,
        false,
        [
          // update icon
          IconButton(
            icon: Icon(
              FontAwesomeIcons.syncAlt,
              color: appThemeColor,
            ),
            onPressed: () async {
              // update data
              String message = "Prayer time updated";
              var updateDataReturn = await PrayerTimeUtil.updateData();
              if (updateDataReturn != ErrorStatusEnum.OK) {
                message = "Update prayer time failed";
              }
              // show snackbar
              _scaffold.currentState.showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text(message),
                ),
              );
            },
          ),
          // select zone icon
          IconButton(
            icon: Icon(
              FontAwesomeIcons.mapMarker,
              color: appThemeColor,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/zone');
            },
          ),
          // about icon
          IconButton(
            icon: Icon(
              FontAwesomeIcons.info,
              color: appThemeColor,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
          )
        ],
      ),
      buildCenteredWidget(
        [
          buildContent(),
        ],
      ),
      _scaffold,
    );
  }

  Widget buildContent() {
    return FutureBuilder(
      future: PrayerTimeUtil.getPrayerTimeData(),
      builder: (BuildContext context, AsyncSnapshot<Tuple3<PrayerTimeZone, PrayerTimeData, ErrorStatusEnum>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.item3 == ErrorStatusEnum.OK) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                buildHeader(
                  snapshot.data.item1.code,
                  snapshot.data.item2.date,
                  snapshot.data.item2.hijri,
                  snapshot.data.item1.region,
                ),
                buildTimeCard('Imsak', snapshot.data.item2.imsak),
                buildTimeCard('Subuh', snapshot.data.item2.fajr),
                buildTimeCard('Syuruk', snapshot.data.item2.syuruk),
                buildTimeCard('Zohor', snapshot.data.item2.dhuhr),
                buildTimeCard('Asar', snapshot.data.item2.asr),
                buildTimeCard('Maghrib', snapshot.data.item2.maghrib),
                buildTimeCard('Isyak', snapshot.data.item2.isha),
              ],
            );
          }
          return Text(errorStatusEnumMap[snapshot.data.item3]);
        }
        return Text('Loading');
      },
    );
  }

  Widget buildHeader(String code, String date, String dateHijri, String region) {
    return Container(
      margin: EdgeInsets.fromLTRB(40, 0, 40, 40),
      child: Column(
        children: <Widget>[
          buildTextTitleBig(code),
          Text(date),
          Text(dateHijri),
          Text(
            region,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  Widget buildTimeCard(String salatTime, String time) {
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
}
