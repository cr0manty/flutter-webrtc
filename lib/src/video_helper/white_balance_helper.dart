import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc/src/video_helper/base/base_video_helper.dart';

class WhiteBalanceHelper extends BaseVideoHelper {
  final _whiteBalanceModeChannel = EventChannel(
    'whiteBalanceMode.dataChannel',
  );
  final _whiteBalanceGainsChannel = EventChannel(
    'whiteBalanceGainsHandler.dataChannel',
  );

  Stream<AVCaptureWhiteBalanceMode>? _whiteBalanceModeStream;
  Stream<TemperatureAndTintWhiteBalanceGains>? _whiteBalanceTempGainsStream;
  Stream<WhiteBalanceGains>? _whiteBalanceGainsStream;

  Stream<AVCaptureWhiteBalanceMode> get whiteBalanceModeStream {
    _whiteBalanceModeStream ??=
        _whiteBalanceModeChannel.receiveBroadcastStream().transform(
      StreamTransformer.fromHandlers(
        handleData: (index, EventSink sink) {
          sink.add(AVCaptureWhiteBalanceMode.values[index]);
        },
      ),
    );
    return _whiteBalanceModeStream!;
  }

  Stream<TemperatureAndTintWhiteBalanceGains> get whiteBalanceTempGainsStream {
    _whiteBalanceTempGainsStream ??= whiteBalanceGainsStream.transform(
      StreamTransformer.fromHandlers(
        handleData: (gains, EventSink sink) async {
          final tempGains = await convertDeviceGainsToTemperature(gains);
          sink.add(tempGains);
        },
      ),
    );
    return _whiteBalanceTempGainsStream!;
  }

  Stream<WhiteBalanceGains> get whiteBalanceGainsStream {
    _whiteBalanceGainsStream ??=
        _whiteBalanceGainsChannel.receiveBroadcastStream().transform(
      StreamTransformer.fromHandlers(
        handleData: (json, EventSink sink) async {
          final gains = WhiteBalanceGains.fromJson(json);
          sink.add(gains);
        },
      ),
    );
    return _whiteBalanceGainsStream!;
  }

  Future<AVCaptureWhiteBalanceMode> getWhiteBalanceMode() async {
    supportedPlatforms();

    final index = await channel.invokeMethod<int>(
      '#VideoHelper/getWhiteBalanceMode',
    );

    if (index == null || AVCaptureWhiteBalanceMode.values.length < index) {
      throw 'getWhiteBalanceMode error: Mode not found';
    }

    final mode = AVCaptureWhiteBalanceMode.values[index];

    return mode;
  }

  Future<bool> isWhiteBalanceLockSupported() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<bool>(
      '#VideoHelper/isWhiteBalanceLockSupported',
    );
    return result ?? false;
  }

  Future<bool> isWhiteBalanceModeSupported(
    AVCaptureWhiteBalanceMode mode,
  ) async {
    supportedPlatforms();

    final result = await channel.invokeMethod<bool>(
      '#VideoHelper/isWhiteBalanceModeSupported',
      {'mode': mode.index},
    );
    return result ?? false;
  }

  Future<List<AVCaptureWhiteBalanceMode>> getSupportedWhiteBalanceMode() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<List>(
      '#VideoHelper/getSupportedWhiteBalanceMode',
    );

    final supportedMode = <AVCaptureWhiteBalanceMode>[];

    for (final index in result ?? []) {
      supportedMode.add(AVCaptureWhiteBalanceMode.values[index]);
    }

    return supportedMode;
  }

  Future<bool> setWhiteBalanceMode(
    AVCaptureWhiteBalanceMode mode,
  ) async {
    supportedPlatforms();

    final isSupported = await isWhiteBalanceLockSupported();

    if (!isSupported && mode == AVCaptureWhiteBalanceMode.locked) {
      return false;
    }

    final result = await channel.invokeMethod<bool>(
      '#VideoHelper/setWhiteBalanceMode',
      {'mode': mode.index},
    );
    return result ?? false;
  }

  Future<bool> changeWhiteBalanceGains(WhiteBalanceGains gains) async {
    supportedPlatforms();

    final isSupported = await isWhiteBalanceLockSupported();

    if (!isSupported) {
      throw 'changeWhiteBalanceGains is not supported'
          'use [isWhiteBalanceLockSupported] for check is lock mode is supported';
    }

    final result = await channel.invokeMethod<bool>(
      '#VideoHelper/setWhiteBalanceGains',
      gains.toJson(),
    );
    return result ?? false;
  }

  Future<bool> changeWhiteBalanceTemperatureAndTint(
    TemperatureAndTintWhiteBalanceGains gains,
  ) async {
    supportedPlatforms();

    final isSupported = await isWhiteBalanceLockSupported();

    if (!isSupported) {
      throw 'changeWhiteBalanceTemperatureAndTint is not supported'
          'use [isWhiteBalanceLockSupported] for check is lock mode is supported';
    }

    final result = await channel.invokeMethod<bool>(
      '#VideoHelper/changeWhiteBalanceTemperatureAndTint',
      gains.toJson(),
    );
    return result ?? false;
  }

  Future<bool> lockWithGrayWorld() async {
    supportedPlatforms();

    final isSupported = await isWhiteBalanceLockSupported();

    if (!isSupported) {
      throw 'lockWithGrayWorld is not supported'
          'use [isWhiteBalanceLockSupported] for check is lock mode is supported';
    }

    final result = await channel.invokeMethod<bool>(
      '#VideoHelper/lockWithGrayWorld',
    );
    return result ?? false;
  }

  Future<double> getMaxBalanceGains() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<double>(
      '#VideoHelper/getMaxBalanceGains',
    );
    return result ?? 1.0;
  }

  Future<WhiteBalanceGains> getCurrentBalanceGains() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<Map>(
      '#VideoHelper/getCurrentBalanceGains',
    );
    if (result == null || result.isEmpty || result.length < 3) {
      return WhiteBalanceGains.zero();
    }

    return WhiteBalanceGains.fromJson(result);
  }

  Future<TemperatureAndTintWhiteBalanceGains>
      getCurrentTemperatureBalanceGains() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<Map>(
      '#VideoHelper/getCurrentTemperatureBalanceGains',
    );
    if (result == null || result.isEmpty || result.length < 2) {
      throw 'getCurrentTemperatureBalanceGains error';
    }

    return TemperatureAndTintWhiteBalanceGains.fromJson(result);
  }

  Future<TemperatureAndTintWhiteBalanceGains> convertDeviceGainsToTemperature(
    WhiteBalanceGains gains,
  ) async {
    supportedPlatforms();

    final result = await channel.invokeMethod<Map>(
      '#VideoHelper/convertDeviceGainsToTemperature',
      gains.toJson(),
    );
    if (result == null || result.isEmpty || result.length < 2) {
      throw 'convertDeviceGainsToTemperature error';
    }

    return TemperatureAndTintWhiteBalanceGains(
      temperature: result['temperature']!,
      tint: result['tint']!,
    );
  }
}
