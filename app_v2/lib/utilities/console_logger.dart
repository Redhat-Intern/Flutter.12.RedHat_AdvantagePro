import 'package:flutter/foundation.dart';

class ConsoleLogger {
  /// Extracts the caller function name and file name from the stack trace.
  static String getCallerInfo({int level = 2}) {
    try {
      // Capture the current stack trace as a string
      final stackTrace = StackTrace.current.toString();

      // Split the stack trace into individual lines
      final traceLines = stackTrace.split('\n');

      // Adjust the level to skip the current method and go to the actual caller
      if (traceLines.length > level) {
        final callerLine = traceLines[level].trim();

        // Extract the method name and file name
        final methodNameRegex = RegExp(r'#\d+\s+([^\s]+)');
        final fileInfoRegex = RegExp(r'\(([^)]+)\)');

        final methodNameMatch = methodNameRegex.firstMatch(callerLine);
        final fileInfoMatch = fileInfoRegex.firstMatch(callerLine);

        if (methodNameMatch != null && fileInfoMatch != null) {
          final methodName = methodNameMatch.group(1) ?? 'UnknownFunction';
          final fileInfo = fileInfoMatch.group(1) ?? 'UnknownFile';
          final fileName =
              fileInfo.split('/').last; // Extract the file name from the path

          return '$methodName ($fileName)';
        }
      }
    } catch (e) {
      debugPrint("Error in parsing stack trace: $e");
    }

    // Return 'Unknown' if unable to parse the stack trace
    return 'Unknown';
  }

  /// Logs fetched data with caller information.
  static void fetchedData(Object? message) {
    String from = getCallerInfo(level: 3);
    if (message == null || message.toString().isEmpty) {
      debugPrint("\n**** 🚫 No data found from $from. 🚫 ****\n");
    } else {
      debugPrint("\n**** 🟢 $message from $from 🟢 ****\n");
    }
  }

  /// Logs errors with caller information.
  static void error(Object message) {
    String from = getCallerInfo(level: 3);
    debugPrint("\n#### 🚨 $message from $from 🚨 ####\n");
  }

  /// Logs sent messages with caller information.
  static void sent(Object message) {
    String from = getCallerInfo(level: 3);
    debugPrint("\n==== 🚀 $message from $from 🚀 ====\n");
  }

  /// Logs routing information with caller information.
  static void route(Object message) {
    String from = getCallerInfo(level: 3);
    debugPrint("\n@@@@ 🗺️ $message from $from 🗺️ @@@@\n");
  }

  /// Logs the start of a process with caller information.
  static void processStart(Object message) {
    String from = getCallerInfo(level: 3);
    debugPrint("\n>>>> ⏳ STARTED >> $message from $from >> STARTED ⏳ >>>>\n");
  }

  /// Logs the completion of a process with caller information.
  static void processComplete(Object message) {
    String from = getCallerInfo(level: 3);
    debugPrint(
        "\n<<<< 🎉 COMPLETED << $message from $from << COMPLETED 🎉 <<<<\n");
  }

  /// Logs when no data is found with caller information.
  static void noDataFound(Object message) {
    String from = getCallerInfo(level: 3);
    debugPrint("\n**** 🚫 $message from $from 🚫 ****\n");
  }

  /// Logs general messages with caller information.
  static void message(Object message) {
    String from = getCallerInfo(level: 3);
    debugPrint("\n**** 💬  $message from $from 💬 ****\n");
  }
}
