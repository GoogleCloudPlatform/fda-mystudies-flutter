import 'package:flutter/material.dart';

import '../block/shimmer_block.dart';

class ActivityTileBlock extends StatelessWidget {
  final String title;
  final ActivityStatus status;
  final Frequency frequency;
  final Function() onTap;
  final bool displayShimmer;

  const ActivityTileBlock(
      {super.key,
      required this.title,
      required this.status,
      required this.frequency,
      required this.onTap,
      this.displayShimmer = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: displayShimmer
            ? const ShimmerBlock(height: 75)
            : Card(
                color: Theme.of(context).colorScheme.background,
                elevation: 0,
                child: ListTile(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: 0.7,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant
                                .withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(16)),
                    leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant
                                    .withOpacity(0.5),
                                width: 1)),
                        child: Icon(Icons.description_outlined,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant)),
                    trailing: Text(status.name,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.apply(color: status.color)),
                    title: Text(title, style: Theme.of(context).textTheme.titleMedium),
                    subtitle: Text(frequency.name, style: Theme.of(context).textTheme.bodySmall),
                    onTap: onTap,
                    contentPadding: const EdgeInsets.fromLTRB(12, 6, 20, 6))));
  }
}

enum ActivityStatus { completed, missed, start, ended, inProgress, upcoming }

enum Frequency { oneTime, daily, weekly, monthly, customSchedule }

extension ActivityStatusExtension on ActivityStatus {
  String get name {
    switch (this) {
      case ActivityStatus.completed:
        return 'Completed';
      case ActivityStatus.ended:
        return 'Ended';
      case ActivityStatus.inProgress:
        return 'In Progress';
      case ActivityStatus.missed:
        return 'Missed';
      case ActivityStatus.start:
        return 'Start';
      case ActivityStatus.upcoming:
        return 'Upcoming';
    }
  }

  Color get color {
    switch (this) {
      case ActivityStatus.completed:
        return const Color(0xFF1E8E3E);
      case ActivityStatus.ended:
        return const Color(0xFF80868B);
      case ActivityStatus.inProgress:
        return const Color(0xFF1A73E8);
      case ActivityStatus.missed:
        return const Color(0xFF80868B);
      case ActivityStatus.start:
        return const Color(0xFF1A73E8);
      case ActivityStatus.upcoming:
        return const Color(0xFF80868B);
    }
  }
}

extension FrequencyExtension on Frequency {
  String get value {
    switch (this) {
      case Frequency.oneTime:
        return 'One time';
      case Frequency.daily:
        return 'Daily';
      case Frequency.weekly:
        return 'Weekly';
      case Frequency.monthly:
        return 'Monthly';
      case Frequency.customSchedule:
        return 'Manually Schedule';
    }
  }

  String get name {
    switch (this) {
      case Frequency.oneTime:
        return 'One time';
      case Frequency.daily:
        return 'Daily';
      case Frequency.weekly:
        return 'Weekly';
      case Frequency.monthly:
        return 'Monthly';
      case Frequency.customSchedule:
        return 'Aperiodic';
    }
  }
}
