import 'package:fda_mystudies_spec/study_datastore_service/get_study_dashboard.pb.dart';
import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  GetStudyDashboardResponse_Dashboard? _dashboard;

  DashboardProvider({GetStudyDashboardResponse_Dashboard? dashboard}) {
    _dashboard = GetStudyDashboardResponse_Dashboard();
  }

  void update(GetStudyDashboardResponse_Dashboard dashboard) {
    _dashboard = dashboard;
    notifyListeners();
  }

  GetStudyDashboardResponse_Dashboard get dashboard =>
      _dashboard ?? GetStudyDashboardResponse_Dashboard();
}
