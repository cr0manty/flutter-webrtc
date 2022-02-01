import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc/src/video_helper/base/base_video_helper.dart';

class FocusHelper extends BaseVideoHelper {
  FocusHelper() : super();

  final _focusModeChannel = EventChannel(
    'focusModeHandler.dataChannel',
  );
  final _focusLensDistanceChannel = EventChannel(
    'focusLensPositionHandler.dataChannel',
  );

  Stream<AVCaptureFocusMode>? _focusModeStream;
  Stream<double>? _focusLensDistanceStream;

  Stream<AVCaptureFocusMode> get focusModeStream {
    _focusModeStream ??= _focusModeChannel.receiveBroadcastStream().transform(
      StreamTransformer.fromHandlers(
        handleData: (index, EventSink sink) {
          sink.add(AVCaptureFocusMode.values[index]);
        },
      ),
    );
    return _focusModeStream!;
  }

  Stream<double> get focusLensDistanceStream {
    _focusLensDistanceStream ??=
        _focusLensDistanceChannel.receiveBroadcastStream().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, EventSink sink) {
          sink.add(data);
        },
      ),
    );
    return _focusLensDistanceStream!;
  }

  Future<bool> isFocusModeSupported(
    AVCaptureFocusMode mode,
  ) async {
    supportedPlatforms();

    final result = await channel.invokeMethod<bool>(
      '#VideoHelper/isFocusModeSupported',
      {'mode': mode.index},
    );
    return result ?? false;
  }

  Future<bool> isLockingFocusWithCustomLensPositionSupported() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<bool>(
      '#VideoHelper/isLockingFocusWithCustomLensPositionSupported',
    );
    return result ?? false;
  }

  Future<bool> setFocusMode(
    AVCaptureFocusMode mode,
  ) async {
    supportedPlatforms();

    final result = await channel.invokeMethod<bool>(
      '#VideoHelper/setFocusMode',
      {'mode': mode.index},
    );
    return result ?? false;
  }

  Future<AVCaptureFocusMode> getFocusMode() async {
    supportedPlatforms();

    final index = await channel.invokeMethod<int>(
      '#VideoHelper/getFocusMode',
    );

    if (index == null || AVCaptureFocusMode.values.length < index) {
      throw 'getWhiteBalanceMode error: Mode not found';
    }

    final mode = AVCaptureFocusMode.values[index];

    return mode;
  }

  Future<bool> setFocusPoint(Point point) async {
    supportedPlatforms();

    final result = await channel.invokeMethod<bool>(
      '#VideoHelper/setFocusPoint',
      {
        'x': point.x,
        'y': point.y,
      },
    );
    return result ?? false;
  }

  Future<double> getFocusPointLockedWithLensPosition() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<double>(
      '#VideoHelper/getFocusPointLockedWithLensPosition',
    );
    return result ?? 0.0;
  }

  Future<bool> setFocusPointLockedWithLensPosition(double value) async {
    supportedPlatforms();

    final isSupported = await isLockingFocusWithCustomLensPositionSupported();

    if (!isSupported) {
      throw 'setFocusPointLockedWithLensPosition is not supported on this device '
          'use [isLockingFocusWithCustomLensPositionSupported] to check is Lens Position Supported '
          'on this device';
    }

    final result = await channel.invokeMethod<bool>(
      '#VideoHelper/setFocusPointLockedWithLensPosition',
      {
        'position': value,
      },
    );
    return result ?? false;
  }

  Future<List<AVCaptureFocusMode>> getSupportedFocusMode() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<List>(
      '#VideoHelper/getSupportedFocusMode',
    );

    final supportedMode = <AVCaptureFocusMode>[];

    for (final index in result ?? []) {
      supportedMode.add(AVCaptureFocusMode.values[index]);
    }

    return supportedMode;
  }
}
