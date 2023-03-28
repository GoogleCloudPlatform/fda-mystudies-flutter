import 'package:flutter/material.dart';

import '../block/shimmer_block.dart';

class ActivityTileBlock extends StatelessWidget {
  final String title;
  final ActivityStatus status;
  final ActivityFrequency frequency;
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
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
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

enum ActivityStatus {
  yetToJoin,
  inProgress,
  completed,
  abandoned,
  expired,
  upcoming
}

enum ActivityFrequency { oneTime, daily, weekly, monthly, customSchedule }

extension ActivityStatusExtension on ActivityStatus {
  static ActivityStatus valueFrom(String status) {
    final lowercaseStatus = status.toLowerCase();
    switch (lowercaseStatus) {
      case 'completed':
        return ActivityStatus.completed;
      case 'expired':
        return ActivityStatus.expired;
      case 'inprogress':
        return ActivityStatus.inProgress;
      case 'abandoned':
        return ActivityStatus.abandoned;
      case 'yettojoin':
        return ActivityStatus.yetToJoin;
      default:
        return ActivityStatus.upcoming;
    }
  }

  String get toValue {
    switch (this) {
      case ActivityStatus.completed:
        return 'completed';
      case ActivityStatus.expired:
        return 'expired';
      case ActivityStatus.inProgress:
        return 'inProgress';
      case ActivityStatus.abandoned:
        return 'abandoned';
      case ActivityStatus.yetToJoin:
        return 'yetToJoin';
      case ActivityStatus.upcoming:
        return 'yetToJoin';
    }
  }

  String get name {
    switch (this) {
      case ActivityStatus.completed:
        return 'Completed';
      case ActivityStatus.expired:
        return 'Expired';
      case ActivityStatus.inProgress:
        return 'Resume';
      case ActivityStatus.abandoned:
        return 'Missed';
      case ActivityStatus.yetToJoin:
        return 'Start';
      case ActivityStatus.upcoming:
        return 'Upcoming';
    }
  }

  Color get color {
    switch (this) {
      case ActivityStatus.completed:
        return const Color(0xFF1E8E3E);
      case ActivityStatus.expired:
        return const Color(0xFF80868B);
      case ActivityStatus.inProgress:
        return const Color(0xFF1A73E8);
      case ActivityStatus.abandoned:
        return const Color(0xFF80868B);
      case ActivityStatus.yetToJoin:
        return const Color(0xFF1A73E8);
      case ActivityStatus.upcoming:
        return const Color(0xFF80868B);
    }
  }
}

extension ActivityFrequencyExtension on ActivityFrequency {
  static ActivityFrequency valueFrom(String frequency) {
    if (frequency == 'One time') {
      return ActivityFrequency.oneTime;
    } else if (frequency == 'Daily') {
      return ActivityFrequency.daily;
    } else if (frequency == 'Weekly') {
      return ActivityFrequency.weekly;
    } else if (frequency == 'Monthly') {
      return ActivityFrequency.monthly;
    } else if (frequency == 'Manually Schedule') {
      return ActivityFrequency.customSchedule;
    }
    return ActivityFrequency.customSchedule;
  }

  String get name {
    switch (this) {
      case ActivityFrequency.oneTime:
        return 'One time';
      case ActivityFrequency.daily:
        return 'Daily';
      case ActivityFrequency.weekly:
        return 'Weekly';
      case ActivityFrequency.monthly:
        return 'Monthly';
      case ActivityFrequency.customSchedule:
        return 'Aperiodic';
    }
  }
}
