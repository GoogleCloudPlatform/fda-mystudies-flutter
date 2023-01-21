import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/material.dart';

class ActivityStepProvider extends ChangeNotifier {
  List<ActivityStep>? _steps;

  ActivityStepProvider({List<ActivityStep>? steps}) {
    _steps = steps;
  }

  void update(List<ActivityStep> steps) {
    _steps = steps;
    notifyListeners();
  }

  List<ActivityStep> get steps => _steps ?? [];
}
