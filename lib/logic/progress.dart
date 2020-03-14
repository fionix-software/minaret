import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum ProgressEnum {
  PROGRESS_ERROR,
  PROGRESS_LOADING,
  PROGRESS_RETRIEVING,
}

class ProgressStruct {
  final IconData icon;
  final String message;
  ProgressStruct(this.icon, this.message);
}

Map<ProgressEnum, ProgressStruct> progressMap = {
  ProgressEnum.PROGRESS_ERROR: ProgressStruct(FontAwesomeIcons.exclamationTriangle, 'n/a'), // error message will be using common error messages
  ProgressEnum.PROGRESS_LOADING: ProgressStruct(FontAwesomeIcons.syncAlt, 'Loading'),
  ProgressEnum.PROGRESS_RETRIEVING: ProgressStruct(FontAwesomeIcons.cloudDownloadAlt, 'Retrieving data'),
};

ProgressStruct getProgressData([ProgressEnum progressEnum = ProgressEnum.PROGRESS_ERROR, String message = '']) {
  if (message != null && message.isNotEmpty) {
    return ProgressStruct(progressMap[progressEnum].icon, message);
  }
  return ProgressStruct(progressMap[progressEnum].icon, progressMap[progressEnum].message);
}
