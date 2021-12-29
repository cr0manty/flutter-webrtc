import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

abstract class BaseVideoHelper {
  final MethodChannel channel = WebRTC.methodChannel();

  bool supportedPlatforms({bool allowAndroid = false}) {
    if (!kIsWeb && Platform.isIOS) return true;

    if (allowAndroid && Platform.isAndroid) return true;
    throw UnimplementedError('This method not implemented for this platform');
  }
}
