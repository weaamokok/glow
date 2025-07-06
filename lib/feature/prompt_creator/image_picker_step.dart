import 'package:auto_route/auto_route.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:glow/feature/prompt_creator/prompt_creator_deps.dart';
import 'package:glow/feature/prompt_creator/prompt_creator_stepper_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../helper/image_picker.dart';
import '../../l10n/translations.g.dart';

class ImagePickerStep extends HookConsumerWidget {
  const ImagePickerStep({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final local = context.t;
    final imagePickerLocal = local.imagePickerStep;
    final promptImages = ref.read(PromptCreatorDeps.promptImagesProvider);
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
          title: Text(imagePickerLocal.dialogTitle),
          children: <Widget>[
            SimpleDialogOption(
              child: Text(imagePickerLocal.selectFromGallery),
              onPressed: () async {
                context.maybePop();
                final imageFile = await selectOrTakePhoto(ImageSource.gallery);
                if (imageFile == null || !context.mounted) return;

                ref
                    .read(PromptCreatorDeps.promptImagesProvider.notifier)
                    .updateImage(index, imageFile);
              },
            ),
            SimpleDialogOption(
              child: Text(imagePickerLocal.takePhoto),
              onPressed: () async {
                context.maybePop();
                final imageFile = await selectOrTakePhoto(ImageSource.camera);
                if (imageFile == null || !context.mounted) return;

                ref
                    .read(PromptCreatorDeps.promptImagesProvider.notifier)
                    .updateImage(index, imageFile);
              },
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              Text(imagePickerLocal.description),
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
                            image: promptImages[e.index],
                            margin: EdgeInsets.all(5),
                            text: switch (e) {
                              UserImagesTypes.full =>
                                imagePickerLocal.photoFull,
                              UserImagesTypes.head =>
                                imagePickerLocal.photoHead,
                              UserImagesTypes.sideProfile =>
                                imagePickerLocal.photoSide
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
      ],
    );
  }
}

enum UserImagesTypes { head, sideProfile, full }
