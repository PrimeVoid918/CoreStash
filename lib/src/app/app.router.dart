import 'package:go_router/go_router.dart';

// 1. Import the file that ACTUALLY contains the generated code
import 'package:corestash/src/features/batch/presentation/batch.route.dart'
    as batch_feature;
import 'package:corestash/src/features/inventory/presentation/inventory.route.dart'
    as inventory_feature;

class AppRoute {
  static const inventory = "/inventory";
  static const batch = "/batch";
}

class FakeAuth {
  static bool isLoggedIn = false;
  static String username = "user1";
  static String password = "user1";
}

final GoRouter appRouter = GoRouter(
  // 2. Use the prefix to get the type-safe starting location
  initialLocation: const batch_feature.BatchMainRoute().location,

  // 3. Use the prefix to grab the generated route array from that file!
  routes: [...batch_feature.$appRoutes, ...inventory_feature.$appRoutes],
);
