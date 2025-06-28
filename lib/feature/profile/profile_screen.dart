import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glow/domain/mock_values.dart';
import 'package:glow/feature/profile/profile_deps.dart';
import 'package:glow/feature/profile/widget/edit_profile.dart';
import 'package:glow/feature/profile/widget/user_profile_widget.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 14.0),
      child: Column(
        spacing: 20,
        children: [
          SizedBox(
            height: 5,
          ),
          Consumer(builder: (context, ref, widget) {
            final user = ref.watch(ProfileDeps.userProfile);
            return user.when(
              data: (data) => UserProfileWidget(
                user: data,
              ),
              error: (error, stackTrace) => SizedBox(),
              loading: () => Skeletonizer(
                  child: UserProfileWidget(
                user: MockValues.user,
              )),
            );
          }),
          SizedBox(
            height: 3,
            width: double.infinity,
            child: Divider(
              height: 5,
              color: Color(0xff282828).withAlpha(30),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SettingsTile(
                  text: 'Personal Information',
                  onTap: () {},
                ),
                SettingsTile(
                  text: 'Language',
                  onTap: () {},
                ),
                SettingsTile(
                  text: 'Privacy policy',
                  onTap: () {},
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  const SettingsTile({super.key, required this.text, required this.onTap});

  final String text;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text),
      onTap: onTap,
      trailing: Icon(EneftyIcons.arrow_right_3_outline),
    );
  }
}
