import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:corestash/src/features/batch/presentation/pages/main.page.dart';
import 'package:corestash/src/features/batch/presentation/pages/batch.list.page.dart';

part 'batch.route.g.dart';

class BatchRoute {
  static const batch = '/batch';
  static const batchList = '/batch-list/:id';
}

@TypedGoRoute<BatchMainRoute>(path: BatchRoute.batch)
class BatchMainRoute extends GoRouteData with $BatchMainRoute {
  const BatchMainRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const BatchMainPage();
}

@TypedGoRoute<BatchListRoute>(path: BatchRoute.batchList)
class BatchListRoute extends GoRouteData with $BatchListRoute {
  final int id;
  const BatchListRoute({required this.id});

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      BatchListPage(batchId: id);
}
