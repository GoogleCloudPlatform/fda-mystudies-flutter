class UserData {
  var emailId = '';
  var tempRegId = '';
  var code = '';
  var userId = '';
  var curStudyId = '';
  var curStudyVersion = '';
  var curSiteId = '';
  var currentStudyTokenIdentifier = '';
  var curParticipantId = '';
  var curStudyCompletion = 0;
  var curStudyAdherence = 0;

  UserData._init();
  static final UserData shared = UserData._init();
}
