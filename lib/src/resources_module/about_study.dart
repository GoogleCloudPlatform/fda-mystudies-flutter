import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/study_datastore_service.dart';
import 'package:fda_mystudies_spec/study_datastore_service/study_info.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../common/future_loading_page.dart';
import '../common/widget_util.dart';

class AboutStudy extends StatelessWidget {
  const AboutStudy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StudyDatastoreService studyDatastoreService =
        getIt<StudyDatastoreService>();
    return FutureLoadingPage(
        'About', studyDatastoreService.getStudyInfo('studyId', 'userId'),
        (context, snapshot) {
      var response = snapshot.data as StudyInfoResponse;
      var infoItem = response.infos.first;
      return CachedNetworkImage(
          imageUrl: infoItem.image,
          imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
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
                                    style: _titleStyle(context),
                                    textAlign: TextAlign.center),
                                const SizedBox(height: 20),
                                Text(infoItem.text,
                                    style: _subtitleStyle(context),
                                    textAlign: TextAlign.center)
                              ])))))));
    });
  }

  TextStyle _titleStyle(BuildContext context) {
    if (isPlatformIos(context)) {
      return CupertinoTheme.of(context)
          .textTheme
          .navLargeTitleTextStyle
          .apply(color: CupertinoColors.white);
    }
    return Theme.of(context).textTheme.headline3!.apply(color: Colors.white);
  }

  TextStyle _subtitleStyle(BuildContext context) {
    if (isPlatformIos(context)) {
      return CupertinoTheme.of(context)
          .textTheme
          .pickerTextStyle
          .apply(color: CupertinoColors.white);
    }
    return Theme.of(context).textTheme.headline6!.apply(color: Colors.white);
  }
}
