class UserData {
  var emailId = '';
  var tempRegId = '';
  var code = '';
  var userId = '';
  var curStudyId = '';
  var curParticipantId = '';

  UserData._init();
  static final UserData shared = UserData._init();
}
