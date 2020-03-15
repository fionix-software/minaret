import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minaret/bloc/prayer_zone_bloc.dart';
import 'package:minaret/logic/common.dart';
import 'package:minaret/logic/progress.dart';
import 'package:minaret/screen/progress.dart';
import 'package:minaret/screen/zone.dart';

// Page
class ZonePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ZonePageState();
  }
}

class ZonePageState extends State<ZonePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return PrayerZoneBloc();
      },
      child: ZonePageContent(),
    );
  }
}

// Content
class ZonePageContent extends StatefulWidget {
  @override
  _ZonePageContentState createState() => _ZonePageContentState();
}

class _ZonePageContentState extends State<ZonePageContent> {
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
          // zone loading
          if (state is PrayerZoneError) {
            return ProgressScreen(getProgressData(ProgressEnum.PROGRESS_ERROR, state.errorMessage), retryCallback);
          } else if (state is PrayerZoneLoadSuccess) {
            return ZoneScreen(state.zone);
          } else if (state is PrayerZoneLoading) {
            return ProgressScreen(getProgressData(ProgressEnum.PROGRESS_LOADING));
          } else {
            return ProgressScreen(getProgressData(ProgressEnum.PROGRESS_ERROR, errorStatusEnumMap[ErrorStatusEnum.ERROR_UNKNOWN_STATE]), retryCallback);
          }
        },
      ),
    );
  }

  void retryCallback() {
    BlocProvider.of<PrayerZoneBloc>(context).add(PrayerZoneLoad());
  }
}
