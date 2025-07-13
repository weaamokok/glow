// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;
import 'package:glow/feature/main/main_screen.dart' as _i1;
import 'package:glow/feature/profile/widget/profile_summary.dart' as _i3;
import 'package:glow/feature/prompt_creator/prompt_creator_stepper_screen.dart'
    as _i2;

/// generated route for
/// [_i1.MainScreen]
class MainRoute extends _i4.PageRouteInfo<void> {
  const MainRoute({List<_i4.PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i1.MainScreen();
    },
  );
}

/// generated route for
/// [_i2.PromptCreatorStepperScreen]
class PromptCreatorStepperRoute
    extends _i4.PageRouteInfo<PromptCreatorStepperRouteArgs> {
  PromptCreatorStepperRoute({
    required bool isEdit,
    _i5.Key? key,
    List<_i4.PageRouteInfo>? children,
  }) : super(
          PromptCreatorStepperRoute.name,
          args: PromptCreatorStepperRouteArgs(
            isEdit: isEdit,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'PromptCreatorStepperRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PromptCreatorStepperRouteArgs>();
      return _i2.PromptCreatorStepperScreen(
        isEdit: args.isEdit,
        key: args.key,
      );
    },
  );
}

class PromptCreatorStepperRouteArgs {
  const PromptCreatorStepperRouteArgs({
    required this.isEdit,
    this.key,
  });

  final bool isEdit;

  final _i5.Key? key;

  @override
  String toString() {
    return 'PromptCreatorStepperRouteArgs{isEdit: $isEdit, key: $key}';
  }
}

/// generated route for
/// [_i3.UserProfileSummaryScreen]
class UserProfileSummaryRoute extends _i4.PageRouteInfo<void> {
  const UserProfileSummaryRoute({List<_i4.PageRouteInfo>? children})
      : super(
          UserProfileSummaryRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserProfileSummaryRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i3.UserProfileSummaryScreen();
    },
  );
}
