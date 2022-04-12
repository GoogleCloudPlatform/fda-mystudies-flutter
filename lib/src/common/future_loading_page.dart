import 'package:fda_mystudies/src/common/home_scaffold.dart';
import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'widget_util.dart';
import 'common_error_widget.dart';

class FutureLoadingPage {
  static Widget build(BuildContext context,
      {required String scaffoldTitle,
      required Future<Object>? future,
      required Widget Function(BuildContext, AsyncSnapshot<Object>) builder,
      bool wrapInScaffold = true,
      bool showDrawer = false}) {
    return _wrapWidgetInScaffold(
        context,
        scaffoldTitle,
        showDrawer,
        FutureBuilder<Object>(
            future: future,
            builder:
                (BuildContext buildContext, AsyncSnapshot<Object> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return isPlatformIos(context)
                      ? const CupertinoPageScaffold(
                          child: Center(child: CupertinoActivityIndicator()))
                      : const Scaffold(
                          body: Center(child: CircularProgressIndicator()));
                default:
                  if (snapshot.hasError) {
                    return CommonErrorWidget(snapshot.error.toString());
                  } else if (snapshot.data is CommonErrorResponse) {
                    var errorResponse =
                        (snapshot.data as CommonErrorResponse).errorDescription;
                    return CommonErrorWidget(errorResponse);
                  } else {
                    return builder(buildContext, snapshot);
                  }
              }
            }),
        wrapInScaffold);
  }

  static Widget _wrapWidgetInScaffold(BuildContext context,
      String scaffoldTitle, bool showDrawer, Widget widget, bool shouldWrap) {
    if (shouldWrap) {
      return HomeScaffold(
          child: widget, title: scaffoldTitle, showDrawer: showDrawer);
    }
    return widget;
  }
}
