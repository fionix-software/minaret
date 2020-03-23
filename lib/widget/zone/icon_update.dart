import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minaret/bloc/prayer_zone_bloc.dart';
import 'package:minaret/logic/common.dart';

Widget iconUpdate(BuildContext context) {
  return IconButton(
    icon: Icon(
      FontAwesomeIcons.syncAlt,
      color: appThemeColor,
    ),
    onPressed: () async {
      BlocProvider.of<PrayerZoneBloc>(context).add(PrayerZoneRefresh());
    },
  );
}
