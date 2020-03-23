import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:minaret/logic/common.dart';
import 'package:minaret/logic/repository.dart';
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
    yield PrayerZoneLoading();
    // register current event as last event
    if (event is PrayerZoneLoad || event is PrayerZoneRefresh || event is PrayerZoneSet) {
      lastEvent = event;
    }
    // load prayer zone data
    if (event is PrayerZoneLoad) {
      // get zone list
      var getZoneListReturn = await repo.getZoneList();
      if (getZoneListReturn != null && getZoneListReturn.isNotEmpty) {
        yield PrayerZoneLoadSuccess(getZoneListReturn);
        return;
      }
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
      // prayer zone load sucess
      yield PrayerZoneLoadSuccess(getZoneRetryReturn);
      return;
    } else if (event is PrayerZoneSet) {
      // set zone
      var setZoneReturn = await repo.setSelectedZone(event.zoneCode);
      if (setZoneReturn != ErrorStatusEnum.OK) {
        yield PrayerZoneError(errorStatusEnumMap[setZoneReturn]);
        return;
      }
      // prayer zone set success
      yield PrayerZoneSetSuccess();
      return;
    } else if (event is PrayerZoneRefresh) {
      // get selected zone
      var getSelectedZoneReturn = await repo.getSelectedZone();
      if (getSelectedZoneReturn == null) {
        // selected prayer zone not yet selected
      }
      // retrieve zone list
      var retrieveZoneReturn = await repo.retrieveZoneList();
      if (retrieveZoneReturn != ErrorStatusEnum.OK) {
        yield PrayerZoneError(errorStatusEnumMap[ErrorStatusEnum.ERROR_RETRIEVE_ZONE_LIST]);
        return;
      }
      // set selected zone (only if selected prayer zone has been selected)
      if (getSelectedZoneReturn != null) {
        var setSelectedZoneReturn = await repo.setSelectedZone(getSelectedZoneReturn.code);
        if (setSelectedZoneReturn != ErrorStatusEnum.OK) {
          yield PrayerZoneError(errorStatusEnumMap[ErrorStatusEnum.ERROR_SET_SELECTED_ZONE]);
          return;
        }
      }
      // get zone list
      var getZoneListReturn = await repo.getZoneList();
      if (getZoneListReturn == null || getZoneListReturn.isEmpty) {
        yield PrayerZoneError(errorStatusEnumMap[ErrorStatusEnum.ERROR_GET_ZONE_LIST]);
        return;
      }
      // prayer zone refresh success
      yield PrayerZoneRefreshSuccess(getZoneListReturn);
      return;
    }
    // unknown state
    yield PrayerZoneUnknownState();
    return;
  }
}
