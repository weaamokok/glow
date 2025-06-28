import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glow/feature/profile/profile_deps.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../domain/user.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key, this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    final form = FormGroup({
      'name': FormControl<String>(
        value: user?.name,
        validators: [Validators.required],
      ),
      'bio': FormControl<String>(value: user?.bio),
    });
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: ReactiveForm(
          formGroup: form,
          child: Column(
            spacing: 18,
            children: [
              SizedBox(
                height: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      context.maybePop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    height: 3,
                    width: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Color(0xff282828).withValues(alpha: .5)),
                  ),
                  ReactiveFormConsumer(builder: (context, form, child) {
                    return Consumer(builder: (context, ref, widget) {
                      return TextButton(
                        onPressed: () async {
                          form.markAllAsTouched();
                          if (form.valid) {
                            final updatedProfile =
                                await ref.read(ProfileDeps.updateProfile(
                              User(
                                  name: form.control('name').value,
                                  bio: form.control('bio').value),
                            ));
                            updatedProfile.maybeMap(orElse: () {
                              if (updatedProfile.hasError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('couldnt update')));
                              } //handle error
                            }, data: (data) async {
                              ref.invalidate(ProfileDeps.userProfile);
                              context.maybePop();
                            });
                          }
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      );
                    });
                  }),
                ],
              ),
              ReactiveTextField(
                formControlName: 'name',
                validationMessages: {
                  ValidationMessage.required: (_) => 'name is required'
                },
                onChanged: (control) {
                  form.control('name').value = control.value;
                },
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                textCapitalization: TextCapitalization.words,
                style: TextStyle(backgroundColor: Colors.white),
              ),
              ReactiveTextField(
                formControlName: 'bio',
                onChanged: (control) {
                  form.control('bio').value = control.value;
                },
                decoration: InputDecoration(
                  labelText: 'Bio',
                ),
                textCapitalization: TextCapitalization.words,
                style: TextStyle(backgroundColor: Colors.white),
              ),
            ],
          )),
    );
  }
}
