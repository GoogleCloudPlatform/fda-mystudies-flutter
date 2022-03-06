class UserData {
  var emailId = '';
  var tempRegId = '';
  var code = '';
  var userId = '';
  var studyId = '';
  var participantId = '';

  UserData._init();
  static final UserData shared = UserData._init();
}
