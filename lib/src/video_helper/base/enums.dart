enum AVCaptureExposureMode {
  locked,
  auto_expose,
  continuous_auto_exposure,
  custom,
}

enum AVCaptureWhiteBalanceMode {
  locked,
  auto_white_balance,
  continuous_auto_white_balance,
}

enum AVCaptureFocusMode {
  locked,
  auto_focus,
  continuous_auto_focus,
}

enum AVCaptureDeviceType {
  wide_angle,
  ultra_wide,
  telephoto,
}

extension AVCaptureDeviceTypeExtension on AVCaptureDeviceType {
  String get nativeName {
    switch (this) {
      case AVCaptureDeviceType.telephoto:
        return 'AVCaptureDeviceTypeBuiltInTelephotoCamera';
      case AVCaptureDeviceType.ultra_wide:
        return 'AVCaptureDeviceTypeBuiltInUltraWideCamera';
      default:
        return 'AVCaptureDeviceTypeBuiltInWideAngleCamera';
    }
  }

  static AVCaptureDeviceType typeByName(String name) {
    switch (name) {
      case 'AVCaptureDeviceTypeBuiltInTelephotoCamera':
        return AVCaptureDeviceType.telephoto;
      case 'AVCaptureDeviceTypeBuiltInUltraWideCamera':
        return AVCaptureDeviceType.ultra_wide;
      default:
        return AVCaptureDeviceType.wide_angle;
    }
  }
}
