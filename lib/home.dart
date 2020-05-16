import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minaret/_reusable/widget/appbar.dart';
import 'package:minaret/_reusable/widget/icon.dart';
import 'package:minaret/_reusable/widget/scaffold.dart';
import 'package:minaret/_reusable/widget/separator.dart';
import 'package:minaret/_reusable/widget/title.dart';
import 'package:minaret/bloc/prayer_time_bloc.dart';
import 'package:minaret/logic/settings.dart';
import 'package:minaret/logic/util.dart';
import 'package:minaret/model/pt_data.dart';

class HomeScreen extends StatefulWidget {
  final PrayerTimeData data;
  HomeScreen(this.data);

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
          buildIcon(context, FontAwesomeIcons.mapMarker, () {
            Navigator.pushNamed(context, '/zone').then((value) {
              setState(() {
                BlocProvider.of<PrayerTimeBloc>(context).add(PrayerTimeLoad());
              });
            });
          }),
          buildIcon(
            context,
            FontAwesomeIcons.syncAlt,
            () async {
              BlocProvider.of<PrayerTimeBloc>(context).add(PrayerTimeRefresh());
            },
          ),
          buildIcon(context, FontAwesomeIcons.calendarDay, () {
            Navigator.pushNamed(context, '/calendar').then((value) {
              setState(() {
                // only if return value from calendar is in DateTime
                if (value is DateTime) {
                  BlocProvider.of<PrayerTimeBloc>(context).add(PrayerTimeLoad(value));
                }
              });
            });
          }),
          buildIcon(
            context,
            FontAwesomeIcons.cog,
            () {
              Navigator.pushNamed(context, '/settings').then((value) {
                setState(() {});
              });
            },
          ),
          buildIcon(
            context,
            FontAwesomeIcons.info,
            () {
              Navigator.pushNamed(context, '/about');
            },
          )
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildCardHeader(
            context,
            widget.data.zoneState,
            widget.data.zoneCode,
            widget.data.date,
            widget.data.hijri,
            widget.data.zoneRegion,
          ),
          buildTimeCard(context, 'Imsak', widget.data.imsak),
          buildTimeCard(context, 'Subuh', widget.data.fajr),
          buildTimeCard(context, 'Syuruk', widget.data.syuruk),
          buildTimeCard(context, 'Zohor', widget.data.dhuhr),
          buildTimeCard(context, 'Asar', widget.data.asr),
          buildTimeCard(context, 'Maghrib', widget.data.maghrib),
          buildTimeCard(context, 'Isyak', widget.data.isha),
        ],
      ),
      null,
    );
  }

  Widget buildCardHeader(BuildContext context, String state, String code, String date, String dateHijri, String region) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildTitle(context, date),
          Text(dateHijri),
          buildSpaceSeparator(),
          buildTitle(context, state + " - " + code),
          Text(region),
          buildSpaceSeparator(),
        ],
      ),
    );
  }

  Widget buildTimeCard(BuildContext context, String salatTime, String time) {
    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        margin: EdgeInsets.only(bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(salatTime),
            FutureBuilder<bool>(
              future: sharedPrefIs12HourFormat(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData) {
                  String displayTime = time;
                  if (snapshot.data) {
                    displayTime = convert12HourTimeFormat(time);
                  }
                  return buildTimeText(context, displayTime);
                }
                return buildTimeText(context, 'n/a');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTimeText(BuildContext context, String time) {
    return Text(
      time,
      style: TextStyle(
        fontSize: Theme.of(context).textTheme.headline6.fontSize,
      ),
    );
  }
}
