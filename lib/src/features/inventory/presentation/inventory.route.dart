import 'package:go_router/go_router.dart';
import 'package:prac1/src/features/inventory/presentation/pages/main.page.dart';
import 'package:prac1/src/features/inventory/presentation/pages/records.page.dart';

class InventoryRoute {
  static const inventory = "/inventory";
  static const records = '$inventory/records';
}

final List<RouteBase> inventoryRoutes = [
  GoRoute(
    path: InventoryRoute.inventory,
    builder: (_, _) => const InventoryMainScreen(),
  ),
  GoRoute(path: InventoryRoute.records, builder: (_, _) => const RecordsPage()),
];
