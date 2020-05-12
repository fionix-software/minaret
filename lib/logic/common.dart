enum ErrorStatusEnum {
  ERROR_RESET_DATA_FROM_DATABASE,
  ERROR_RETRIEVE_ZONE_LIST,
  ERROR_RETRIEVE_ZONE_DATA,
}

Map<ErrorStatusEnum, String> errorStatusEnumMap = {
  ErrorStatusEnum.ERROR_RESET_DATA_FROM_DATABASE: 'Unable to reset data from database.',
  ErrorStatusEnum.ERROR_RETRIEVE_ZONE_LIST: 'Unable to retrieve zone list from e-Solat.',
  ErrorStatusEnum.ERROR_RETRIEVE_ZONE_DATA: 'Unable to retrieve selected zone data from e-Solat.',
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
