import 'package:flutter/foundation.dart';

import 'package:ruhe/app.dart';

/* Production mode:
 * Analytics to Firebase
 * Logging to Ringbuffer
 * Exceptions to Firebase + Sentry, dump ringbuffer
 */

final Map<int, String> _typeNameMap = {};

abstract class LogWriter {
  void log(String message, {bool isDebug, Map<String, dynamic> extras});
  void logError(dynamic ex, StackTrace st,
      {String message, Map<String, dynamic> extras}) {}
}

class DebugLogWriter implements LogWriter {
  @override
  void log(String message, {bool isDebug, Map<String, dynamic> extras}) {
    debugPrint(message);
  }

  @override
  void logError(dynamic ex, StackTrace st,
      {String message, Map<String, dynamic> extras}) {
    if (message != null) {
      debugPrint('$message ($ex)\n$st');
    }
  }
}

class _LogMessage {
  _LogMessage({this.message, this.extras}) {
    time = DateTime.now().millisecondsSinceEpoch;
  }

  int time;
  final String message;
  final Map<String, dynamic> extras;
}

const kMaxBufferSize = 16;

mixin LoggerMixin {
  LogWriter _logger;

  _ensureLogger() {
    return _logger ?? (_logger = App.locator.get<LogWriter>());
  }

  log(String message) {
    final name = _typeNameMap[runtimeType.hashCode] ??
        (_typeNameMap[runtimeType.hashCode] = runtimeType.toString());

    _ensureLogger().log('$name: $message');
  }

  debug(String message) {
    final name = _typeNameMap[runtimeType.hashCode] ??
        (_typeNameMap[runtimeType.hashCode] = runtimeType.toString());

    _ensureLogger().log('$name: $message', isDebug: true);
  }

  logError(dynamic ex, StackTrace st,
      {String message, Map<String, dynamic> extras}) {
    _ensureLogger().logError(ex, st, message: message, extras: extras);
  }

  logException<TRet>(TRet Function() block,
      {bool rethrowIt = true, String message}) {
    try {
      return block();
    } catch (e, st) {
      _ensureLogger().logError(e, st, message: message);
      if (rethrowIt) rethrow;
    }
  }

  Future<TRet> logAsyncException<TRet>(Future<TRet> block,
      {bool rethrowIt = true, String message}) async {
    try {
      final ret = await block;
      return ret;
    } catch (e, st) {
      _ensureLogger().logError(e, st, message: message);
      if (rethrowIt) rethrow;
    }

    return null;
  }

  traceAsync<TRet>(String name, Future<TRet> block) async {
    //final trace = await FirebasePerformance.startTrace(name);
    final ret = await block;
    //unawaited(trace.stop());

    return ret;
  }
}

void setMapValue(Map<String, dynamic> map, String key, dynamic value) {
  map[key] = value;
}

void setMapValueIfNotNull(Map<String, dynamic> map, String key, dynamic value) {
  if (value != null) map[key] = value;
}

List<T> codeIterable<T>(Iterable values, T callback(value)) =>
    values?.map<T>(callback)?.toList();
