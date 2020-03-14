import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:minaret/logic/common.dart';
import 'package:minaret/logic/repo_esolat.dart';
import 'package:minaret/model/pt_zone.dart';

part 'prayer_zone_event.dart';
part 'prayer_zone_state.dart';

class PrayerZoneBloc extends Bloc<PrayerZoneEvent, PrayerZoneState> {
  ESolatRepository repo = ESolatRepository();

  @override
  PrayerZoneState get initialState => PrayerZoneLoading();

  @override
  Stream<PrayerZoneState> mapEventToState(PrayerZoneEvent event) async* {
    // loading
    yield PrayerZoneLoading();

    // load prayer zone data
    if (event is PrayerZoneLoad) {
      // get zone list
      var getZoneReturn = await repo.getZoneList();
      if (getZoneReturn == null || getZoneReturn.isEmpty) {
        // retrieve zone list
        var retrieveZoneReturn = await repo.retrieveZoneList();
        if (retrieveZoneReturn != ErrorStatusEnum.OK) {
          yield PrayerZoneError(errorStatusEnumMap[ErrorStatusEnum.ERROR_RETRIEVE_ZONE_LIST]);
          return;
        }
        // retry get zone list
        var getZoneRetryReturn = await repo.getZoneList();
        if (getZoneRetryReturn == null || getZoneRetryReturn.isEmpty) {
          yield PrayerZoneError(errorStatusEnumMap[ErrorStatusEnum.ERROR_GET_ZONE_LIST]);
          return;
        }
        yield PrayerZoneLoadSuccess(getZoneRetryReturn);
        return;
      }
      yield PrayerZoneLoadSuccess(getZoneReturn);
      return;
    } else if (event is PrayerZoneSet) {
      // set zone
      var setZoneReturn = await repo.setSelectedZone(event.zoneCode);
      if (setZoneReturn != ErrorStatusEnum.OK) {
        yield PrayerZoneError(errorStatusEnumMap[setZoneReturn]);
        return;
      }
      yield PrayerZoneSetSuccess();
      return;
    }
    yield PrayerZoneUnknownState();
    return;
  }
}
