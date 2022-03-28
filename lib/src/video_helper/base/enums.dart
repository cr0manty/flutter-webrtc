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

enum AVCaptureVideoStabilizationMode {
  off,
  standard,
  cinematic,
  cinematic_extended,
  auto,
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

  bool get isDefaultCamera => this == AVCaptureDeviceType.wide_angle;
}

extension AVCaptureVideoStabilizationModeExtension
    on AVCaptureVideoStabilizationMode {
  int get value {
    switch (this) {
      case AVCaptureVideoStabilizationMode.auto:
        return -1;
      case AVCaptureVideoStabilizationMode.off:
        return 0;
      case AVCaptureVideoStabilizationMode.standard:
        return 1;
      case AVCaptureVideoStabilizationMode.cinematic:
        return 2;
      case AVCaptureVideoStabilizationMode.cinematic_extended:
        return 3;
    }
  }

  static AVCaptureVideoStabilizationMode typeByValue(int value) {
    assert(
      value >= -1 && value <= 3,
      'Unsupported AVCaptureVideoStabilizationMode',
    );

    switch (value) {
      case -1:
        return AVCaptureVideoStabilizationMode.auto;
      case 0:
        return AVCaptureVideoStabilizationMode.off;
      case 1:
        return AVCaptureVideoStabilizationMode.standard;
      case 2:
        return AVCaptureVideoStabilizationMode.cinematic;
      case 3:
        return AVCaptureVideoStabilizationMode.cinematic_extended;
    }
    return AVCaptureVideoStabilizationMode.off;
  }

  bool get isCinematic =>
      this == AVCaptureVideoStabilizationMode.cinematic ||
      this == AVCaptureVideoStabilizationMode.cinematic_extended;
}
