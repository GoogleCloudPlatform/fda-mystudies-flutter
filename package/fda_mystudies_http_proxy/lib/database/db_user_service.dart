import 'package:realm/realm.dart';

import 'db_user.dart';
import 'realm_config.dart';

class DBUserService {
  late Realm _realm;

  static final shared = DBUserService._init();

  DBUserService._init() {
    _realm = Realm(RealmConfig.config);
  }

  Future<void> upsertUser(DBUser user) {
    return _realm.writeAsync(() {
      _realm.add(user, update: true);
    });
  }

  DBUser? getUser(String userId) {
    final users = _realm.query<DBUser>("userId == '$userId'");
    if (users.isEmpty) {
      return null;
    }
    return users.first;
  }
}
