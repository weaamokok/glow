import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../helper/helper_functions.dart';

class UpdateActionBottomSheet extends HookWidget {
  const UpdateActionBottomSheet({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    final selectedDays = useState<List<String>>([]);
    return Column(
      children: [
        SizedBox(
          child: TextFormField(
            decoration: InputDecoration(hintText: 'title'),
          ),
        ),
        SizedBox(
          child: TextFormField(
            decoration: InputDecoration(hintText: 'description'),
          ),
        ),
        Row(
          children: weekDays.map(
            (day) {
              final isSelected = selectedDays.value.contains(day);
              return InkWell(
                onTap: () {
                  // final current = selectedDays.value;
                  // if (current.contains(day)) {
                  //   current.remove(day);
                  // } else {
                  //   current.add(day);
                  // }
                  // selectedDays.value = current;
                },
                child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color:
                            isSelected ? Color(0xffB399D4) : Color(0xffF5F5F5),
                        border: Border.all(color: Color(0xff282828)),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(day)),
              );
            },
          ).toList(),
        )
      ],
    );
  }
}
