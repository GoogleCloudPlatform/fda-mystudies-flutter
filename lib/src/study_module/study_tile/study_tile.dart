import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/widget_util.dart';
import '../../theme/fda_text_theme.dart';
import '../../route/route_name.dart';
import '../../user/user_data.dart';
import 'pb_study_enrollment_status.dart';
import 'pb_user_study_data.dart';
import 'pb_user_study_status.dart';

class StudyTile extends StatelessWidget {
  final PbUserStudyData userStudyData;

  const StudyTile(this.userStudyData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> studyData = [
      Text(userStudyData.userState.status.userStudyStatus.description,
          style: FDATextTheme.bodyTextStyle(context)),
      Text(userStudyData.study.title, style: _titleStyle(context))
    ];
    if (userStudyData.study.tagLine.isNotEmpty) {
      studyData.add(
          Text(userStudyData.study.tagLine, style: _tagLineStyle(context)));
    }
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Container(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(width: 2.0, color: dividerColor(context)))),
            child: Row(children: [
              Stack(children: [
                Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: Image.memory(
                                    Uri.parse(userStudyData.study.logo)
                                        .data!
                                        .contentAsBytes())
                                .image),
                        color: Colors.grey,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15))),
                    height: 80,
                    width: 80,
                    margin: const EdgeInsets.fromLTRB(0, 0, 10, 0)),
                Positioned(
                    bottom: 0,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15))),
                        width: 80,
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Wrap(
                            // runAlignment: WrapAlignment.center,
                            // alignment: WrapAlignment.center,
                            children: [
                              Icon(Icons.circle,
                                  color: userStudyData
                                      .study.status.studyStatus?.color,
                                  size: 12),
                              const SizedBox(width: 4),
                              Text(userStudyData.study.status,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 11))
                            ])))
              ]),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: studyData,
              )
            ])),
        onTap: () {
          UserData.shared.curStudyId = userStudyData.studyId;
          UserData.shared.curStudyName = userStudyData.study.title;
          UserData.shared.curStudyVersion = userStudyData.study.studyVersion;
          UserData.shared.curParticipantId =
              userStudyData.userState.participantId;
          UserData.shared.curSiteId = userStudyData.userState.siteId;
          UserData.shared.currentStudyTokenIdentifier =
              userStudyData.userState.hashedToken;
          UserData.shared.curStudyCompletion =
              userStudyData.userState.completion;
          UserData.shared.curStudyAdherence = userStudyData.userState.adherence;
          context.pushNamed(RouteName.studyIntro);
        });
  }

  TextStyle? _titleStyle(BuildContext context) {
    return Theme.of(context).textTheme.headline3?.apply(
        fontSizeFactor: 0.5,
        color: Theme.of(context).textTheme.bodyText1?.color);
  }

  TextStyle? _tagLineStyle(BuildContext context) {
    return Theme.of(context).textTheme.subtitle1;
  }
}
