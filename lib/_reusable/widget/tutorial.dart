import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'separator.dart';
import 'title.dart';

ContentTarget buildContentTarget(BuildContext context, String titleStr, String subtitleStr) {
  return ContentTarget(
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
  );
}

TargetFocus buildTargetFocus(GlobalKey componentKey, List<ContentTarget> contentTargetList) {
  return TargetFocus(
    keyTarget: componentKey,
    contents: contentTargetList,
  );
}
