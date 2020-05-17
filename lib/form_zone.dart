import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minaret/_reusable/widget/appbar.dart';
import 'package:minaret/_reusable/widget/list.dart';
import 'package:minaret/_reusable/widget/scaffold.dart';
import 'package:minaret/bloc/prayer_zone_bloc.dart';
import 'package:minaret/model/pt_zone.dart';

class ZoneScreen extends StatelessWidget {
  final bool isFirstTime;
  final List<PrayerTimeZone> zoneList;
  ZoneScreen(this.isFirstTime, this.zoneList);

  Widget build(BuildContext context) {
    return buildScaffold(
      buildAppBar(
        context,
        !isFirstTime,
      ),
      buildListView(
        context,
        'Please select your zone by your state\'s district.',
        'Click on the icon on the right to select and proceed',
        zoneList.isEmpty,
        ListView.builder(
          itemBuilder: (BuildContext context, int position) {
            return buildCard(
              context,
              zoneList.elementAt(position).zoneState + ' - ' + zoneList.elementAt(position).zoneCode,
              zoneList.elementAt(position).zoneRegion,
              FontAwesomeIcons.chevronRight,
              false,
              () async {
                BlocProvider.of<PrayerZoneBloc>(context).add(PrayerZoneSet(zoneList.elementAt(position)));
              },
            );
          },
          itemCount: zoneList.length,
        ),
        'Retrieved zone list is empty!',
      ),
    );
  }
}
