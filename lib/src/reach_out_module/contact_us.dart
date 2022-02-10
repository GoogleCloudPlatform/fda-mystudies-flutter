import 'package:flutter/widgets.dart';

import '../common/home_scaffold.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    const pageTitle = 'Contact us';
    return HomeScaffold(
        child: Container(), title: pageTitle, showDrawer: false);
  }
}
