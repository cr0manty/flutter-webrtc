import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc/src/video_helper/base/base_video_helper.dart';

class ExposureHelper extends BaseVideoHelper {
  final _exposureModeChannel = EventChannel(
    'exposureModeHandler.dataChannel',
  );
  final _exposureDurationChannel = EventChannel(
    'exposureDurationHandler.dataChannel',
  );
  final _ISOChannel = EventChannel(
    'ISOHandler.dataChannel',
  );
  final _exposureTargetBiasChannel = EventChannel(
    'exposureTargetBiasHandler.dataChannel',
  );
  final _exposureTargetOffsetChannel = EventChannel(
    'exposureTargetOffsetHandler.dataChannel',
  );

  Stream<AVCaptureExposureMode>? _exposureModeStream;
  Stream<ExposureDuration>? _exposureDurationStream;
  Stream<double>? _ISOStream;
  Stream<double>? _exposureTargetBiasStream;
  Stream<double>? _exposureTargetOffsetStream;

  Stream<AVCaptureExposureMode> get exposureModeStream {
    _exposureModeStream ??=
        _exposureModeChannel.receiveBroadcastStream().transform(
      StreamTransformer.fromHandlers(
        handleData: (index, EventSink sink) {
          sink.add(AVCaptureExposureMode.values[index]);
        },
      ),
    );
    return _exposureModeStream!;
  }

  Stream<double> get ISOStream {
    _ISOStream ??= _ISOChannel.receiveBroadcastStream().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, EventSink sink) {
          sink.add(data);
        },
      ),
    );
    return _ISOStream!;
  }

  Stream<double> get exposureTargetBiasStream {
    _exposureTargetBiasStream ??=
        _exposureTargetBiasChannel.receiveBroadcastStream().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, EventSink sink) {
          sink.add(data);
        },
      ),
    );
    return _exposureTargetBiasStream!;
  }

  Stream<double> get exposureTargetOffsetStream {
    _exposureTargetOffsetStream ??=
        _exposureTargetOffsetChannel.receiveBroadcastStream().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, EventSink sink) {
          sink.add(data);
        },
      ),
    );
    return _exposureTargetOffsetStream!;
  }

  Stream<ExposureDuration> get exposureDurationStream {
    _exposureDurationStream ??=
        _exposureDurationChannel.receiveBroadcastStream().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, EventSink sink) {
          final value = ExposureDuration.fromJson(data);
          sink.add(value);
        },
      ),
    );
    return _exposureDurationStream!;
  }

  Future<bool> isExposureModeSupported(
    AVCaptureExposureMode mode,
  ) async {
    supportedPlatforms();

    final result = await channel.invokeMethod<bool>(
      '#VideoHelper/isExposureModeSupported',
      {'mode': mode.index},
    );
    return result ?? false;
  }

  Future<bool> setExposureMode(
    AVCaptureExposureMode mode,
  ) async {
    supportedPlatforms();

    final result = await channel.invokeMethod<bool>(
      '#VideoHelper/setExposureMode',
      {'mode': mode.index},
    );
    return result ?? false;
  }

  Future<AVCaptureExposureMode> getExposureMode() async {
    supportedPlatforms();

    final index = await channel.invokeMethod<int>(
      '#VideoHelper/getExposureMode',
    );

    if (index == null || AVCaptureExposureMode.values.length < index) {
      throw 'getExposureMode error: Mode not found';
    }

    final mode = AVCaptureExposureMode.values[index];

    return mode;
  }

  Future<bool> changeISO(
    double value,
  ) async {
    supportedPlatforms();

    final result = await channel.invokeMethod<bool>(
      '#VideoHelper/changeISO',
      {'value': value},
    );
    return result ?? false;
  }

  Future<double> getISO() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<double>(
      '#VideoHelper/getISO',
    );
    return result ?? 0.0;
  }

  Future<double> getExposureTargetBias() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<double>(
      '#VideoHelper/getExposureTargetBias',
    );
    return result ?? 0.0;
  }

  Future<double> getMaxExposureTargetBias() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<double>(
      '#VideoHelper/getMaxExposureTargetBias',
    );
    return result ?? 0.0;
  }

  Future<double> getMinExposureTargetBias() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<double>(
      '#VideoHelper/getMinExposureTargetBias',
    );
    return result ?? 0.0;
  }

  Future<double> getMaxISO() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<double>(
      '#VideoHelper/getMaxISO',
    );
    return result ?? 0.0;
  }

  Future<double> getExposureTargetOffset() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<double>(
      '#VideoHelper/getExposureTargetOffset',
    );
    return result ?? 0.0;
  }

  Future<double> getMinISO() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<double>(
      '#VideoHelper/getMinISO',
    );
    return result ?? 0.0;
  }

  Future<ExposureDuration> getExposureDuration() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<Map>(
      '#VideoHelper/getExposureDuration',
    );

    if (result == null || result.length < 2) {
      throw 'getExposureDuration error: not enough parameters';
    }
    final data = ExposureDuration.fromJson(result);

    return data;
  }

  Future<ExposureDuration> getExposureDurationSeconds() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<Map>(
      '#VideoHelper/getExposureDurationSeconds',
    );

    if (result == null || result.length < 2) {
      throw 'getExposureDurationSeconds error: not enough parameters';
    }
    final data = ExposureDuration.fromJson(result);

    return data;
  }

  Future<ExposureDuration> minExposureDuration() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<Map>(
      '#VideoHelper/minExposureDuration',
    );

    if (result == null || result.length < 2) {
      throw 'minExposureDuration error: not enough parameters';
    }
    final data = ExposureDuration.fromJson(result);

    return data;
  }

  Future<ExposureDuration> maxExposureDuration() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<Map>(
      '#VideoHelper/maxExposureDuration',
    );

    if (result == null || result.length < 2) {
      throw 'maxExposureDuration error: not enough parameters';
    }
    final data = ExposureDuration.fromJson(result);

    return data;
  }

  Future<bool> changeBias(
    double value,
  ) async {
    supportedPlatforms();

    final result = await channel.invokeMethod<bool>(
      '#VideoHelper/changeBias',
      {'value': value},
    );
    return result ?? false;
  }

  Future<bool> changeExposureDuration(
    double value,
  ) async {
    supportedPlatforms();

    final result = await channel.invokeMethod<bool>(
      '#VideoHelper/changeExposureDuration',
      {'value': value},
    );
    return result ?? false;
  }

  Future<List<AVCaptureExposureMode>> getSupportedExposureMode() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<List>(
      '#VideoHelper/getSupportedExposureMode',
    );

    final supportedMode = <AVCaptureExposureMode>[];

    for (final index in result ?? []) {
      supportedMode.add(AVCaptureExposureMode.values[index]);
    }

    return supportedMode;
  }
}
