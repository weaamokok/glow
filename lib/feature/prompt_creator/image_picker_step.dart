import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:glow/feature/prompt_creator/prompt_creator_deps.dart';
import 'package:glow/feature/prompt_creator/prompt_creator_stepper_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../helper/image_picker.dart';

class ImagePickerStep extends HookConsumerWidget {
  const ImagePickerStep(//   {required this.promptImages, super.key}
      );

//  final ValueNotifier promptImages;

  @override
  Widget build(BuildContext context, ref) {
    final promptImages =
        ref.read(PromptCreatorDeps.promptImagesProvider.notifier);
    // final stepProvider =
    //     ref.watch(PromptCreatorDeps.promptCreatorStepProvider.notifier);
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

                ref
                    .read(PromptCreatorDeps.promptImagesProvider.notifier)
                    .value[index] = imageFile;

                print('--${promptImages.value}');
              },
            ),
            SimpleDialogOption(
              child: Text('take a photo'),
              onPressed: () async {
                context.maybePop();
                final imageFile = await selectOrTakePhoto(ImageSource.camera);
                if (imageFile == null) return;
                //  promptImages.value.insert(index, imageFile);
                ref
                    .read(PromptCreatorDeps.promptImagesProvider.notifier)
                    .value[index] = imageFile;
                print('--${promptImages.value}');
              },
            ),
          ],
        ),
      );
    }

    return Builder(builder: (context) {
      int index = 0;

      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                Text(
                    'we can provide more efficient schedule based on a clear photo of you..'),
                SizedBox(
                  height: 12,
                ),
                SizedBox(
                    height: 300,
                    child: StaggeredGrid.count(
                      crossAxisCount: UserImagesTypes.values.length,
                      children: UserImagesTypes.values.map(
                        (e) {
                          return StaggeredGridTile.count(
                            crossAxisCellCount: e.index == 0 ? 2 : 1,
                            mainAxisCellCount: e.index == 0 ? 2 : 1,
                            child: ImagePickerContainer(
                              onTap: () {
                                onTapUploadImage(index: e.index);
                              },
                              width: double.infinity,
                              height: e.index == 0 ? 300 : 120,
                              image: promptImages.value[e.index],
                              margin: EdgeInsets.all(5),
                              text: switch (e) {
                                UserImagesTypes.full => 'Full length photo',
                                UserImagesTypes.head => 'Head Shot',
                                UserImagesTypes.sideProfile => 'Side Profile'
                              },
                              icon: Icon(EneftyIcons.camera_outline),
                            ),
                          );
                        },
                      ).toList(),
                    )),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Container(
          //       height: 44,
          //       margin: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          //       width: double.infinity,
          //       child: ElevatedButton(
          //         onPressed: () {
          //           ref.read(PromptCreatorDeps.addPromptImagesProvider(
          //               promptImages.value));
          //           ref
          //               .read(PromptCreatorDeps.promptCreatorStepProvider)
          //               .value = 1;
          //
          //           //    stepProvider.value = 1;
          //         },
          //         style: ButtonStyle(
          //           elevation: WidgetStatePropertyAll(0),
          //           shape: WidgetStatePropertyAll(RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(10))),
          //           backgroundColor: WidgetStatePropertyAll(
          //             Color(0xffEFB036),
          //           ),
          //         ),
          //         child: Text(
          //           'continue',
          //           style: TextStyle(color: Color(0xff282828), fontSize: 15),
          //         ),
          //       )),
          // )
        ],
      );
    });
  }
}

enum UserImagesTypes { head, sideProfile, full }
