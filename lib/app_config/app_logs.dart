import 'dart:convert';
import 'package:flutter/foundation.dart';

/// PRINT ONLY PAGE TITLES
void pageTitleLogs(String title) {
  if (!kReleaseMode) {
    debugPrint("===> Page Title: $title <===");
  }
}

/// PRINT ONLY SERVICE CLASS
void serviceLogs(
  String url, {
  String? method = 'POST',
  dynamic request,
  dynamic response,
}) {
  if (!kReleaseMode) {
    debugPrint("-----------------------------------");
    debugPrint("METHOD NAME : [$method]");
    debugPrint("API URL     : ${Uri.parse(url)}");
    debugPrint("REQUEST     : ${jsonEncode(request)}");
    debugPrint("RESPONSE    : ${jsonEncode(response)}");
    debugPrint("-----------------------------------");
  }
}

/// PRINT RESPONSE
void printContent(String content) {
  if (!kReleaseMode) {
    debugPrint("-----------------------------------");
    debugPrint(content);
    debugPrint("-----------------------------------");
  }
}

/// PRINT RESPONSE
void printDirect(String content) {
  if (!kReleaseMode) {
    debugPrint(content);
  }
}
