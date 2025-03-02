import 'package:auto_route/auto_route.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:glow/feature/prompt_creator/prompt_creator_stepper_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../helper/image_picker.dart';

class ImagePickerStep extends HookConsumerWidget {
  const ImagePickerStep({required this.promptImages, super.key});

  final ValueNotifier promptImages;

  @override
  Widget build(BuildContext context, ref) {
    onTapUploadImage({required int index}) async {
      await showDialog(
        context: context,
        builder: (_) => SimpleDialog(
          titleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xff282828),
          ),
          backgroundColor: Colors.white.withValues(alpha: .9),
          elevation: 0,
          title: Text('would You Like To'),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('select From Gallery'),
              onPressed: () async {
                context.maybePop();
                final imageFile = await selectOrTakePhoto(ImageSource.gallery);
                if (imageFile == null) return;

                if (promptImages.value[index] == null ||
                    promptImages.value.isEmpty) {
                  promptImages.value.add(imageFile);
                } else {
                  promptImages.value[index] = imageFile;
                }
                print('--${promptImages.value}');
              },
            ),
            SimpleDialogOption(
              child: Text('take a photo'),
              onPressed: () async {
                context.maybePop();
                final imageFile = await selectOrTakePhoto(ImageSource.camera);
                if (imageFile == null) return;

                promptImages.value[index] = imageFile;
                promptImages.value.notify();
                print('--${promptImages.value}');
              },
            ),
          ],
        ),
      );
    }

    return Builder(builder: (context) {
      int index = 0;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            Text(
                'we can provide more efficient schedule based on a clear photo of you..'),
            SizedBox(
              height: 12,
            ),
            Container(
              height: 300,
              child: Row(children: [
                for (int i = 0; i < UserImagesTypes.values.length / 2; i++)
                  Column(
                    children: [
                      for (int j = i;
                          j < UserImagesTypes.values.length / 2;
                          j++, index++)
                        Expanded(
                          child: ImagePickerContainer(
                            onTap: () {
                              onTapUploadImage(index: index);
                            },
                            width: 160,
                            image: promptImages.value[index],
                            margin: EdgeInsets.all(5),
                            text: switch (UserImagesTypes.values[index]) {
                              UserImagesTypes.full => 'Full length photo',
                              UserImagesTypes.head => 'Head Shot',
                              UserImagesTypes.sideProfile => 'Side Profile'
                            },
                            icon: Icon(EneftyIcons.camera_outline),
                          ),
                        )
                    ],
                  )
              ]),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    });
  }
}

enum UserImagesTypes { head, sideProfile, full }
