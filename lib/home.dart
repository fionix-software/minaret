import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minaret/logic/common.dart';
import 'package:minaret/logic/progress.dart';
import 'package:minaret/screen/home.dart';
import 'package:minaret/screen/progress.dart';
import 'package:minaret/bloc/prayer_time_bloc.dart';

// page
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return PrayerTimeBloc();
      },
      child: HomePageContent(),
    );
  }
}

// content
class HomePageContent extends StatefulWidget {
  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  @override
  void initState() {
    BlocProvider.of<PrayerTimeBloc>(context).add(PrayerTimeLoad());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PrayerTimeBloc, PrayerTimeState>(
      listener: (BuildContext context, PrayerTimeState state) {
        if (state is PrayerTimeDataNotInitialized) {
          Navigator.pushReplacementNamed(context, '/zone');
        }
      },
      child: BlocBuilder<PrayerTimeBloc, PrayerTimeState>(
        builder: (BuildContext context, PrayerTimeState state) {
          if (state is PrayerTimeError) {
            return ProgressScreen(getProgressData(ProgressEnum.PROGRESS_ERROR, state.errorMessage), errorCallback);
          } else if (state is PrayerTimeLoadSuccess) {
            return HomeScreen(state.zone, state.zoneData);
          } else if (state is PrayerTimeRetrieving) {
            return ProgressScreen(getProgressData(ProgressEnum.PROGRESS_RETRIEVING));
          } else if (state is PrayerTimeLoading) {
            return ProgressScreen(getProgressData(ProgressEnum.PROGRESS_LOADING));
          } else {
            return ProgressScreen(getProgressData(ProgressEnum.PROGRESS_ERROR, errorStatusEnumMap[ErrorStatusEnum.ERROR_UNKNOWN_STATE]), errorCallback);
          }
        },
      ),
    );
  }

  void errorCallback() {
    BlocProvider.of<PrayerTimeBloc>(context).add(PrayerTimeLoad());
  }
}
