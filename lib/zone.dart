import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuple/tuple.dart';

import 'package:minaret/logic/common.dart';
import 'package:minaret/logic/prayer_time_database.dart';
import 'package:minaret/logic/prayer_time_database_zone.dart';
import 'package:minaret/logic/prayer_time_util.dart';
import 'package:minaret/model/prayer_time_zone.dart';
import 'package:minaret/widget/appbar.dart';
import 'package:minaret/widget/scaffold.dart';
import 'package:minaret/widget/text_title_big.dart';

class ZonePage extends StatefulWidget {
  // constructor argument
  final bool isFirstTime;
  ZonePage({Key key, this.isFirstTime: false}) : super(key: key);
  // create state
  @override
  State<StatefulWidget> createState() {
    return ZonePageState();
  }
}

class ZonePageState extends State<ZonePage> {
  // setting key and parameter
  final GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();

  // build
  @override
  Widget build(BuildContext context) {
    // return scaffold
    return buildScaffold(
      buildAppBar(
        context,
        !widget.isFirstTime,
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
            buildCardList(),
          ],
        ),
      ),
      _scaffold,
    );
  }

  // build card list
  Widget buildCardList() {
    return FutureBuilder(
      future: DatabaseHelper.getInstance.database.then((onValue) => DatabaseItemPrayerZone().getList(onValue)),
      builder: (BuildContext context, AsyncSnapshot<Tuple2<ErrorStatusEnum, List<PrayerTimeZone>>> snapshot) {
        if (snapshot.hasData) {
          return buildListView(snapshot);
        }
        return Text('Loading ..');
      },
    );
  }

  // build listview
  Widget buildListView(AsyncSnapshot<Tuple2<ErrorStatusEnum, List<PrayerTimeZone>>> snapshot) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int position) {
          return buildCard(
            snapshot.data.item2.elementAt(position).state + ' - ' + snapshot.data.item2.elementAt(position).code,
            snapshot.data.item2.elementAt(position).region,
            snapshot.data.item2.elementAt(position).isSelected == 1,
            () async {
              // send haptic feedback on select
              Feedback.forTap(context);
              // set selected zone (required to use blocking due to 'no feedback on select' experience)
              String code = snapshot.data.item2.elementAt(position).code;
              PrayerTimeUtil.setSelectedZone(code).then(
                (onValue) {
                  if (onValue == ErrorStatusEnum.OK) {
                    (widget.isFirstTime)
                        // back to check
                        ? Navigator.pushReplacementNamed(context, '/check')
                        // refresh state
                        : setState(() {});
                  } else {
                    // set snackbar
                    _scaffold.currentState.showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 2),
                        content: Text('Failed to get selected zone prayer time data'),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
        itemCount: snapshot.data.item2.length,
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
