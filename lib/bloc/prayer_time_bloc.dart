import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:minaret/database/db_data.dart';
import 'package:minaret/logic/common.dart';
import 'package:minaret/logic/repository.dart';
import 'package:minaret/model/pt_data.dart';
import 'package:minaret/model/pt_zone.dart';

part 'prayer_time_event.dart';
part 'prayer_time_state.dart';

class PrayerTimeBloc extends Bloc<PrayerTimeEvent, PrayerTimeState> {
  PrayerTimeEvent lastEvent;
  ESolatRepository repo = ESolatRepository();

  @override
  PrayerTimeState get initialState => PrayerTimeLoading();

  @override
  Stream<PrayerTimeState> mapEventToState(PrayerTimeEvent event) async* {
    lastEvent = event;
    yield PrayerTimeLoading();
    // load prayer time data
    if (event is PrayerTimeLoad) {
      // get prayer time data from database
      DatabaseItemPrayerTime databaseItemPrayerTime = DatabaseItemPrayerTime();
      DateTime selectedDate = event.loadDate == null ? DateTime.now() : event.loadDate;
      PrayerTimeData prayerTimeData = await databaseItemPrayerTime.getPrayerTimeData(selectedDate);
      if (prayerTimeData == null) {
        yield PrayerTimeNotInitialized();
        return;
      }
      // prayer time load success
      yield PrayerTimeSuccess(prayerTimeData);
      return;
    } else if (event is PrayerTimeRefresh) {
      yield PrayerTimeRetrieving();
      // get prayer time data from database
      DatabaseItemPrayerTime databaseItemPrayerTime = DatabaseItemPrayerTime();
      PrayerTimeZone prayerTimeZone = await databaseItemPrayerTime.getPrayerTimeZone();
      if (prayerTimeZone == null) {
        yield PrayerTimeNotInitialized();
        return;
      }
      List<PrayerTimeData> retrieveZoneDataReturn = await ESolatRepository.retrieveZoneDataList(prayerTimeZone);
      if (retrieveZoneDataReturn == null || retrieveZoneDataReturn.isEmpty) {
        yield PrayerTimeFailed(errorStatusEnumMap[ErrorStatusEnum.ERROR_RETRIEVE_ZONE_DATA]);
        return;
      }
      for (PrayerTimeData data in retrieveZoneDataReturn) {
        await databaseItemPrayerTime.insert(data.toMap());
      }
      // get prayer time data from database
      PrayerTimeData prayerTimeDataUpdated = await databaseItemPrayerTime.getPrayerTimeData(DateTime.now());
      yield PrayerTimeSuccess(prayerTimeDataUpdated);
      return;
    }
  }
}
