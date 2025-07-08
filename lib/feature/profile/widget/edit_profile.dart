import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glow/feature/profile/profile_deps.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../domain/user.dart';
import '../../../l10n/translations.g.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key, this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    final initialName = user?.name ?? '';
    final initialBio = user?.bio ?? '';

    final form = FormGroup({
      'name': FormControl<String>(
        value: initialName,
        validators: [Validators.required],
      ),
      'bio': FormControl<String>(value: initialBio),
    });
    final locale = context.t;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: ReactiveForm(
        formGroup: form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 18,
          children: [
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => context.maybePop(),
                  child:
                      Text(locale.core.cancel, style: TextStyle(fontSize: 16)),
                ),
                Container(
                  height: 3,
                  width: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color(0xff282828).withAlpha(50),
                  ),
                ),
                ReactiveFormConsumer(builder: (context, form, child) {
                  return Consumer(builder: (context, ref, widget) {
                    return TextButton(
                      onPressed: form.touched
                          ? () async {
                              form.markAllAsTouched();
                              if (form.valid) {
                                final updatedProfile = await ref.read(
                                  ProfileDeps.updateProfile(
                                    User(
                                      name: form.control('name').value,
                                      bio: form.control('bio').value,
                                    ),
                                  ),
                                );

                                updatedProfile.maybeMap(
                                  orElse: () {
                                    if (updatedProfile.hasError) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(locale
                                                .editProfileScreen
                                                .updateError)),
                                      );
                                    }
                                  },
                                  data: (data) async {
                                    ref.invalidate(ProfileDeps.userProfile);
                                    context.maybePop();
                                  },
                                );
                              }
                            }
                          : null,
                      child: Text(
                        locale.core.done,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    );
                  });
                }),
              ],
            ),

            /// Name field
            ReactiveTextField(
              formControlName: 'name',
              validationMessages: {
                ValidationMessage.required: (_) =>
                    locale.editProfileScreen.nameRequired,
              },
              onChanged: (control) {
                final newValue = control.value ?? '';
                if (newValue != initialName) {
                  form.markAsTouched(updateParent: false);
                } else {
                  form.markAsUntouched(updateParent: false);
                }
                form.control('name').value = newValue;
              },
              decoration: InputDecoration(
                  labelText: locale.editProfileScreen.nameLabel),
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(backgroundColor: Colors.white),
            ),

            /// Bio field
            ReactiveTextField(
              formControlName: 'bio',
              onChanged: (control) {
                final newValue = control.value ?? '';
                if (newValue != initialBio) {
                  form.markAsTouched(updateParent: false);
                } else {
                  form.markAsUntouched(updateParent: false);
                }
                form.control('bio').value = newValue;
              },
              decoration:
                  InputDecoration(labelText: locale.editProfileScreen.bioLabel),
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(backgroundColor: Colors.white),
            ),
            SizedBox(
              height: 38,
            )
          ],
        ),
      ),
    );
  }
}
