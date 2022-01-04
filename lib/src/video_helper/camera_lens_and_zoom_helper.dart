import 'dart:async';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc/src/video_helper/base/base_video_helper.dart';

class CameraLensAndZoomHelper extends BaseVideoHelper {
  // lens switching
  Future<int> lensAmount() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<int>(
      '#VideoHelper/getCameraLensAmount',
    );
    return result ?? 0;
  }

  Future<List<AVCaptureDeviceType>> getSupportedCameraLens() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<List>(
      '#VideoHelper/getSupportedCameraLens',
    );

    final supportedLens = <AVCaptureDeviceType>[];

    for (final name in result ?? []) {
      supportedLens.add(AVCaptureDeviceTypeExtension.typeByName(name));
    }

    return supportedLens;
  }

  Future<bool> setCameraByName(String name) async {
    supportedPlatforms();

    final result = await channel.invokeMethod<bool>(
      '#VideoHelper/setCameraByName',
      {'nativeName': name},
    );

    return result ?? false;
  }

  Future<AVCaptureDeviceType> getCurrentDeviceType() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<String>(
      '#VideoHelper/getCurrentDeviceType',
    );

    if (result == null) {
      throw 'Can not detect AVCaptureDeviceType';
    }

    final type = AVCaptureDeviceTypeExtension.typeByName(result);

    return type;
  }

  /// zoom
  Future<bool> setZoom(double zoom, String trackId) async {
    supportedPlatforms(allowAndroid: true);

    final result = await channel.invokeMethod<bool>(
      '#VideoHelper/changeZoom',
      <String, dynamic>{
        'zoom': zoom,
        'trackId': trackId,
      },
    );

    return result ?? false;
  }

  Future<double> maxZoomFactor() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<double>(
      '#VideoHelper/getMaxZoomFactor',
    );

    return result ?? 2.0;
  }

  Future<double> minZoomFactor() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<double>(
      '#VideoHelper/getMinZoomFactor',
    );

    return result ?? 1.0;
  }

  Future<double> currentZoomFactor() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<double>(
      '#VideoHelper/getZoomFactor',
    );

    return result ?? 1.0;
  }

  Future<List<AVCaptureVideoStabilizationMode>>
      getSupportedStabilizationMode() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<List>(
      '#VideoHelper/getSupportedStabilizationMode',
    );

    final supportedLens = <AVCaptureVideoStabilizationMode>[];

    for (final name in result ?? []) {
      supportedLens
          .add(AVCaptureVideoStabilizationModeExtension.typeByValue(name));
    }

    return supportedLens;
  }

  Future<bool> setPreferredStabilizationMode(
    AVCaptureVideoStabilizationMode mode,
  ) async {
    supportedPlatforms();

    final result = await channel.invokeMethod<bool>(
      '#VideoHelper/setPreferredStabilizationMode',
      {'mode': mode.value},
    );

    return result ?? false;
  }

  Future<AVCaptureVideoStabilizationMode>
      getPreferredStabilizationMode() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<int>(
      '#VideoHelper/getPreferredStabilizationMode',
    );

    if (result == null) {
      throw 'Can not detect AVCaptureVideoStabilizationMode';
    }

    final type = AVCaptureVideoStabilizationModeExtension.typeByValue(
      result,
    );

    return type;
  }

  Future<AVCaptureVideoStabilizationMode> getActiveStabilizationMode() async {
    supportedPlatforms();

    final result = await channel.invokeMethod<int>(
      '#VideoHelper/getActiveStabilizationMode',
    );

    if (result == null) {
      throw 'Can not detect active AVCaptureVideoStabilizationMode';
    }

    final type = AVCaptureVideoStabilizationModeExtension.typeByValue(
      result,
    );

    return type;
  }
}
