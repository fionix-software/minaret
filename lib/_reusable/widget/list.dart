import 'package:flutter/material.dart';

Widget buildCard(BuildContext context, String title, String subtitle, IconData iconData, bool isHighlighted, void Function() callbackFunction) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 5),
    child: ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: callbackFunction != null
          ? GestureDetector(
              onTap: callbackFunction,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  iconData,
                  size: 15,
                  color: (isHighlighted) ? Theme.of(context).primaryColor : Theme.of(context).iconTheme.color,
                ),
              ),
            )
          : null,
      contentPadding: EdgeInsets.zero,
    ),
  );
}
