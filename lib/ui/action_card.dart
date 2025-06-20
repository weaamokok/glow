import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:flutter_swipe_action_cell/core/controller.dart';
import 'package:glow/domain/glow.dart';
import 'package:glow/helper/helper_functions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../feature/home/action_details_sheet.dart';
import '../feature/home/home_deps.dart';
import '../feature/home/update_action_bottom_sheet.dart';

class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.instanceId,
    required this.action,
  });

  final ScheduleAction action;
  final String instanceId;

  @override
  Widget build(BuildContext context) {
    final currentActionInstance = action.instances
        ?.firstWhereOrNull(
          (element) => element.id == instanceId,
        )
        ?.status;
    return InkWell(
      onTap: () => showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        barrierColor: Color(0xff4A4A4A).withAlpha(70),
        builder: (context) {
          return ActionDetailsSheet(
            action: action,
            instanceId: instanceId,
          );
        },
      ),
      child: Card(
        margin: EdgeInsets.all(0),
        elevation: 0,
        // shape: RoundedRectangleBorder(
        //     side: BorderSide(
        //       width: 1,
        //       color: Color(0xff282828),
        //     ),
        //     borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  spacing: 2,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      action.category ?? '',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          action.title ?? '',
                          style: TextStyle(
                              decoration: currentActionInstance ==
                                      ActionStatus.completed
                                  ? TextDecoration.lineThrough
                                  : null,
                              fontSize: 14,
                              color: Color(0xff282828),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              EneftyIcons.timer_2_outline,
                              size: 16,
                              color: Color(0xff989696),
                            ),
                            Text(
                              "${action.duration}min",
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xff989696)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 11,
                          child: VerticalDivider(
                            color: Color(0xff282828).withValues(alpha: .2),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(EneftyIcons.location_outline,
                                size: 16, color: Color(0xff989696)),
                            Text(
                              action.location ?? '',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xff989696)),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff282828)),
                      color: Color(0xffFF8C61),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      action.priority ?? '',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ManageableActionCard extends ConsumerWidget {
  const ManageableActionCard({
    super.key,
    this.instanceId,
    required this.action,
  });

  final ScheduleAction action;
  final String? instanceId;

  @override
  Widget build(BuildContext context, ref) {
    final SwipeActionController controller = SwipeActionController();
    return SwipeActionCell(
        controller: controller,
        trailingActions: [
          if (instanceId != null)
            SwipeAction(
                icon: Icon(
                  EneftyIcons.trash_outline,
                  color: Colors.white,
                  size: 20,
                ),
                onTap: (CompletionHandler handler) async {
                  controller.closeAllOpenCell();
                  final actionController = // In your widget
                      ref.read(HomeDeps.actionControllerProvider.notifier);

                  await actionController.deleteAction(
                      actionId: action.id, instanceId: instanceId ?? '');
                },
                color: Colors.red),
          SwipeAction(
              icon: Icon(
                EneftyIcons.edit_2_outline,
                size: 20,
                color: Colors.white,
              ),
              closeOnTap: true,
              onTap: (CompletionHandler handler) async {
                controller.closeAllOpenCell();
                showModalBottomSheet(
                    context: context,
                    builder: (context) => UpdateActionBottomSheet(
                          action: action,
                        ));
              },
              color: Color(0xffEFB036)),
        ],
        key: Key(action.id),
        child: ActionCard(instanceId: instanceId ?? '', action: action));
  }
}
