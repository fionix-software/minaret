import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minaret/_reusable/widget/appbar.dart';
import 'package:minaret/_reusable/widget/list.dart';
import 'package:minaret/_reusable/widget/scaffold.dart';
import 'package:minaret/_reusable/widget/separator.dart';
import 'package:minaret/_reusable/widget/title.dart';
import 'package:minaret/bloc/prayer_zone_bloc.dart';
import 'package:minaret/model/pt_zone.dart';

class ZoneScreen extends StatefulWidget {
  final bool isFirstTime;
  final List<PrayerTimeZone> zoneList;
  ZoneScreen(this.isFirstTime, this.zoneList);

  @override
  _ZoneScreenState createState() => _ZoneScreenState();
}

class _ZoneScreenState extends State<ZoneScreen> {
  @override
  Widget build(BuildContext context) {
    return buildScaffold(
      buildAppBar(
        context,
        !widget.isFirstTime,
        null,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitle(context, 'Please select your zone by your state\'s district.'),
          Text('Click on the icon on the right to select and proceed'),
          buildSpaceSeparator(),
          buildListView(context, widget.zoneList),
        ],
      ),
      null,
    );
  }

  Widget buildListView(BuildContext context, List<PrayerTimeZone> list) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int position) {
          return buildCard(
            context,
            list.elementAt(position).zoneState + ' - ' + list.elementAt(position).zoneCode,
            list.elementAt(position).zoneRegion,
            FontAwesomeIcons.chevronRight,
            false,
            () async {
              BlocProvider.of<PrayerZoneBloc>(context).add(PrayerZoneSet(list.elementAt(position)));
            },
          );
        },
        itemCount: list.length,
      ),
    );
  }
}
