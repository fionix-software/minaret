import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minaret/_reusable/widget/appbar.dart';
import 'package:minaret/_reusable/widget/icon.dart';
import 'package:minaret/_reusable/widget/scaffold.dart';
import 'package:minaret/_reusable/widget/separator.dart';
import 'package:minaret/_reusable/widget/title.dart';
import 'package:minaret/bloc/prayer_time_bloc.dart';
import 'package:minaret/logic/sharedpref.dart';
import 'package:minaret/logic/util.dart';
import 'package:minaret/model/pt_data.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HomeScreen extends StatefulWidget {
  final PrayerTimeData data;
  HomeScreen(this.data);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TargetFocus> tutorialFocus = List<TargetFocus>();

  // list of key for tutorial
  GlobalKey zoneIconKey = GlobalKey();
  GlobalKey refreshIconKey = GlobalKey();
  GlobalKey calendarIconKey = GlobalKey();
  GlobalKey settingsIconKey = GlobalKey();
  GlobalKey aboutIconKey = GlobalKey();

  // calendar library require init state
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // display tutorial view if not complete
      if (!(await sharedPrefTutorialHomeScreenIsComplete())) {
        tutorialView();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildScaffold(
      buildAppBar(
        context,
        false,
        [
          buildIcon(
            context,
            FontAwesomeIcons.mapMarker,
            () {
              Navigator.pushNamed(context, '/zone').then((value) {
                setState(() {
                  BlocProvider.of<PrayerTimeBloc>(context).add(PrayerTimeLoad());
                });
              });
            },
            zoneIconKey,
          ),
          buildIcon(
            context,
            FontAwesomeIcons.syncAlt,
            () async {
              BlocProvider.of<PrayerTimeBloc>(context).add(PrayerTimeRefresh());
            },
            refreshIconKey,
          ),
          buildIcon(
            context,
            FontAwesomeIcons.calendarDay,
            () {
              Navigator.pushNamed(context, '/calendar').then((value) {
                setState(() {
                  // only if return value from calendar is in DateTime
                  if (value is DateTime) {
                    BlocProvider.of<PrayerTimeBloc>(context).add(PrayerTimeLoad(value));
                  }
                });
              });
            },
            calendarIconKey,
          ),
          buildIcon(
            context,
            FontAwesomeIcons.cog,
            () {
              Navigator.pushNamed(context, '/settings').then((value) {
                setState(() {});
              });
            },
            settingsIconKey,
          ),
          buildIcon(
            context,
            FontAwesomeIcons.info,
            () {
              Navigator.pushNamed(context, '/about');
            },
            aboutIconKey,
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

  TargetFocus buildTargetFocus(GlobalKey componentKey, String titleStr, String subtitleStr) {
    return TargetFocus(
      keyTarget: componentKey,
      contents: [
        ContentTarget(
          align: AlignContent.bottom,
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildTitle(context, titleStr),
                Text(subtitleStr),
                buildSpaceSeparator(),
                Text('Touch screen continue.'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void tutorialView() {
    tutorialFocus.add(buildTargetFocus(
      zoneIconKey,
      'Set Zone',
      'You can set your zone by your state\'s district.',
    ));
    tutorialFocus.add(buildTargetFocus(
      refreshIconKey,
      'Refresh Data',
      'It will update prayer time data by re-retrieve prayer time data from JAKIM e-Solat portal.',
    ));
    tutorialFocus.add(buildTargetFocus(
      calendarIconKey,
      'Set Date',
      'You can select certain date to view the date\'s prayer time.',
    ));
    tutorialFocus.add(buildTargetFocus(
      settingsIconKey,
      'Settings',
      'You can customize application behavior. You can also reset the tutorial, so it will be displayed again. This tutorial is first-time only.',
    ));
    tutorialFocus.add(buildTargetFocus(
      aboutIconKey,
      'About',
      'You can see application information and useful links.',
    ));
    TutorialCoachMark(
      context,
      targets: tutorialFocus,
      clickSkip: () async {
        await sharedPrefTutorialHomeScreenSetComplete();
      },
      finish: () async {
        await sharedPrefTutorialHomeScreenSetComplete();
      },
    )..show();
  }
}
