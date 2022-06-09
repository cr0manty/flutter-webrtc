import 'package:flutter_webrtc/flutter_webrtc.dart';

class CaptureDeviceInfo {
  const CaptureDeviceInfo({
    required this.deviceId,
    required this.type,
  });

  factory CaptureDeviceInfo.fromMap(Map<dynamic, dynamic> map) => CaptureDeviceInfo(
    deviceId: map['deviceId'] as String,
    type: AVCaptureDeviceTypeExtension.typeByName(map['deviceType']),
  );

  final String deviceId;
  final AVCaptureDeviceType type;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is CaptureDeviceInfo &&
              runtimeType == other.runtimeType &&
              deviceId == other.deviceId &&
              type == other.type);

  @override
  int get hashCode => deviceId.hashCode ^ type.hashCode;

  @override
  String toString() => 'DeviceInfo{ deviceId: $deviceId, type: $type,}';

  CaptureDeviceInfo copyWith({
    String? deviceId,
    AVCaptureDeviceType? type,
  }) =>
      CaptureDeviceInfo(
        deviceId: deviceId ?? this.deviceId,
        type: type ?? this.type,
      );

  Map<String, dynamic> toMap() => {
    'deviceId': deviceId,
    'deviceType': type,
  };

  static bool canBeParsed(dynamic data) {
    if (data == null) return false;

    if (data is! Map) return false;

    if (!data.containsKey('deviceId') && !data.containsKey('deviceType')) {
      return false;
    }

    return true;
  }
}

