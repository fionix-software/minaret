import 'dart:developer';

void databaseErrorMessageLog(String operationTag, Exception e) {
  log(operationTag + ': ' + e.toString());
}
