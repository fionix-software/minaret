import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minaret/_reusable/logic/intermediate.dart';
import 'package:minaret/_reusable/screen/intermediate.dart';
import 'package:minaret/bloc/calendar_bloc.dart';
import 'package:minaret/form_calendar.dart';

class CalendarController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return CalendarBloc();
      },
      child: CalendarControllerBloc(),
    );
  }
}

class CalendarControllerBloc extends StatefulWidget {
  @override
  _CalendarControllerBlocState createState() => _CalendarControllerBlocState();
}

class _CalendarControllerBlocState extends State<CalendarControllerBloc> {
  @override
  void initState() {
    BlocProvider.of<CalendarBloc>(context).add(CalendarLoad());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (BuildContext context, CalendarState state) {
        if (state is CalendarLoadSuccess) {
          return CalendarScreen(state.startDate, state.endDate);
        } else if (state is CalendarLoadFailed) {
          return IntermediateScreen(intermediateSettingsMap[IntermediateEnum.ERROR], retryCallback, state.message);
        }
        return IntermediateScreen(intermediateSettingsMap[IntermediateEnum.LOADING]);
      },
    );
  }

  void retryCallback() {
    CalendarEvent lastEvent = BlocProvider.of<CalendarBloc>(context).lastEvent;
    if (lastEvent != null) {
      BlocProvider.of<CalendarBloc>(context).add(lastEvent);
    }
  }
}
