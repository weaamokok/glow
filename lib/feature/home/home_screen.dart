import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glow/app/app_router.gr.dart';
import 'package:glow/feature/main/main_deps.dart';

import '../prompt_creator/prompt_creator_stepper_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    ref.read(isFirstRunProvider).then(
      (value) {
        showModalBottomSheet(
          context: context,
          shape: LinearBorder(),
          isScrollControlled: true,
          useRootNavigator: true,
          constraints: BoxConstraints.expand(),
          builder: (context) {
            return PromptCreatorStepperScreen();
          },
        );
      },
    );
    return const SingleChildScrollView();
  }
}
