import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../flutter_webrtc.dart';

class Helper {
  static final _deviceChangedChannel = const EventChannel(
    'deviceChanged.dataChannel',
  );

  static Stream<CaptureDeviceInfo>? _deviceChangedStream;

  static Stream<CaptureDeviceInfo> get deviceIdChangedStream {
    _deviceChangedStream ??=
        _deviceChangedChannel.receiveBroadcastStream().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          if (!CaptureDeviceInfo.canBeParsed(data)) {
            return;
          }

          sink.add(
            CaptureDeviceInfo.fromMap(data),
          );
        },
      ),
    );
    return _deviceChangedStream!;
  }

  static Future<List<MediaDeviceInfo>> enumerateDevices(String type) async {
    var devices = await navigator.mediaDevices.enumerateDevices();
    return devices.where((d) => d.kind == type).toList();
  }

  /// Return the available cameras
  ///
  /// Note: Make sure to call this gettet after
  /// navigator.mediaDevices.getUserMedia(), otherwise the devices will not be
  /// listed.
  static Future<List<MediaDeviceInfo>> get cameras =>
      enumerateDevices('videoinput');

  /// Return the available audiooutputs
  ///
  /// Note: Make sure to call this gettet after
  /// navigator.mediaDevices.getUserMedia(), otherwise the devices will not be
  /// listed.
  static Future<List<MediaDeviceInfo>> get audiooutputs =>
      enumerateDevices('audiooutput');

  /// To select a a specific camera, you need to set constraints
  /// eg.
  /// constraints = {
  ///      'audio': true,
  ///      'video': {
  ///          'deviceId': Helper.cameras[0].deviceId,
  ///          }
  ///      };
  ///
  /// Helper.openCamera(constraints);
  ///
  static Future<MediaStream> openCamera(Map<String, dynamic> mediaConstraints) {
    return navigator.mediaDevices.getUserMedia(mediaConstraints);
  }

  /// For web implementation, make sure to pass the target deviceId
  static Future<bool> switchCamera(
    MediaStreamTrack track, {
    String? deviceId,
    MediaStream? stream,
  }) async {
    if (track.kind != 'video') {
      throw 'The is not a video track => $track';
    }

    if (!kIsWeb) {
      return WebRTC.invokeMethod(
        'mediaStreamTrackSwitchCamera',
        <String, dynamic>{
          'trackId': track.id,
        },
      ).then((value) => value ?? false);
    }

    if (deviceId == null) throw 'You need to specify the deviceId';
    if (stream == null) throw 'You need to specify the stream';

    var _cameras = await cameras;
    if (!_cameras.any((e) => e.deviceId == deviceId)) {
      throw 'The provided deviceId is not available, make sure to retreive the deviceId from Helper.cammeras()';
    }

    // stop only video tracks
    // so that we can recapture video track
    stream.getVideoTracks().forEach((track) {
      track.stop();
      stream.removeTrack(track);
    });

    var mediaConstraints = {
      'audio': false, // NO need to capture audio again
      'video': {'deviceId': deviceId}
    };

    var _stream = await openCamera(mediaConstraints);
    var _cameraTrack = _stream.getVideoTracks()[0];

    await stream.addTrack(_cameraTrack, addToNative: true);

    return Future.value(true);
  }

  static Future<void> setVolume(double volume, MediaStreamTrack track) async {
    if (track.kind == 'audio') {
      if (kIsWeb) {
        final constraints = track.getConstraints();
        constraints['volume'] = volume;
        await track.applyConstraints(constraints);
      } else {
        await WebRTC.invokeMethod(
          'setVolume',
          <String, dynamic>{'trackId': track.id, 'volume': volume},
        );
      }
    }

    return Future.value();
  }

  static void setMicrophoneMute(bool mute, MediaStreamTrack track) async {
    if (track.kind != 'audio') {
      throw 'The is not an audio track => $track';
    }

    if (!kIsWeb) {
      try {
        await WebRTC.invokeMethod(
          'setMicrophoneMute',
          <String, dynamic>{'trackId': track.id, 'mute': mute},
        );
      } on PlatformException catch (e) {
        throw 'Unable to MediaStreamTrack::setMicrophoneMute: ${e.message}';
      }
    }
    track.enabled = !mute;
  }

  static Future<void> setLandscapeMode({
    int? textureId,
    bool isLandscapeSupported = false,
  }) async {
    if (kIsWeb || WebRTC.platformIsAndroid) return;

    if (textureId == null) throw 'Call initialize before setting the stream';

    await WebRTC.invokeMethod('setLandscapeMode', <String, dynamic>{
      'textureId': textureId,
      'landscapeMode': isLandscapeSupported
    });
  }

  static Future<AVCaptureDeviceType> getCurrentDeviceType() async {
    final result = await WebRTC.invokeMethod(
      'getCurrentDeviceType',
    );

    if (result == null) {
      throw 'Can not detect AVCaptureDeviceType';
    }

    final type = AVCaptureDeviceTypeExtension.typeByName(result);

    return type;
  }

  static Future<bool> setCustomCameraDevice(String deviceId) async {
    final result = await WebRTC.invokeMethod<bool>('setCustomCameraDevice', {
      'uniqueID': deviceId,
    });

    return result ?? false;
  }

  static Future<String?> currentDeviceId(
    String? trackId,
  ) =>
      WebRTC.invokeMethod<String>('getCurrentDeviceId', {
        'trackId': trackId,
      });

  static Future<bool> setZoom(
    double zoom,
    String? trackId,
  ) async {
    final result = await WebRTC.invokeMethod<bool>('setCameraZoom', {
      'trackId': trackId,
      'zoom': zoom,
    }) ;

    return result ?? false;
  }

}
