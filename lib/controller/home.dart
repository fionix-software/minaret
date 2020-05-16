import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minaret/_reusable/logic/intermediate.dart';
import 'package:minaret/_reusable/screen/intermediate.dart';
import 'package:minaret/home.dart';
import 'package:minaret/bloc/prayer_time_bloc.dart';

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return PrayerTimeBloc();
      },
      child: HomeControllerBloc(),
    );
  }
}

class HomeControllerBloc extends StatefulWidget {
  @override
  _HomeControllerBlocState createState() => _HomeControllerBlocState();
}

class _HomeControllerBlocState extends State<HomeControllerBloc> {
  @override
  void initState() {
    BlocProvider.of<PrayerTimeBloc>(context).add(PrayerTimeLoad());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PrayerTimeBloc, PrayerTimeState>(
      listener: (BuildContext context, PrayerTimeState state) {
        if (state is PrayerTimeNotInitialized) {
          Navigator.pushNamed(context, '/zone').then((value) {
            setState(() {
              BlocProvider.of<PrayerTimeBloc>(context).add(PrayerTimeLoad());
            });
          });
        }
      },
      child: BlocBuilder<PrayerTimeBloc, PrayerTimeState>(
        builder: (BuildContext context, PrayerTimeState state) {
          if (state is PrayerTimeFailed) {
            return IntermediateScreen(intermediateSettingsMap[IntermediateEnum.ERROR], retryCallback, state.message);
          } else if (state is PrayerTimeSuccess) {
            return HomeScreen(state.zoneData);
          } else if (state is PrayerTimeRetrieving) {
            return IntermediateScreen(intermediateSettingsMap[IntermediateEnum.RETRIEVING], null);
          }
          return IntermediateScreen(intermediateSettingsMap[IntermediateEnum.LOADING], null);
        },
      ),
    );
  }

  void retryCallback() {
    PrayerTimeEvent lastEvent = BlocProvider.of<PrayerTimeBloc>(context).lastEvent;
    if (lastEvent != null) {
      BlocProvider.of<PrayerTimeBloc>(context).add(lastEvent);
    }
  }
}
