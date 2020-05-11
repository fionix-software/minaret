import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:minaret/database/db_data.dart';
import 'package:minaret/logic/common.dart';
import 'package:minaret/logic/repository.dart';
import 'package:minaret/model/pt_data.dart';
import 'package:minaret/model/pt_zone.dart';
part 'prayer_zone_event.dart';
part 'prayer_zone_state.dart';

class PrayerZoneBloc extends Bloc<PrayerZoneEvent, PrayerZoneState> {
  PrayerZoneEvent lastEvent;
  ESolatRepository repo = ESolatRepository();

  @override
  PrayerZoneState get initialState => PrayerZoneLoading();

  @override
  Stream<PrayerZoneState> mapEventToState(PrayerZoneEvent event) async* {
    // loading
    lastEvent = event;
    yield PrayerZoneLoading();
    // load prayer zone data
    if (event is PrayerZoneLoad) {
      // retrieve zone list
      List<PrayerTimeZone> retrieveZoneReturn = await ESolatRepository.retrieveZoneList();
      if (retrieveZoneReturn == null) {
        yield PrayerZoneFailed(errorStatusEnumMap[ErrorStatusEnum.ERROR_RETRIEVE_ZONE_LIST]);
        return;
      }
      // prayer zone load sucess
      yield PrayerZoneLoadSuccess(retrieveZoneReturn);
      return;
    } else if (event is PrayerZoneSet) {
      // retrieve zone data
      List<PrayerTimeData> retrieveZoneDataReturn = await ESolatRepository.retrieveZoneDataList(event.zone);
      if (retrieveZoneDataReturn == null) {
        yield PrayerZoneFailed(errorStatusEnumMap[ErrorStatusEnum.ERROR_RETRIEVE_ZONE_DATA]);
        return;
      }
      // save zone data
      DatabaseItemPrayerTime databaseItemPrayerTime = DatabaseItemPrayerTime();
      for (PrayerTimeData data in retrieveZoneDataReturn) {
        databaseItemPrayerTime.insert(data.toMap());
      }
      // prayer zone set success
      yield PrayerZoneSetSuccess();
      return;
    }
  }
}
