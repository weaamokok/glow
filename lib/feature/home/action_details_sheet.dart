import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glow/domain/glow.dart';
import 'package:glow/feature/home/home_deps.dart';
import 'package:glow/helper/helper_functions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ActionDetailsSheet extends HookConsumerWidget {
  const ActionDetailsSheet(
      {super.key, required this.instanceId, required this.action});

  final ScheduleAction action;
  final String instanceId;

  @override
  Widget build(BuildContext context, ref) {
    final actionStatus = useState(action.instances
        ?.firstWhereOrNull((element) => element.id == instanceId)
        ?.status);
    final prepNeeded = action.prepNeeded ?? false;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          border: Border(
              left: BorderSide(color: Color(0xff282828), width: 1.5),
              right: BorderSide(color: Color(0xff282828), width: 1.5),
              top: BorderSide(color: Color(0xff282828), width: 1.5))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          SizedBox(
            height: 5,
          ),
          Center(
            child: Container(
              width: 50,
              height: 8,
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff282828)),
                  color: Color(0xffB399D4).withAlpha(80),
                  borderRadius: BorderRadius.circular(15)),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: IntrinsicWidth(
              child: InkWell(
                onTap: () async {
                  final actionController = // In your widget
                      ref.read(HomeDeps.actionControllerProvider.notifier);

// Update action status
                  final response = await actionController.updateActionStatus(
                    action: action.copyWith(
                        instances: action.instances?.map((e) {
                      if (e.id == instanceId) {
                        return e.copyWith(
                            status: actionStatus.value == ActionStatus.todo
                                ? ActionStatus.completed
                                : ActionStatus.todo);
                      } else {
                        return e;
                      }
                    }).toList()),
                    instanceId: instanceId,
                  );
                  //     await ref.read(HomeDeps.completeActionProvider((
                  //   action.copyWith(
                  //       instances: action.instances?.map((e) {
                  //     if (e.id == instanceId) {
                  //       return e.copyWith(
                  //           status: actionStatus.value == ActionStatus.todo
                  //               ? ActionStatus.completed
                  //               : ActionStatus.todo);
                  //     } else {
                  //       return e;
                  //     }
                  //   }).toList()),
                  //   instanceId
                  // )));
                  response.maybeMap(
                    orElse: () => actionStatus.value = ActionStatus.undefined,
                    data: (data) => actionStatus.value = data.value,
                    error: (error) => actionStatus.value = ActionStatus.todo,
                  );
                },
                child: AnimatedContainer(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  duration: Duration(seconds: 2),
                  curve: Curves.fastEaseInToSlowEaseOut,
                  decoration: BoxDecoration(
                      color: actionStatus.value == ActionStatus.todo
                          ? Color(0xffFFD3B6)
                          : Color(0xffA2D7D8),
                      border: Border.all(color: Color(0xff282828)),
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      actionStatus.value == ActionStatus.undefined
                          ? CircularProgressIndicator.adaptive()
                          : Icon(Icons.check),
                      if (actionStatus.value == ActionStatus.todo)
                        Text('mark as Completed')
                    ],
                  ),
                ),
              ),
            ),
          ),
          Text(
            'Description',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(action.description ?? ''),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Text(
                'Repeat',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(spacing: 5, children: [
                ...?action.frequency?.map(
                  (o) {
                    return Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Color(0xffF5F5F5),
                            border: Border.all(color: Color(0xff282828)),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(o));
                  },
                ),
              ]),
            ],
          ),
          if (prepNeeded) Text("some preparations are needed here")
        ],
      ),
    );
  }
}
