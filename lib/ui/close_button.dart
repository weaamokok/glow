import 'package:auto_route/auto_route.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';

class CloseOrBackButton extends StatelessWidget {
  const CloseOrBackButton({super.key, required this.isClose});

  final bool isClose;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: AlignmentDirectional.topStart,
        child: IconButton(
            onPressed: () {
              context.maybePop();
            },
            icon: Icon(
                isClose ? Icons.close : EneftyIcons.arrow_left_3_outline)));
  }
}
