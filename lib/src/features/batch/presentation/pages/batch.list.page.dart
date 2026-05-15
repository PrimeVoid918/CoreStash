import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prac1/src/features/batch/data/batch_providers.dart'
    as bath_provider;
import 'package:prac1/src/features/inventory/data/inventory_providers.dart'
    as inventory_provider;
import 'package:prac1/src/features/inventory/presentation/inventory.route.dart'
    as inventory_route;

class BatchListPage extends ConsumerStatefulWidget {
  final int batchId;

  const BatchListPage({super.key, required this.batchId});

  @override
  ConsumerState<BatchListPage> createState() => _BatchListPageState();
}

class _BatchListPageState extends ConsumerState<BatchListPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inventory = ref.watch(
      inventory_provider.inventoryListByBatchProvider(widget.batchId),
    );

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.00),
              child: Column(
                children: [
                  Text("Inventory Batch List ${widget.batchId}"),
                  inventory.when(
                    data: (inventory) {
                      if (inventory.isEmpty) {
                        return const Text("Nothing is beingg scanned yet");
                      }

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            ...inventory.map(
                              (item) => ListTile(
                                leading: const Icon(Icons.inventory),
                                title: Text(item.qrCode),
                                tileColor: Colors.red,
                                subtitle: Text(item.scannedAt),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    error: (err, tack) => Text("Error loading batched: $err"),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                  ),

                  ElevatedButton(
                    onPressed: () => {
                      inventory_route.InventoryScanScreen(id: widget.batchId).push(context),
                      print("uh yawa? here theval for id ${widget.batchId}"),
                    },
                    child: const Text("Start Scanning"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
