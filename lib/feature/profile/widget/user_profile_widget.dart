import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glow/feature/profile/profile_deps.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/user.dart';
import '../../../helper/image_picker.dart';
import '../../../l10n/translations.g.dart';
import 'edit_profile.dart';

class UserProfileWidget extends HookConsumerWidget {
  const UserProfileWidget({super.key, this.user});

  final User? user;

  @override
  Widget build(BuildContext context, ref) {
    print('user n  $user');
    final locale = context.t;
    final userImage =
        user?.fileImage != null ? File(user?.fileImage ?? '') : null;
    final displayedImage = useState<File?>(userImage);
    updateUser({required String imagePath}) {
      final updatedUser = user == null
          ? User(fileImage: imagePath)
          : user!.copyWith(fileImage: imagePath);
      ref.read(ProfileDeps.updateProfile(updatedUser));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 5,
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    showDragHandle: true,
                    isScrollControlled: true,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            onTap: () async {
                              final imageFile =
                                  await selectOrTakePhoto(ImageSource.gallery);
                              if (imageFile == null || !context.mounted) return;
                              displayedImage.value = imageFile;
                              updateUser(imagePath: imageFile.path);

                              await context.maybePop();
                            },
                            leading: Icon(EneftyIcons.image_outline),
                            title: Text(
                              locale.imagePickerStep.selectFromGallery,
                            ),
                          ),
                          ListTile(
                            onTap: () async {
                              final imageFile =
                                  await selectOrTakePhoto(ImageSource.camera);
                              if (imageFile == null || !context.mounted) return;
                              displayedImage.value = imageFile;
                              updateUser(imagePath: imageFile.path);
                              await context.maybePop();
                            },
                            leading: Icon(EneftyIcons.camera_outline),
                            title: Text(
                              locale.imagePickerStep.takePhoto,
                            ),
                          ),
                          ListTile(
                            onTap: () {},
                            leading: Icon(EneftyIcons.trash_outline),
                            title: Text(
                              locale.imagePickerStep.takePhoto,
                            ),
                            selected: true,
                            selectedColor: Colors.red,
                          ),
                          SizedBox(
                            height: 28,
                          )
                        ],
                      );
                    },
                  );
                },
                child: CircleAvatar(
                  minRadius: 35,
                  backgroundImage: displayedImage.value != null
                      ? FileImage(displayedImage.value!)
                      : null,
                  backgroundColor: Colors.amber,
                ),
              ),
              const SizedBox(width: 10), // spacing between avatar and text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? 'beautiful user',
                      style: TextStyle(
                        fontSize: 17,
                        color: Color(0xff282828)
                            .withAlpha(user == null ? 90 : 255),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      user?.bio ?? '..',
                      softWrap: true,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => EditProfile(
                    user: user,
                  ),
                );
              },
              icon: Icon(EneftyIcons.edit_outline)),
        )
      ],
    );
  }
}
