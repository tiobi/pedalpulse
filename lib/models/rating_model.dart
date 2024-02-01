class RatingModel {
  final num overall;
  final num accessibility;
  final num sound;
  final num buildQuality;
  final num versatility;

  RatingModel({
    required this.overall,
    required this.accessibility,
    required this.sound,
    required this.buildQuality,
    required this.versatility,
  });

  // to and from map
  Map<String, dynamic> toMap() {
    return {
      'overall': overall,
      'accessibility': accessibility,
      'sound': sound,
      'buildQuality': buildQuality,
      'versatility': versatility,
    };
  }

  factory RatingModel.fromMap(Map<String, dynamic> map) {
    return RatingModel(
      overall: map['overall'],
      accessibility: map['accessibility'],
      sound: map['sound'],
      buildQuality: map['buildQuality'],
      versatility: map['versatility'],
    );
  }
}
