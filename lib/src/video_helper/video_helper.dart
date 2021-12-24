import 'dart:io' show Platform;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc/src/video_helper/enums.dart';

class VideoHelper {
  static final MethodChannel _channel = WebRTC.methodChannel();

  static bool _supportedPlatforms({bool allowAndroid = false}) {
    if (!kIsWeb && Platform.isIOS) return true;

    if (allowAndroid && Platform.isAndroid) return true;
    throw UnimplementedError('This method not implemented for this platform');
  }

  /// zoom
  static Future<bool> setZoom(double zoom, String trackId) async {
    _supportedPlatforms(allowAndroid: true);

    final result = await _channel.invokeMethod<bool>(
      '#VideoHelper/changeZoom',
      <String, dynamic>{
        'zoom': zoom,
        'trackId': trackId,
      },
    );

    return result ?? false;
  }

  static Future<double> maxZoomFactor() async {
    _supportedPlatforms();

    final result = await _channel.invokeMethod<double>(
      '#VideoHelper/getMaxZoomFactor',
    );

    return result ?? 2.0;
  }

  static Future<double> minZoomFactor() async {
    _supportedPlatforms();

    final result = await _channel.invokeMethod<double>(
      '#VideoHelper/getMinZoomFactor',
    );

    return result ?? 1.0;
  }

  static Future<double> currentZoomFactor() async {
    _supportedPlatforms();

    final result = await _channel.invokeMethod<double>(
      '#VideoHelper/getZoomFactor',
    );

    return result ?? 1.0;
  }

  /// focus
  static Future<bool> isFocusModeSupported(
    AVCaptureWhiteBalanceMode mode,
  ) async {
    _supportedPlatforms();

    final result = await _channel.invokeMethod<bool>(
      '#VideoHelper/isFocusModeSupported',
      {'mode': mode.index},
    );
    return result ?? false;
  }

  static Future<bool> setFocusMode(
    AVCaptureFocusMode mode,
  ) async {
    _supportedPlatforms();

    final result = await _channel.invokeMethod<bool>(
      '#VideoHelper/setFocusMode',
      {'mode': mode.index},
    );
    return result ?? false;
  }

  static Future<AVCaptureFocusMode> getFocusMode() async {
    _supportedPlatforms();

    final index = await _channel.invokeMethod<int>(
      '#VideoHelper/getFocusMode',
    );

    if (index == null || AVCaptureFocusMode.values.length < index) {
      throw 'getWhiteBalanceMode error: Mode not found';
    }

    final mode = AVCaptureFocusMode.values[index];

    return mode;
  }

  static Future<bool> setFocusPoint(Point point) async {
    _supportedPlatforms();

    final result = await _channel.invokeMethod<bool>(
      '#VideoHelper/setFocusPoint',
      {
        'x': point.x,
        'y': point.y,
      },
    );
    return result ?? false;
  }

  static Future<double> getFocusPointLockedWithLensPosition() async {
    _supportedPlatforms();

    final result = await _channel.invokeMethod<double>(
      '#VideoHelper/getFocusPointLockedWithLensPosition',
    );
    return result ?? 0.0;
  }

  static Future<bool> setFocusPointLockedWithLensPosition(double value) async {
    _supportedPlatforms();

    final result = await _channel.invokeMethod<bool>(
      '#VideoHelper/setFocusPoint',
      {
        'position': value,
      },
    );
    return result ?? false;
  }

  /// white balance
  static Future<AVCaptureWhiteBalanceMode> getWhiteBalanceMode() async {
    _supportedPlatforms();

    final index = await _channel.invokeMethod<int>(
      '#VideoHelper/getWhiteBalanceMode',
    );

    if (index == null || AVCaptureWhiteBalanceMode.values.length < index) {
      throw 'getWhiteBalanceMode error: Mode not found';
    }

    final mode = AVCaptureWhiteBalanceMode.values[index];

    return mode;
  }

  static Future<bool> isWhiteBalanceModeSupported(
    AVCaptureWhiteBalanceMode mode,
  ) async {
    _supportedPlatforms();

    final result = await _channel.invokeMethod<bool>(
      '#VideoHelper/isWhiteBalanceModeSupported',
      {'mode': mode.index},
    );
    return result ?? false;
  }

