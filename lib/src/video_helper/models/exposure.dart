class ExposureDuration {
  const ExposureDuration({
    required this.value,
    required this.timescale,
  });

  factory ExposureDuration.fromJson(Map<dynamic, dynamic> json) =>
      ExposureDuration(
        value: json['value'],
        timescale: json['timescale'],
      );

  final int value;
  final int timescale;

  double get seconds => value / timescale;

  @override
  String toString() => seconds.toStringAsFixed(
        2,
      );

  Map<dynamic, dynamic> toJson() => {
        'value': value,
        'timescale': timescale,
      };
}
