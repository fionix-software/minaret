import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minaret/_reusable/logic/intermediate.dart';
import 'package:minaret/_reusable/screen/intermediate.dart';
import 'package:minaret/bloc/prayer_zone_bloc.dart';
import 'package:minaret/form_zone.dart';

class ZoneController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ZoneControllerState();
  }
}

class ZoneControllerState extends State<ZoneController> {
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
    BlocProvider.of<PrayerZoneBloc>(context).add(PrayerZoneLoad());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PrayerZoneBloc, PrayerZoneState>(
      listener: (BuildContext context, PrayerZoneState state) {
        if (state is PrayerZoneSetSuccess) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      child: BlocBuilder<PrayerZoneBloc, PrayerZoneState>(
        builder: (BuildContext context, PrayerZoneState state) {
          if (state is PrayerZoneLoadSuccess) {
            return ZoneScreen(state.zone);
          } else if (state is PrayerZoneFailed) {
            return IntermediateScreen(intermediateSettingsMap[IntermediateEnum.ERROR], retryCallback, state.message);
          }
          return IntermediateScreen(intermediateSettingsMap[IntermediateEnum.LOADING], null);
        },
      ),
    );
  }

  void retryCallback() {
    PrayerZoneEvent lastEvent = BlocProvider.of<PrayerZoneBloc>(context).lastEvent;
    if (lastEvent != null) {
      BlocProvider.of<PrayerZoneBloc>(context).add(lastEvent);
    }
  }
}
