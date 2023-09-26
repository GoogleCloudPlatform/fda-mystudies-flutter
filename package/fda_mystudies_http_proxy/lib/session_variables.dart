class SessionVariable {
  var currentUserId = '';
  var currentStudyId = '';
  var currentActivityId = '';

  static final SessionVariable shared = SessionVariable._init();

  SessionVariable._init();
}
