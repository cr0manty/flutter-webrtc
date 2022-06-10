import 'dart:io';

import 'package:flutter/services.dart';

class WebRTC {
  static const MethodChannel _channel = MethodChannel('FlutterWebRTC.Method');

  static MethodChannel methodChannel() => _channel;

  static bool get platformIsDesktop =>
      Platform.isWindows ||
      Platform.isLinux ||
      Platform.isMacOS ||
      Platform.isLinux;

  static bool get platformIsWindows => Platform.isWindows;

  static bool get platformIsLinux => Platform.isLinux;

  static bool get platformIsMobile => Platform.isIOS || Platform.isAndroid;

  static bool get platformIsIOS => Platform.isIOS;

  static bool get platformIsAndroid => Platform.isAndroid;

  static bool get platformIsWeb => false;

  static Future<T?> invokeMethod<T, P>(
    String methodName, [
    dynamic param,
  ]) async {
    await initialize();
    var response = await _channel.invokeMethod<T>(
      methodName,
      param,
    );

    // if (response == null) {
    //   throw Exception('Invoke method: $methodName return a null response');
    // }

    return response;
  }

  static bool _initialized = false;

  static Future<void> initialize({
    bool bypassVoiceProcessing = false,
    bool useExternalMic = false,
  }) async {
    if (!_initialized) {
      await _channel.invokeMethod<void>(
        'initialize',
        <String, dynamic>{
          'options': {
            'bypassVoiceProcessing': bypassVoiceProcessing,
            'useExternalMic': useExternalMic,
          },
        },
      );
      _initialized = true;
    }
  }
}
