import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';

import '../../../domain/user.dart';
import 'edit_profile.dart';

class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({Key? key, this.user}) : super(key: key);
  final User? user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 5,
          child: Row(
            children: [
              const CircleAvatar(
                minRadius: 35,
                backgroundColor: Colors.amber,
              ),
              const SizedBox(width: 10), // spacing between avatar and text
              Expanded(
                // 👈 Constrains the column so text wraps
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
