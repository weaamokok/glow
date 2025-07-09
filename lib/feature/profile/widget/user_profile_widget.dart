import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';

import '../../../domain/user.dart';
import '../../../l10n/translations.g.dart';
import 'edit_profile.dart';

class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({super.key, this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    final locale = context.t;
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
                            onTap: () {

                            },
                            leading: Icon(EneftyIcons.image_outline),
                            title: Text(
                              locale.imagePickerStep.selectFromGallery,
                            ),
                          ),
                          ListTile(
                            leading: Icon(EneftyIcons.camera_outline),
                            title: Text(
                              locale.imagePickerStep.takePhoto,
                            ),
                          ),
                          ListTile(
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
                child: const CircleAvatar(
                  minRadius: 35,
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
                  builder: (context) =>
                      EditProfile(
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