  static Future<bool> setWhiteBalanceMode(
    AVCaptureWhiteBalanceMode mode,
  ) async {
    _supportedPlatforms();

    final result = await _channel.invokeMethod<bool>(
      '#VideoHelper/setWhiteBalanceMode',
      {'mode': mode.index},
    );
    return result ?? false;
  }

  static Future<bool> setWhiteBalanceGains(WhiteBalanceGains gains) async {
    _supportedPlatforms();

    final result = await _channel.invokeMethod<bool>(
      '#VideoHelper/setWhiteBalanceGains',
      gains.toJson(),
    );
    return result ?? false;
  }

  static Future<bool> changeWhiteBalanceTemperatureAndTint(
    TemperatureAndTintWhiteBalanceGains gains,
  ) async {
    _supportedPlatforms();

    final result = await _channel.invokeMethod<bool>(
      '#VideoHelper/changeWhiteBalanceTemperatureAndTint',
      gains.toJson(),
    );
    return result ?? false;
  }

  static Future<bool> lockWithGrayWorld() async {
    _supportedPlatforms();

    final result = await _channel.invokeMethod<bool>(
      '#VideoHelper/lockWithGrayWorld',
    );
    return result ?? false;
  }

  static Future<double> getMaxBalanceGains() async {
    _supportedPlatforms();

    final result = await _channel.invokeMethod<double>(
      '#VideoHelper/getMaxBalanceGains',
    );
    return result ?? 0.0;
  }

  static Future<WhiteBalanceGains> getCurrentBalanceGains() async {
    _supportedPlatforms();

    final result = await _channel.invokeMethod<Map>(
      '#VideoHelper/getCurrentBalanceGains',
    );
    if (result == null || result.isEmpty || result.length < 3) {
      return WhiteBalanceGains.zero();
    }

    return WhiteBalanceGains(
      redGain: result['redGain']!,
      greenGain: result['greenGain']!,
      blueGain: result['blueGain']!,
    );
  }

  static Future<TemperatureAndTintWhiteBalanceGains>
      getCurrentTemperatureBalanceGains() async {
    _supportedPlatforms();

    final result = await _channel.invokeMethod<Map>(
      '#VideoHelper/getCurrentTemperatureBalanceGains',
    );
    if (result == null || result.isEmpty || result.length < 2) {
      throw 'getCurrentTemperatureBalanceGains error';
    }

    return TemperatureAndTintWhiteBalanceGains(
      temperature: result['temperature']!,
      tint: result['tint']!,
    );
  }

  /// change exposure
  static Future<bool> isExposureModeSupported(
    AVCaptureExposureMode mode,
  ) async {
    _supportedPlatforms();

    final result = await _channel.invokeMethod<bool>(
      '#VideoHelper/isExposureModeSupported',
      {'mode': mode.index},
    );
    return result ?? false;
  }

  static Future<bool> setExposureMode(
    AVCaptureExposureMode mode,
  ) async {
    _supportedPlatforms();

    final result = await _channel.invokeMethod<bool>(
      '#VideoHelper/setExposureMode',
      {'mode': mode.index},
    );
    return result ?? false;
  }

  static Future<bool> changeISO(
    double value,
  ) async {
    _supportedPlatforms();

    final result = await _channel.invokeMethod<bool>(
      '#VideoHelper/changeISO',
      {'value': value},
    );
    return result ?? false;
  }

  static Future<bool> changeBias(
    double value,
  ) async {
    _supportedPlatforms();

    final result = await _channel.invokeMethod<bool>(
      '#VideoHelper/changeBias',
      {'value': value},
    );
    return result ?? false;
  }

  static Future<bool> changeExposureDuration(
    double value,
  ) async {
    _supportedPlatforms();

    final result = await _channel.invokeMethod<bool>(
      '#VideoHelper/changeExposureDuration',
      {'value': value},
    );
    return result ?? false;
  }

  /// Lens switching
  static Future<int> lensAmount() async {
    _supportedPlatforms();

    final result = await _channel.invokeMethod<int>(
      '#VideoHelper/getCameraLensAmount',
    );
    return result ?? 0;
  }
}
