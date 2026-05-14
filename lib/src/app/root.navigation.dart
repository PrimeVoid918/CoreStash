import 'package:go_router/go_router.dart';
import 'package:prac1/src/features/inventory/presentation/inventory.route.dart';

// enum AppRoute {
//   inventory('/');

//   final String path;
//   const AppRoute(this.path);
// }

class AppRoute {
  static const inventory = "/inventory";
}

class FakeAuth {
  static bool isLoggedIn = false;
  static String username = "user1";
  static String password = "user1";
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoute.inventory,

  // redirect: (context, state) {
  //   final goingToInventory = state.matchedLocation == AppRoute.inventory;

  //   if (!goingToInventory) {
  //     return AppRoute.inventory;
  //   }

  //   return null;
  // },
  routes: [...inventoryRoutes],
);
