import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:minaret/logic/common.dart';
import 'package:minaret/logic/repo_esolat.dart';
import 'package:minaret/model/pt_data.dart';
import 'package:minaret/model/pt_zone.dart';

part 'prayer_time_event.dart';
part 'prayer_time_state.dart';

class PrayerTimeBloc extends Bloc<PrayerTimeEvent, PrayerTimeState> {
  ESolatRepository repo = ESolatRepository();

  @override
  PrayerTimeState get initialState => PrayerTimeLoading();

  @override
  Stream<PrayerTimeState> mapEventToState(PrayerTimeEvent event) async* {
    // loading
    yield PrayerTimeLoading();

    // load prayer time data
    if (event is PrayerTimeLoad) {
      // get selected zone
      var getSelectedZoneReturn = await repo.getSelectedZone();
      if (getSelectedZoneReturn == null) {
        yield PrayerTimeDataNotInitialized();
        return;
      }
      // get selected zone data
      var getSelectedZoneDataReturn = await repo.getSelectedZoneData(getSelectedZoneReturn.code);
      if (getSelectedZoneDataReturn == null) {
        // retrive selected zone data
        var getRetrieveSelectedZoneDataReturn = await repo.retrieveZoneData(getSelectedZoneReturn.code);
        if (getRetrieveSelectedZoneDataReturn != ErrorStatusEnum.OK) {
          yield PrayerTimeError(errorStatusEnumMap[ErrorStatusEnum.ERROR_RETRIEVE_ZONE_DATA]);
          return;
        }
        // retry getting selected zone data
        var getSelectedZoneDataRetryReturn = await repo.getSelectedZoneData(getSelectedZoneReturn.code);
        if (getSelectedZoneDataRetryReturn == null) {
          yield PrayerTimeError(errorStatusEnumMap[ErrorStatusEnum.ERROR_GET_SELECTED_ZONE_DATA]);
          return;
        }
        yield PrayerTimeLoadSuccess(getSelectedZoneReturn, getSelectedZoneDataRetryReturn);
        return;
      }
      yield PrayerTimeLoadSuccess(getSelectedZoneReturn, getSelectedZoneDataReturn);
      return;
    }
    yield PrayerTimeDataUnknownState();
    return;
  }
}
