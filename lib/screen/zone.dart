import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minaret/bloc/prayer_zone_bloc.dart';
import 'package:minaret/logic/common.dart';
import 'package:minaret/model/pt_zone.dart';
import 'package:minaret/widget/appbar.dart';
import 'package:minaret/widget/scaffold.dart';
import 'package:minaret/widget/text_title_big.dart';

class ZoneScreen extends StatefulWidget {
  final List<PrayerTimeZone> zoneList;
  ZoneScreen(this.zoneList);

  @override
  _ZoneScreenState createState() => _ZoneScreenState();
}

class _ZoneScreenState extends State<ZoneScreen> {
  // setting key and parameter
  final GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return buildScaffold(
      buildAppBar(
        context,
        false,
        null,
      ),
      SizedBox.expand(
        child: Column(
          children: [
            buildTextTitleBig('Zone'),
            Text('Pick your zone by state\'s district.'),
            Text(
              'Touch the star to select the zone.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            buildListView(context, widget.zoneList),
          ],
        ),
      ),
      _scaffold,
    );
  }

  // build listview
  Widget buildListView(BuildContext context, List<PrayerTimeZone> list) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int position) {
          return buildCard(
            list.elementAt(position).state + ' - ' + list.elementAt(position).code,
            list.elementAt(position).region,
            list.elementAt(position).isSelected == 1,
            () async {
              // send haptic feedback on select
              Feedback.forTap(context);
              // set selected zone
              BlocProvider.of<PrayerZoneBloc>(context).add(PrayerZoneSet(list.elementAt(position).code));
            },
          );
        },
        itemCount: list.length,
      ),
    );
  }

  // build card
  Widget buildCard(String zoneStr, String descriptionStr, bool isHighlighted, Function onTapIconFunction) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: ListTile(
        title: Text(zoneStr),
        subtitle: Text(descriptionStr),
        trailing: GestureDetector(
          onTap: onTapIconFunction,
          child: Icon(
            FontAwesomeIcons.solidStar,
            color: (isHighlighted) ? appThemeColor : Colors.black,
          ),
        ),
      ),
    );
  }
}
