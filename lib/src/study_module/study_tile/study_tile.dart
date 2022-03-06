import 'package:fda_mystudies_spec/study_datastore_service/get_study_list.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../common/widget_util.dart';
import 'pb_study_status.dart';

class StudyTile extends StatelessWidget {
  final GetStudyListResponse_Study study;

  const StudyTile(this.study, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> studyData = [Text(study.title, style: _titleStyle(context))];
    if (study.tagLine.isNotEmpty) {
      studyData.add(Text(study.tagLine, style: _tagLineStyle(context)));
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
                            image: Image.memory(Uri.parse(study.logo)
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
                                  color: study.status.studyStatus?.color,
                                  size: 12),
                              const SizedBox(width: 4),
                              Text(study.status,
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
        onTap: () {});
  }

  TextStyle? _titleStyle(BuildContext context) {
    if (isPlatformIos(context)) {
      return CupertinoTheme.of(context)
          .textTheme
          .navLargeTitleTextStyle
          .apply(fontSizeFactor: 0.5);
    }
    return Theme.of(context).textTheme.headline3?.apply(
        fontSizeFactor: 0.5,
        color: Theme.of(context).textTheme.bodyText1?.color);
  }

  TextStyle? _tagLineStyle(BuildContext context) {
    if (isPlatformIos(context)) {
      return CupertinoTheme.of(context)
          .textTheme
          .pickerTextStyle
          .apply(fontSizeFactor: 0.6);
    }
    return Theme.of(context).textTheme.subtitle1;
  }
}
