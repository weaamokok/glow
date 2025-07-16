import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glow/domain/action_instance.dart';

import '../../../domain/glow.dart';
import '../../calendar/calendar_deps.dart';

class GlowProgressWidget extends ConsumerWidget {
  const GlowProgressWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedule = ref.watch(CalendarDeps.scheduleProvider);
    if (schedule.value == null) return SizedBox.shrink();
    final allInstances = schedule.value?.dailySchedule
        .expand((e) => e.actions ?? <ScheduleAction>[])
        .expand((action) => action.instances ?? <ActionInstance>[])
        .toList();

    final completedInstances =
        allInstances?.where((e) => e.status == ActionStatus.completed).toList();

    final total = allInstances?.length ?? 0;
    final completed = completedInstances?.length ?? 0;

    // Safely calculate progress
    final progress = total > 0 ? completed / total : 0.0;
    final progressText = (progress * 100).toStringAsFixed(0);

    return AnimatedContainer(
      curve: Curves.easeInToLinear,
      duration: kThemeAnimationDuration,
      padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
        border: Border(
          right: BorderSide(color: Color(0xff282828)),
          top: BorderSide(color: Color(0xff282828)),
          left: BorderSide(color: Color(0xff282828)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 8.0),
            child: Row(
              children: [
                Text(
                  '$progressText%',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  'closer to your Glow-up, keep going..✨',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xff282828)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: FractionallySizedBox(
              alignment: AlignmentDirectional.centerStart,
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                margin: const EdgeInsets.all(4),
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xffA2D7D8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xff282828)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
