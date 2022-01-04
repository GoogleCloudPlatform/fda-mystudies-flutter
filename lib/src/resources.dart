import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'cupertino_widget/cupertino_list_tile.dart';
import 'cupertino_widget/licenses_page.dart';
import 'environment.dart';
import 'view_consent_pdf.dart';

class Resources extends StatelessWidget {
  const Resources({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkModeEnabled =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    if (Platform.isIOS) {
      return Container(
          decoration: BoxDecoration(
              color: isDarkModeEnabled
                  ? CupertinoColors.black
                  : CupertinoColors.extraLightBackgroundGray),
          child: ListView(
            children: [
              const CupertinoListTile(title: 'About the Study'),
              CupertinoListTile(
                  title: 'Software licenses',
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute<void>(
                        builder: (BuildContext context) =>
                            const LicensesPage()));
                  }),
              CupertinoListTile(
                  title: 'Consent PDF',
                  onTap: () {
                    // TODO (cg2092): Load consent pdf dynamically.
                    Navigator.of(context).push(CupertinoPageRoute<void>(
                        builder: (BuildContext context) => const ViewConsentPdf(
                            'JVBERi0xLjQKJcKlwrHDqwoxIDAgb2JqCjw8L1R5cGUvUGFnZXMvS2lkc1s0IDAgUl0vQ291bnQgMT4+CmVuZG9iagoyIDAgb2JqCjw8L0Rlc3RzPDw+Pj4+CmVuZG9iagozIDAgb2JqCjw8L1R5cGUvQ2F0YWxvZy9WZXJzaW9uLzEuNy9QYWdlcyAxIDAgUi9OYW1lcyAyIDAgUi9QYWdlTW9kZS9Vc2VOb25lPj4KZW5kb2JqCjQgMCBvYmoKPDwvVHlwZS9QYWdlL1Jlc291cmNlczw8L1Byb2NTZXRbL1BERi9UZXh0L0ltYWdlQi9JbWFnZUNdL0ZvbnQ8PC9GNiA2IDAgUj4+Pj4vUGFyZW50IDEgMCBSL01lZGlhQm94WzAgMCA1OTUuMjc1NTkgODQxLjg4OTc2XS9Db250ZW50cyA1IDAgUj4+CmVuZG9iago1IDAgb2JqCjw8L0ZpbHRlci9GbGF0ZURlY29kZS9MZW5ndGggMTMwPj5zdHJlYW0KeJwzUAgp4jJQAMGidC6nEAVTMz0zSyNLQwVzcxM9AyMTC1OFkBQFfTczBUMjhZA0oNqQZBBRzmVoAKSqQOxirmiNkNTiEs3YEC8F1xCQMRbGesZmFqQb45yfV5yah2ySobGhnjE5LkrJTy7NBZqlCDMM4s0gdy4DPTOFci4A6O85wAplbmRzdHJlYW0KZW5kb2JqCjYgMCBvYmoKPDwvVHlwZS9Gb250L1N1YnR5cGUvVHlwZTEvTmFtZS9GNi9FbmNvZGluZy9XaW5BbnNpRW5jb2RpbmcvQmFzZUZvbnQvSGVsdmV0aWNhPj4KZW5kb2JqCnhyZWYKMCA3CjAwMDAwMDAwMDAgNjU1MzUgZiAKMDAwMDAwMDAxNyAwMDAwMCBuIAowMDAwMDAwMDY4IDAwMDAwIG4gCjAwMDAwMDAwOTggMDAwMDAgbiAKMDAwMDAwMDE4NCAwMDAwMCBuIAowMDAwMDAwMzQxIDAwMDAwIG4gCjAwMDAwMDA1MzggMDAwMDAgbiAKdHJhaWxlcgo8PC9TaXplIDcvUm9vdCAzIDAgUi9JRFs8MzE2OGMyNGM2ZTFjNTNmYmEzMzI1ODhlMjM3YWUwMzQ4MGVkNWE5ZWNlOTMzMWNlMmI1OWQyNzk1MTIzNDY0OD48MzE2OGMyNGM2ZTFjNTNmYmEzMzI1ODhlMjM3YWUwMzQ4MGVkNWE5ZWNlOTMzMWNlMmI1OWQyNzk1MTIzNDY0OD5dPj4Kc3RhcnR4cmVmCjYzNAolJUVPRgo=')));
                  }),
              const CupertinoListTile(
                  title: 'Leave study',
                  subTitle: 'This will also delete your app account.',
                  showChevron: false),
              const SizedBox(height: 48),
              CupertinoListTile(
                  title: 'Environment',
                  subTitle: 'Select or configure an environment.',
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute<void>(
                        builder: (BuildContext context) =>
                            const Environment()));
                  })
            ],
          ));
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      children: [
        const ListTile(
            title: Text('About the study'),
            trailing: Icon(Icons.arrow_forward_ios_outlined, size: 16)),
        const Divider(),
        ListTile(
            title: const Text('Software licenses'),
            trailing: const Icon(Icons.arrow_forward_ios_outlined, size: 16),
            onTap: () => showLicensePage(
                context: context, applicationName: 'FDA MyStudies')),
        const Divider(),
        ListTile(
            title: const Text('Consent PDF'),
            trailing: const Icon(Icons.arrow_forward_ios_outlined, size: 16),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (BuildContext context) => const ViewConsentPdf(
                      'JVBERi0xLjQKJcKlwrHDqwoxIDAgb2JqCjw8L1R5cGUvUGFnZXMvS2lkc1s0IDAgUl0vQ291bnQgMT4+CmVuZG9iagoyIDAgb2JqCjw8L0Rlc3RzPDw+Pj4+CmVuZG9iagozIDAgb2JqCjw8L1R5cGUvQ2F0YWxvZy9WZXJzaW9uLzEuNy9QYWdlcyAxIDAgUi9OYW1lcyAyIDAgUi9QYWdlTW9kZS9Vc2VOb25lPj4KZW5kb2JqCjQgMCBvYmoKPDwvVHlwZS9QYWdlL1Jlc291cmNlczw8L1Byb2NTZXRbL1BERi9UZXh0L0ltYWdlQi9JbWFnZUNdL0ZvbnQ8PC9GNiA2IDAgUj4+Pj4vUGFyZW50IDEgMCBSL01lZGlhQm94WzAgMCA1OTUuMjc1NTkgODQxLjg4OTc2XS9Db250ZW50cyA1IDAgUj4+CmVuZG9iago1IDAgb2JqCjw8L0ZpbHRlci9GbGF0ZURlY29kZS9MZW5ndGggMTMwPj5zdHJlYW0KeJwzUAgp4jJQAMGidC6nEAVTMz0zSyNLQwVzcxM9AyMTC1OFkBQFfTczBUMjhZA0oNqQZBBRzmVoAKSqQOxirmiNkNTiEs3YEC8F1xCQMRbGesZmFqQb45yfV5yah2ySobGhnjE5LkrJTy7NBZqlCDMM4s0gdy4DPTOFci4A6O85wAplbmRzdHJlYW0KZW5kb2JqCjYgMCBvYmoKPDwvVHlwZS9Gb250L1N1YnR5cGUvVHlwZTEvTmFtZS9GNi9FbmNvZGluZy9XaW5BbnNpRW5jb2RpbmcvQmFzZUZvbnQvSGVsdmV0aWNhPj4KZW5kb2JqCnhyZWYKMCA3CjAwMDAwMDAwMDAgNjU1MzUgZiAKMDAwMDAwMDAxNyAwMDAwMCBuIAowMDAwMDAwMDY4IDAwMDAwIG4gCjAwMDAwMDAwOTggMDAwMDAgbiAKMDAwMDAwMDE4NCAwMDAwMCBuIAowMDAwMDAwMzQxIDAwMDAwIG4gCjAwMDAwMDA1MzggMDAwMDAgbiAKdHJhaWxlcgo8PC9TaXplIDcvUm9vdCAzIDAgUi9JRFs8MzE2OGMyNGM2ZTFjNTNmYmEzMzI1ODhlMjM3YWUwMzQ4MGVkNWE5ZWNlOTMzMWNlMmI1OWQyNzk1MTIzNDY0OD48MzE2OGMyNGM2ZTFjNTNmYmEzMzI1ODhlMjM3YWUwMzQ4MGVkNWE5ZWNlOTMzMWNlMmI1OWQyNzk1MTIzNDY0OD5dPj4Kc3RhcnR4cmVmCjYzNAolJUVPRgo=')));
            }),
        const Divider(),
        const ListTile(
            title: Text('Leave study'),
            subtitle: Text('This will also delete your app account.')),
        const Divider(),
        const SizedBox(height: 48),
        const Divider(),
        ListTile(
            title: const Text('Environment'),
            subtitle: const Text('Select or configure an environment.'),
            trailing: const Icon(Icons.arrow_forward_ios_outlined, size: 16),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (BuildContext context) => const Environment()));
            })
      ],
    );
  }
}
