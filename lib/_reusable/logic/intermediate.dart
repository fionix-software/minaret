import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum IntermediateEnum {
  ERROR,
  SUCCESS,
  LOADING,
  RETRIEVING,
}

class IntermediateScreenSettings {
  final String message;
  final IconData iconData;
  final bool isCloseEnabled;
  IntermediateScreenSettings(this.message, this.iconData, this.isCloseEnabled);
}

Map<IntermediateEnum, IntermediateScreenSettings> intermediateSettingsMap = {
  IntermediateEnum.ERROR: IntermediateScreenSettings('Failed! Press icon to retry.', FontAwesomeIcons.exclamationTriangle, true),
  IntermediateEnum.SUCCESS: IntermediateScreenSettings('Success!', FontAwesomeIcons.thumbsUp, true),
  IntermediateEnum.LOADING: IntermediateScreenSettings('Processing data ..', FontAwesomeIcons.syncAlt, false),
  IntermediateEnum.RETRIEVING: IntermediateScreenSettings('Retrieving data ..', FontAwesomeIcons.cloudDownloadAlt, false),
};
