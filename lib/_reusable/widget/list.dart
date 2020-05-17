import 'package:flutter/material.dart';

import 'separator.dart';
import 'title.dart';

Widget buildListView(BuildContext context, String title, String subtitle, bool isListEmpty, ListView listView, [String listEmptyStr]) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildTitle(context, title),
      Text(subtitle),
      buildSpaceSeparator(),
      !isListEmpty
          ? Expanded(
              child: listView,
            )
          : Text(listEmptyStr),
    ],
  );
}

Widget buildCard(BuildContext context, String title, String subtitle, IconData iconData, bool isHighlighted, void Function() callbackFunction) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 5),
    child: ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: callbackFunction != null
          ? IconButton(
              icon: Icon(
                iconData,
                size: 15,
                color: (isHighlighted) ? Theme.of(context).primaryColor : Theme.of(context).iconTheme.color,
              ),
              onPressed: callbackFunction,
            )
          : null,
      contentPadding: EdgeInsets.zero,
    ),
  );
}
