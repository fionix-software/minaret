import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:waktuku/bloc/bloc.dart';

class PrayerTimeBloc extends Bloc<PrayerTimeEvent, PrayerTimeState> {
  @override
  PrayerTimeState get initialState => InitialPrayerTimeState();

  @override
  Stream<PrayerTimeState> mapEventToState(PrayerTimeEvent event) async* {
    // TODO: Add Logic
  }
}
