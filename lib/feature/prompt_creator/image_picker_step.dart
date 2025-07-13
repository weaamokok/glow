import 'dart:io';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:glow/feature/prompt_creator/prompt_creator_deps.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../helper/helper_functions.dart';
import '../../helper/image_picker.dart';
import '../../l10n/translations.g.dart';

class ImagePickerStep extends HookConsumerWidget {
  const ImagePickerStep({required this.isEdit, super.key});

  final bool isEdit;

  @override
  Widget build(BuildContext context, ref) {
    final local = context.t;
    final imagePickerLocal = local.imagePickerStep;
    final imagesNotifier =
        ref.read(PromptCreatorDeps.promptImagesProvider.notifier);
//to load the saved images from local storage to the screen
    useEffect(() {
      if (isEdit) {
        Future.microtask(() async {
          try {
            final savedImages =
                await ref.read(PromptCreatorDeps.getSavedImages);
            final files = await uint8ListToFile(savedImages);

            // Remove nulls in case of conversion failures
            for (int i = 0; i < files.length; i++) {
              final file = files[i];
              if (file != null) {
                imagesNotifier.updateImage(i, file);
              }
            }
          } catch (e) {
            debugPrint('Failed to load saved images: $e');
          }
        });
      }
      return null;
    }, []);

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

class ImagePickerContainer extends StatelessWidget {
  const ImagePickerContainer(
      {super.key,
      required this.width,
      this.height,
      this.image,
      this.text,
      required this.icon,
      this.onTap,
      this.margin});

  final double width;
  final double? height;
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
            height: height,
            decoration: BoxDecoration(
                color: Color(0xff3B6790).withValues(alpha: .2),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15)),
            child: image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      image!,
                      fit: BoxFit.cover,
                    ),
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
