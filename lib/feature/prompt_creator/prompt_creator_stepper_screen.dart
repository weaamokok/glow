import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glow/feature/prompt_creator/image_picker_step.dart';
import 'package:glow/feature/prompt_creator/prompt_creator_deps.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PromptCreatorStepperScreen extends HookConsumerWidget {
  const PromptCreatorStepperScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final stepIndex = useState(0);
    final promptImages =
        useState<List<File?>>(List.filled(UserImagesTypes.values.length, null));
    List<Widget> steps = [
      ImagePickerStep(
        promptImages: promptImages,
      ), //image picker
      Container(), //personal info
      Container(), //goals and life style
    ];
    final stepsProgress = useState(stepIndex.value + 1 / steps.length);
    return Container(
        padding: EdgeInsetsDirectional.only(end: 10, top: 16),
        width: double.infinity,
        child: Column(
          children: [
            CloseButton(),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              width: double.infinity,
              child: LinearProgressIndicator(
                value: stepsProgress.value,
                minHeight: 10,
                borderRadius: BorderRadius.circular(15),
                valueColor: AlwaysStoppedAnimation(Color(0xffEFB036)),
                backgroundColor: Color(0xff4C7B8B),
              ),
            ),
            SizedBox(
              height: 14,
            ),
            steps[stepIndex.value],
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: 44,
                    margin: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        switch (stepIndex.value) {
                          case 0:
                            ref.read(PromptCreatorDeps.addPromptImagesProvider(
                                promptImages.value));
                        }
                      },
                      style: ButtonStyle(
                        elevation: WidgetStatePropertyAll(0),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                        backgroundColor: WidgetStatePropertyAll(
                          Color(0xffEFB036),
                        ),
                      ),
                      child: Text(
                        'continue',
                        style:
                            TextStyle(color: Color(0xff282828), fontSize: 15),
                      ),
                    )),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ));
  }
}

class CloseButton extends StatelessWidget {
  const CloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: AlignmentDirectional.topStart,
        child: IconButton(
            onPressed: () {
              context.maybePop();
            },
            icon: Icon(Icons.close)));
  }
}

class ImagePickerContainer extends StatelessWidget {
  const ImagePickerContainer(
      {super.key,
      required this.width,
      this.image,
      this.text,
      required this.icon,
      this.onTap,
      this.margin});

  final double width;
  final File? image;
  final String? text;
  final EdgeInsets? margin;
  final Widget icon;

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: DottedBorder(
          padding: EdgeInsets.zero,
          borderType: BorderType.RRect,
          radius: Radius.circular(15),
          color: Color(0xff3B6790),
          strokeWidth: 1,
          child: Container(
            width: width,
            decoration: BoxDecoration(
                color: Color(0xff3B6790).withValues(alpha: .2),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15)),
            child: image != null
                ? Image.file(
                    image!,
                    fit: BoxFit.cover,
                  )
                : Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon,
                      Text(
                        text ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff282828).withValues(alpha: .8)),
                      ),
                    ],
                  )),
          ),
        ),
      ),
    );
  }
}
