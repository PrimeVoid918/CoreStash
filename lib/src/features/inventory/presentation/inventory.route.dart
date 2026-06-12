import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:corestash/src/features/batch/presentation/pages/main.page.dart';
import 'package:corestash/src/features/inventory/presentation/pages/main.page.dart';
import 'package:corestash/src/features/inventory/presentation/pages/records.page.dart';
import 'package:corestash/src/features/inventory/presentation/pages/scanner.page.dart';

part 'inventory.route.g.dart';

class InventoryRoute {
  static const inventory = "/inventory";
  static const records = '$inventory/records';
  static const inventoryScanScreen = '$inventory/scan/:id';
}

@TypedGoRoute<InventoryMainRoute>(path: InventoryRoute.inventory)
class InventoryMainRoute extends GoRouteData with $InventoryMainRoute {
  const InventoryMainRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const BatchMainPage();
}

@TypedGoRoute<InventoryScanScreen>(path: InventoryRoute.inventoryScanScreen)
class InventoryScanScreen extends GoRouteData with $InventoryScanScreen {
  final int id;
  const InventoryScanScreen({required this.id});

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ScannerPage(batchId: id);
}

// final List<RouteBase> inventoryRoutes = [
//   GoRoute(
//     path: InventoryRoute.inventory,
//     builder: (_, _) => const InventoryMainScreen(),
//   ),
//   GoRoute(path: InventoryRoute.records, builder: (_, _) => const RecordsPage()),
// ];
