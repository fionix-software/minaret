import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minaret/widget/appbar.dart';
import 'package:minaret/widget/scaffold.dart';
import 'package:minaret/widget/separator.dart';
import 'package:minaret/widget/title.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildScaffold(
      buildAppBar(
        context,
        true,
        null,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitle(context, 'Settings'),
          Text('Customize behavior'),
          buildSpaceSeparator(),
          buildListView(context),
        ],
      ),
      null,
    );
  }

  // build listview
  Widget buildListView(BuildContext context) {
    return Expanded(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text('24-Hour format'),
            subtitle: Text('Change prayer time in 24 hour format'),
            trailing: IconButton(
              padding: EdgeInsets.all(5.0),
              icon: Icon(
                FontAwesomeIcons.toggleOff,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                // TODO:
              },
            ),
            contentPadding: EdgeInsets.zero,
          )
        ],
      ),
    );
  }
}
