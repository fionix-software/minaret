import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minaret/bloc/prayer_zone_bloc.dart';
import 'package:minaret/model/pt_zone.dart';
import 'package:minaret/widget/appbar.dart';
import 'package:minaret/widget/scaffold.dart';
import 'package:minaret/widget/separator.dart';
import 'package:minaret/widget/title.dart';
import 'package:minaret/widget/zone/icon_update.dart';

class ZoneScreen extends StatefulWidget {
  final List<PrayerTimeZone> zoneList;
  ZoneScreen(this.zoneList);

  @override
  _ZoneScreenState createState() => _ZoneScreenState();
}

class _ZoneScreenState extends State<ZoneScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PrayerTimeZone>(
      future: BlocProvider.of<PrayerZoneBloc>(context).repo.getSelectedZone(),
      builder: (BuildContext context, AsyncSnapshot<PrayerTimeZone> snapshot) {
        return buildScaffold(
          buildAppBar(
            context,
            snapshot.data != null,
            [
              iconUpdate(context),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTitle(context, 'Pick your zone by your state\'s district.'),
              Text('Touch on star to select'),
              buildSpaceSeparator(),
              buildListView(context, widget.zoneList),
            ],
          ),
          null,
        );
      },
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
            list.elementAt(position).isSelected != 0,
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
      padding: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(zoneStr),
        subtitle: Text(descriptionStr),
        trailing: GestureDetector(
          onTap: onTapIconFunction,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Icon(
              FontAwesomeIcons.solidStar,
              color: (isHighlighted) ? Theme.of(context).primaryColor : Theme.of(context).iconTheme.color,
            ),
          ),
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
