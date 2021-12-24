class WhiteBalanceGains {
  const WhiteBalanceGains({
    required this.redGain,
    required this.greenGain,
    required this.blueGain,
  });

  factory WhiteBalanceGains.zero() => WhiteBalanceGains(
        greenGain: 1,
        redGain: 1,
        blueGain: 1,
      );

  final double redGain;
  final double greenGain;
  final double blueGain;

  @override
  String toString() => toJson().toString();

  Map<String, double> toJson() => {
        'redGain': redGain,
        'greenGain': greenGain,
        'blueGain': blueGain,
      };
}

class TemperatureAndTintWhiteBalanceGains {
  const TemperatureAndTintWhiteBalanceGains({
    required this.temperature,
    required this.tint,
  });

  factory TemperatureAndTintWhiteBalanceGains.zero() =>
      TemperatureAndTintWhiteBalanceGains(
        temperature: 1,
        tint: 1,
      );

  final double temperature;
  final double tint;

  @override
  String toString() => toJson().toString();

  Map<String, double> toJson() => {
        'temperature': temperature,
        'tint': tint,
      };

  TemperatureAndTintWhiteBalanceGains copyWith({
    double? temperature,
    double? tint,
  }) =>
      TemperatureAndTintWhiteBalanceGains(
        temperature: temperature ?? this.temperature,
        tint: tint ?? this.tint,
      );
}
