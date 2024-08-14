import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class ConsoleLogger {
  static void fetchedData(Object? message, {required String from}) {
    if (message == null || message.toString().isEmpty) {
      debugPrint("\n**** 🚫 No data found from $from. 🚫 ****\n");
    } else {
      debugPrint("\n**** 🟢 $message from $from 🟢 ****\n");
    }
  }

  static void error(Object message, {required String from}) {
    debugPrint("\n#### 🚨 $message from $from 🚨 ####\n");
  }

  static void sent(Object message, {required String from}) {
    debugPrint("\n==== 🚀 $message from $from 🚀 ====\n");
  }

  static void route(Object message, {required String from}) {
    debugPrint("\n@@@@ 🗺️ $message from $from 🗺️ @@@@\n");
  }

  static void processStart(Object message, {required String from}) {
    debugPrint("\n>>>> ⏳ STARTED >> $message from $from >> STARTED ⏳ >>>>\n");
  }

  static void processComplete(Object message, {required String from}) {
    debugPrint(
        "\n<<<< 🎉 COMPLETED << $message from $from << COMPLETED 🎉 <<<<\n");
  }

  static void noDataFound(Object message, {required String from}) {
    debugPrint("\n**** 🚫 $message from $from 🚫 ****\n");
  }

  static void message(Object message, {String? from}) {
    debugPrint("\n**** 💬  $message from $from 💬 ****\n");
  }

  static void apiResponse(String title, Response response,
      {required String from}) {
    debugPrint(
        "\n==== 🌐 ====\n$title from $from\nResponse:\nStatus Code: ${response.statusCode}\nHeaders: ${response.headers}\nBody: ${response.body}\n==== 🌐 ====\n");
  }
}
