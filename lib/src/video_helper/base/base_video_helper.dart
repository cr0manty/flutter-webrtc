import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

abstract class BaseVideoHelper {
  BaseVideoHelper() {
    if (!kIsWeb) {
      channel = WebRTC.methodChannel();
    }
  }

  late final MethodChannel channel;

  bool supportedPlatforms({
    bool allowAndroid = false,
    bool allowWeb = false,
  }) {
    if (kIsWeb && allowWeb) return true;
    if (!kIsWeb) {
      if (Platform.isIOS) return true;

      if (allowAndroid && Platform.isAndroid) return true;
    }
    throw UnimplementedError(
      'This method not implemented for this platform',
    );
  }
}
