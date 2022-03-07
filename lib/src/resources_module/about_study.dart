import 'dart:ui';

import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/study_datastore_service.dart';
import 'package:fda_mystudies_spec/study_datastore_service/study_info.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../common/future_loading_page.dart';
import '../theme/fda_text_theme.dart';
import '../user/user_data.dart';

class AboutStudy extends StatelessWidget {
  const AboutStudy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StudyDatastoreService studyDatastoreService =
        getIt<StudyDatastoreService>();
    return FutureLoadingPage(
        'About',
        studyDatastoreService.getStudyInfo(
            UserData.shared.curStudyId, UserData.shared.userId),
        (context, snapshot) {
      var response = snapshot.data as StudyInfoResponse;
      var infoItem = response.infos.first;
      var isDarkModeEnabled =
          MediaQuery.of(context).platformBrightness == Brightness.dark;
      var blendMode = isDarkModeEnabled ? BlendMode.darken : BlendMode.lighten;
      var blendColor = isDarkModeEnabled ? Colors.black : Colors.white;
      return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: Image.memory(
                        Uri.parse(infoItem.image).data!.contentAsBytes())
                    .image,
                colorFilter:
                    ColorFilter.mode(blendColor.withOpacity(0.5), blendMode),
                fit: BoxFit.cover),
          ),
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                  color: Colors.black.withOpacity(0.1),
                  child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                            Text(infoItem.title,
                                style: FDATextTheme.headerTextStyle(context),
                                textAlign: TextAlign.center),
                            const SizedBox(height: 20),
                            Text(infoItem.text,
                                style: FDATextTheme.bodyTextStyle(context),
                                textAlign: TextAlign.center)
                          ]))))));
    });
  }
}
