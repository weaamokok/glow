import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glow/app/app_router.gr.dart';
import 'package:glow/feature/profile/widget/profile_summary.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  WidgetRef ref;

  AppRouter(this.ref) : super();

  @override
  RouteType get defaultRouteType => const RouteType.cupertino();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: MainRoute.page, path: '/'),
        AutoRoute(
            page: PromptCreatorStepperRoute.page, path: '/prompt_creation'),
        AutoRoute(page: UserProfileSummaryRoute.page, path: '/profile_summary')
      ];

  @override
  late final List<AutoRouteGuard> guards = [
    // AuthGuard(ref)
    // add more guards here
  ];
}
