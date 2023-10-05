import 'package:realm/realm.dart';

import 'db_user.dart';

class RealmConfig {
  static final config = Configuration.local([DBUser.schema]);
}
