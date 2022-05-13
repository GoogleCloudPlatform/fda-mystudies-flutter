import 'package:fda_mystudies/src/theme/fda_text_theme.dart';
import 'package:fda_mystudies/src/widget/fda_scaffold.dart';
import 'package:flutter/widgets.dart';

class EligibilityTest extends StatelessWidget {
  const EligibilityTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FDAScaffold(
        child: SafeArea(
            child: Center(
                child: Text('TEST',
                    style: FDATextTheme.headerTextStyle(context)))));
  }
}
