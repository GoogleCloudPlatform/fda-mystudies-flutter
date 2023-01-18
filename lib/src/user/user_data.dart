class UserData {
  var emailId = '';
  var tempRegId = '';
  var code = '';
  var userId = '';
  var authToken = '';
  var curStudyId = '';
  var curStudyName = '';
  var curStudyVersion = '';
  var curSiteId = '';
  var currentStudyTokenIdentifier = '';
  var curParticipantId = '';
  var curStudyCompletion = 0;
  var curStudyAdherence = 0;
  var activityId = '';
  var activityVersion = '';

  UserData._init();
  static final UserData shared = UserData._init();
}
