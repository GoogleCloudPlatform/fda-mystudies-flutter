import 'dart:developer' as developer;
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:fitbitter/fitbitter.dart';

import '../../config/app_config.dart';
import '../register_and_login/auth_utils.dart';
import '../screen/fitbit_screen.dart';

class FitbitScreenController extends StatefulWidget {
  const FitbitScreenController({Key? key}) : super(key: key);

  @override
  State<FitbitScreenController> createState() =>
      _FitbitScreenControllerState();
}

class _FitbitScreenControllerState extends State<FitbitScreenController> {
  var _userId = '';
  var _accessToken = '';
  var _refreshToken = '';
  var _lastSync = DateTime.parse('2024-02-26');

  @override
  Widget build(BuildContext context) {
    // If connected, fetch data, else connect
    return FitbitScreen(
        appName: AppConfig.shared.currentConfig.appName,
        orgName: AppConfig.shared.currentConfig.organization,
        connectFitbit: _connectFitbit);
  }

  void _connectFitbit() {
    //TODO(): Add fetch from secure db & check for token validity
    if (_accessToken == '') {
      var authenticationService = getIt<AuthenticationService>();
      authenticationService.fitbitSignIn().then((value) {
          if (value != null) {
            _userId = value.userID;
            _accessToken = value.fitbitAccessToken;
            _refreshToken = value.fitbitRefreshToken;
            AuthUtils.saveFitbitUserToDB(_accessToken, _refreshToken, _userId);
            developer.log('Fitbit Credentials saved');
          } else {
            developer.log('No FitBit Credentials recieved');
          }
      });
    } 
    _fetchData();
  }

  void _fetchData() {
    var date = DateTime.now();
    //TODO(): Add Intraday data
    var daysSinceSync = _lastSync.difference(date).inDays;
    if (daysSinceSync > 0) {
      var clientId = AppConfig.shared.currentConfig.fitbitClientId;
      var clientSecret = AppConfig.shared.currentConfig.fitbitClientSecret;
      var credentials = FitbitCredentials(userID: _userId,
                                          fitbitAccessToken: _accessToken, fitbitRefreshToken: _refreshToken);

      // Activity Data
      for (int day in Iterable.generate(daysSinceSync)) {
        FitbitActivityDataManager fitbitActivityDataManager = FitbitActivityDataManager(
              clientID: clientId, clientSecret: clientSecret);
        FitbitActivityAPIURL fitbitActivityAPIURL = FitbitActivityAPIURL.day(
                                          date: _lastSync.add(Duration(days: day)),
                                          fitbitCredentials: credentials,
                                        );
        _fetchAndConvertData(fitbitActivityDataManager, fitbitActivityAPIURL);
      }

      // Activity Timeseries Data
      FitbitActivityTimeseriesDataManager fitbitActivityTSDataManager = FitbitActivityTimeseriesDataManager(
            clientID: clientId, clientSecret: clientSecret);
      for (Resource r in Resource.values) {
        FitbitActivityTimeseriesAPIURL fitbitActivityTSAPIURL = FitbitActivityTimeseriesAPIURL.dateRangeWithResource(
                                        startDate: _lastSync,
                                        endDate: DateTime.now(),
                                        fitbitCredentials: credentials,
                                        resource: r
                                      );
        _fetchAndConvertData(fitbitActivityTSDataManager, fitbitActivityTSAPIURL);
      }
      
      // Breathing Rate Data
      FitbitBreathingRateDataManager fitbitBRDataManager = FitbitBreathingRateDataManager(
            clientID: clientId, clientSecret: clientSecret);
      FitbitBreathingRateAPIURL fitbitBRAPIURL = FitbitBreathingRateAPIURL.dateRange(
                                        startDate: _lastSync, endDate: DateTime.now(),
                                        fitbitCredentials: credentials,
                                      );
      _fetchAndConvertData(fitbitBRDataManager, fitbitBRAPIURL);

      // Cardio Fitness Score Data
      FitbitCardioScoreDataManager fitbitCSDataManager = FitbitCardioScoreDataManager(
            clientID: clientId, clientSecret: clientSecret);
      FitbitCardioScoreAPIURL fitbitCSAPIURL = FitbitCardioScoreAPIURL.dateRange(
                                        startDate: _lastSync, endDate: DateTime.now(),
                                        fitbitCredentials: credentials,
                                      );
      _fetchAndConvertData(fitbitCSDataManager, fitbitCSAPIURL);

      // Heart Data
      FitbitHeartDataManager fitbitHeartRateDataManager = FitbitHeartDataManager(
            clientID: clientId, clientSecret: clientSecret);
      FitbitHeartRateAPIURL fitbitHeartRateAPIURL = FitbitHeartRateAPIURL.dateRange(
                                        startDate: _lastSync, endDate: DateTime.now(),
                                        fitbitCredentials: credentials,
                                      );
      _fetchAndConvertData(fitbitHeartRateDataManager, fitbitHeartRateAPIURL);

      // Heart Rate Variability Data
      FitbitHeartRateVariabilityDataManager fitbitHRVDataManager = FitbitHeartRateVariabilityDataManager(
            clientID: clientId, clientSecret: clientSecret);
      FitbitHeartRateVariabilityAPIURL fitbitHRVAPIURL = FitbitHeartRateVariabilityAPIURL.dateRange(
                                        startDate: _lastSync, endDate: DateTime.now(),
                                        fitbitCredentials: credentials,
                                      );
      _fetchAndConvertData(fitbitHRVDataManager, fitbitHRVAPIURL);

      // Sleep Data
      FitbitSleepDataManager fitbitSleepDataManager = FitbitSleepDataManager(
            clientID: clientId, clientSecret: clientSecret);
      FitbitSleepAPIURL fitbitSleepAPIURL = FitbitSleepAPIURL.dateRange(
                                        startDate: _lastSync, endDate: DateTime.now(),
                                        fitbitCredentials: credentials,
                                      );
      _fetchAndConvertData(fitbitSleepDataManager, fitbitSleepAPIURL);

      // SpO2 Data
      FitbitSpO2DataManager fitbitSpo2DataManager = FitbitSpO2DataManager(
            clientID: clientId, clientSecret: clientSecret);
      FitbitSpO2APIURL fitbitSpo2APIURL = FitbitSpO2APIURL.dateRange(
                                        startDate: _lastSync, endDate: DateTime.now(),
                                        fitbitCredentials: credentials,
                                      );
      _fetchAndConvertData(fitbitSpo2DataManager, fitbitSpo2APIURL);

      // Temperature (Skin) Data
      FitbitTemperatureSkinDataManager fitbitTempDataManager = FitbitTemperatureSkinDataManager(
            clientID: clientId, clientSecret: clientSecret);
      FitbitTemperatureSkinAPIURL fitbitTempAPIURL = FitbitTemperatureSkinAPIURL.dateRange(
                                        startDate: _lastSync, endDate: DateTime.now(),
                                        fitbitCredentials: credentials,
                                      );
      _fetchAndConvertData(fitbitTempDataManager, fitbitTempAPIURL);
    }
    _lastSync = date;
  }

  void _fetchAndConvertData(FitbitDataManager dataManager, FitbitAPIURL apiurl) {
    //TODO(): Save data to db
    dataManager.fetch(apiurl).then((value) {
      // Save and display data
      for (final i in value){
        developer.log(i.toJson().toString());
      }
    });
  }
  
}
