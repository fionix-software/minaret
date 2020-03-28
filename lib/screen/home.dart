import 'package:flutter/material.dart';
import 'package:minaret/model/pt_data.dart';
import 'package:minaret/model/pt_zone.dart';
import 'package:minaret/widget/appbar.dart';
import 'package:minaret/widget/home/card_time.dart';
import 'package:minaret/widget/home/card_header.dart';
import 'package:minaret/widget/home/icon_about.dart';
import 'package:minaret/widget/home/icon_update.dart';
import 'package:minaret/widget/home/icon_zone.dart';
import 'package:minaret/widget/scaffold.dart';

class HomeScreen extends StatefulWidget {
  final PrayerTimeZone zone;
  final PrayerTimeData zoneData;
  HomeScreen(this.zone, this.zoneData);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return buildScaffold(
      buildAppBar(
        context,
        false,
        [
          iconZone(context),
          iconUpdate(context),
          iconAbout(context),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildCardHeader(
            context,
            widget.zone.state,
            widget.zone.code,
            widget.zoneData.date,
            widget.zoneData.hijri,
            widget.zone.region,
          ),
          buildTimeCard(context, 'Imsak', widget.zoneData.imsak),
          buildTimeCard(context, 'Subuh', widget.zoneData.fajr),
          buildTimeCard(context, 'Syuruk', widget.zoneData.syuruk),
          buildTimeCard(context, 'Zohor', widget.zoneData.dhuhr),
          buildTimeCard(context, 'Asar', widget.zoneData.asr),
          buildTimeCard(context, 'Maghrib', widget.zoneData.maghrib),
          buildTimeCard(context, 'Isyak', widget.zoneData.isha),
        ],
      ),
      null,
    );
  }
}
