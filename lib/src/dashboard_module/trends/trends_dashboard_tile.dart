import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../route/route_name.dart';

class TrendsDashboardTile extends StatelessWidget {
  const TrendsDashboardTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => context.pushNamed(RouteName.dashboardTrends),
        child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Trends', style: _titleStyle(context)),
                  const Icon(Icons.chevron_right_sharp,
                      size: 16, color: Colors.grey)
                ])));
  }

  TextStyle? _titleStyle(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .titleLarge
        ?.apply(fontSizeFactor: 0.7, fontWeightDelta: 3);
  }
}
