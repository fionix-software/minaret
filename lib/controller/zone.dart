import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minaret/_reusable/logic/intermediate.dart';
import 'package:minaret/_reusable/screen/intermediate.dart';
import 'package:minaret/bloc/prayer_zone_bloc.dart';
import 'package:minaret/form_zone.dart';

class ZoneController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return PrayerZoneBloc();
      },
      child: ZoneControllerBloc(),
    );
  }
}

class ZoneControllerBloc extends StatefulWidget {
  @override
  _ZoneControllerBlocState createState() => _ZoneControllerBlocState();
}

class _ZoneControllerBlocState extends State<ZoneControllerBloc> {
  @override
  void initState() {
    BlocProvider.of<PrayerZoneBloc>(context).add(PrayerZoneRetrieve());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerZoneBloc, PrayerZoneState>(
      builder: (BuildContext context, PrayerZoneState state) {
        if (state is PrayerZoneLoadSuccess) {
          return ZoneScreen(state.isFirstTime, state.zone);
        } else if (state is PrayerZoneFailed) {
          return IntermediateScreen(intermediateSettingsMap[IntermediateEnum.ERROR], retryCallback, state.message);
        } else if (state is PrayerZoneSetSuccess) {
          return IntermediateScreen(intermediateSettingsMap[IntermediateEnum.SUCCESS], null);
        }
        return IntermediateScreen(intermediateSettingsMap[IntermediateEnum.RETRIEVING], null);
      },
    );
  }

  void retryCallback() {
    PrayerZoneEvent lastEvent = BlocProvider.of<PrayerZoneBloc>(context).lastEvent;
    if (lastEvent != null) {
      BlocProvider.of<PrayerZoneBloc>(context).add(lastEvent);
    }
  }
}
