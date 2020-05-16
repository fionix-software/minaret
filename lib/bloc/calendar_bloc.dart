import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:minaret/database/db_data.dart';
import 'package:minaret/logic/common.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarEvent lastEvent;
  
  @override
  CalendarState get initialState => CalendarLoading();

  @override
  Stream<CalendarState> mapEventToState(CalendarEvent event) async* {
    yield CalendarLoading();
    lastEvent = event;
    if (event is CalendarLoad) {
      // get prayer data date list
      DatabaseItemPrayerTime prayerTime = DatabaseItemPrayerTime();
      List<String> dateList = await prayerTime.getDateList();
      if (dateList == null || dateList.isEmpty) {
        yield CalendarLoadFailed(errorStatusEnumMap[ErrorStatusEnum.ERROR_RETRIEVE_ZONE_DATA]);
        return;
      }
      // converting date in string to datetime
      List<DateTime> dateTimeList = List<DateTime>();
      for (String dateStr in dateList) {
        dateTimeList.add(DateFormat('dd MMMM yyyy').parse(dateStr));
      }
      // sort
      dateTimeList.sort((DateTime d1, DateTime d2) {
        return d1.compareTo(d2);
      });
      // get start and end date
      DateTime startDate = dateTimeList.first;
      DateTime endDate = dateTimeList.last;
      yield CalendarLoadSuccess(startDate, endDate);
      return;
    }
  }
}
