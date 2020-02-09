import 'package:flutter/material.dart';

enum ErrorStatusEnum {
  OK,
  ERROR,
  ERROR_GET_ZONE_LIST,
  ERROR_RETRIEVE_ZONE_LIST,
  ERROR_SET_SELECTED_ZONE,
  ERROR_GET_SELECTED_ZONE,
  ERROR_GET_SELECTED_ZONE_DATA_LIST,
  ERROR_RETRIEVE_ZONE_DATA,
  ERROR_GET_SELECTED_ZONE_DATA,
}

Map<ErrorStatusEnum, String> errorStatusEnumMap = {
  ErrorStatusEnum.OK: "Operation success",
  ErrorStatusEnum.ERROR: "Common error happens",
  ErrorStatusEnum.ERROR_GET_ZONE_LIST: "Unable to get zone list from database",
  ErrorStatusEnum.ERROR_RETRIEVE_ZONE_LIST: "Unable to retrieve zone list from e-Solat",
  ErrorStatusEnum.ERROR_SET_SELECTED_ZONE: "Unable to set selected zone to database",
  ErrorStatusEnum.ERROR_GET_SELECTED_ZONE: "Unable to get selected zone from database",
  ErrorStatusEnum.ERROR_GET_SELECTED_ZONE_DATA_LIST: "Unable to get selected zone data list from database",
  ErrorStatusEnum.ERROR_RETRIEVE_ZONE_DATA: "Unable to retrieve selected zone data from e-Solat",
  ErrorStatusEnum.ERROR_GET_SELECTED_ZONE_DATA: "Unable to get selected zone data from database",
};

Color appThemeColor = Color.fromARGB(255, 39, 174, 96);
