enum ErrorStatusEnum {
  OK,
  ERROR,
  ERROR_UNABLE_REACH_ESOLAT,
  ERROR_GET_ZONE_LIST,
  ERROR_RETRIEVE_ZONE_LIST,
  ERROR_SET_SELECTED_ZONE,
  ERROR_GET_SELECTED_ZONE,
  ERROR_RETRIEVE_ZONE_DATA,
  ERROR_GET_SELECTED_ZONE_DATA,
  ERROR_UNKNOWN_STATE,
}

Map<ErrorStatusEnum, String> errorStatusEnumMap = {
  ErrorStatusEnum.OK: 'Operation success.',
  ErrorStatusEnum.ERROR: 'Common error happened.',
  ErrorStatusEnum.ERROR_UNABLE_REACH_ESOLAT: 'Unable to reach e-Solat portal.',
  ErrorStatusEnum.ERROR_GET_ZONE_LIST: 'Unable to get zone list from database.',
  ErrorStatusEnum.ERROR_RETRIEVE_ZONE_LIST: 'Unable to retrieve zone list from e-Solat.',
  ErrorStatusEnum.ERROR_SET_SELECTED_ZONE: 'Unable to set selected zone to database.',
  ErrorStatusEnum.ERROR_GET_SELECTED_ZONE: 'Unable to get selected zone from database.',
  ErrorStatusEnum.ERROR_RETRIEVE_ZONE_DATA: 'Unable to retrieve selected zone data from e-Solat.',
  ErrorStatusEnum.ERROR_GET_SELECTED_ZONE_DATA: 'Unable to get selected zone data from database.',
  ErrorStatusEnum.ERROR_UNKNOWN_STATE: 'Unknown state.',
};

Map<String, String> zoneCodeToStateMap = {
  'JHR': 'Johor',
  'KDH': 'Kedah',
  'KTN': 'Kelantan',
  'MLK': 'Melaka',
  'NGS': 'Negeri Sembilan',
  'PHG': 'Pahang',
  'PLS': 'Perlis',
  'PNG': 'Pulau Pinang',
  'PRK': 'Perak',
  'SBH': 'Sabah',
  'SGR': 'Selangor',
  'SWK': 'Sarawak',
  'TRG': 'Terengganu',
  'WLY': 'Wilayah Persekutuan',
};

Map<String, String> hijriMonthNameMap = {
  '01': 'Muharram',
  '02': 'Safar',
  '03': 'Rabi\'ulawal',
  '04': 'Rabi\'ulakhir',
  '05': 'Jamadilawwal',
  '06': 'Jamadilakhir',
  '07': 'Rejab',
  '08': 'Sya\'ban',
  '09': 'Ramadhan',
  '10': 'Shawwal',
  '11': 'Zulqa\'idah',
  '12': 'Zulhijjah',
};
