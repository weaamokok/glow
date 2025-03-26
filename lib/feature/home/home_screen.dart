import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glow/feature/main/main_deps.dart';

import '../prompt_creator/prompt_creator_stepper_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    ref.read(isFirstRunProvider).then(
      (value) async {
        await showModalBottomSheet(
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
