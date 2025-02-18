import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glow/feature/main/main_deps.dart';

import '../prompt_creator/prompt_creator_stepper_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    ref.read(isFirstRunProvider).then(
      (value) {
        print('here $value');
        showModalBottomSheet(
          context: context,
          shape: LinearBorder(),
          isScrollControlled: true,
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
