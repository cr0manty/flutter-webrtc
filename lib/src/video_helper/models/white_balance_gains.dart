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

  factory WhiteBalanceGains.fromJson(
    Map<dynamic, dynamic> json,
  ) =>
      WhiteBalanceGains(
        redGain: json['redGain']!,
        greenGain: json['greenGain']!,
        blueGain: json['blueGain']!,
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

  WhiteBalanceGains copyWith({
    double? red,
    double? green,
    double? blue,
  }) =>
      WhiteBalanceGains(
        redGain: red ?? redGain,
        blueGain: blue ?? blueGain,
        greenGain: green ?? greenGain,
      );
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

  factory TemperatureAndTintWhiteBalanceGains.fromJson(
    Map<dynamic, dynamic> json,
  ) =>
      TemperatureAndTintWhiteBalanceGains(
        temperature: json['temperature']!,
        tint: json['tint']!,
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
