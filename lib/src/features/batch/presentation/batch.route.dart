import 'package:go_router/go_router.dart';
import 'package:prac1/src/features/batch/presentation/pages/main.page.dart';

class BatchRoute {
  static const batch = '/batch';
  // static const
}

final List<RouteBase> batchRoutes = [
  GoRoute(path: BatchRoute.batch, builder: (_, _) => BatchMainPage()),
];
