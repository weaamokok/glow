import 'package:auto_route/auto_route.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glow/app/app_router.gr.dart';
import 'package:glow/domain/mock_values.dart';
import 'package:glow/feature/profile/profile_deps.dart';
import 'package:glow/feature/profile/widget/language_selection_bottom_sheet.dart';
import 'package:glow/feature/profile/widget/personal_info_sheet.dart';
import 'package:glow/feature/profile/widget/user_profile_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../l10n/translations.g.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key, this.controller});

  final ScrollController? controller;

  @override
  Widget build(BuildContext context, ref) {
    final local = context.t.profileScreen;
    final user = ref.watch(ProfileDeps.userProfile);

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 14.0),
      child: Column(
        spacing: 20,
        children: [
          SizedBox(
            height: 5,
          ),
          user.when(
            data: (data) => UserProfileWidget(
              user: data,
            ),
            error: (error, stackTrace) => SizedBox(),
            loading: () => Skeletonizer(
                child: UserProfileWidget(
              user: MockValues.user,
            )),
          ),
          SizedBox(
            height: 3,
            width: double.infinity,
            child: Divider(
              height: 5,
              color: Color(0xff282828).withAlpha(30),
            ),
          ),
          SingleChildScrollView(
            controller: controller,
            child: Column(
              children: [
                SettingsTile(
                  text: local.personalInfo,
                  onTap: () {
                    context.router
                        .push(PromptCreatorStepperRoute(isEdit: true));
                  },
                ),
                SettingsTile(
                  text: local.language,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => LanguageSelectionBottomSheet(),
                    );
                  },
                ),
                SettingsTile(
                  text: local.privacyPolicy,
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
