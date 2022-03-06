import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/study_datastore_service.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_study_list.pb.dart';
import 'package:flutter/widgets.dart';

import '../../main.dart';
import '../common/future_loading_page.dart';
import '../study_module/study_tile/study_tile.dart';

class GatewayHome extends StatelessWidget {
  const GatewayHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var studyDatastoreService = getIt<StudyDatastoreService>();
    return FutureLoadingPage(
        curConfig.appName, studyDatastoreService.getStudyList(''),
        (context, snapshot) {
      var studies = (snapshot.data as GetStudyListResponse).studies;
      return ListView(children: studies.map((e) => StudyTile(e)).toList());
    });
  }
}
