import 'package:flutter/material.dart';

import '../../domain/entities/review_entity.dart';

class PedalReviewProvider extends ChangeNotifier {
  final List<ReviewEntity> _pedalReviews = [];
  List<ReviewEntity> get pedalReviews => _pedalReviews;
}
