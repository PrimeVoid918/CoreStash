import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prac1/src/features/inventory/data/inventory_providers.dart';
import 'package:prac1/src/features/inventory/domain/inventory_model.dart';
import 'package:prac1/src/features/inventory/widgets/Cards/inventory.card.dart';

class RecordsPage extends ConsumerWidget {
  // Changed from StatelessWidget
  const RecordsPage({super.key});
  void _showItemDetails(BuildContext context, InventoryModel item) {
    // debugPrint(
    //   "============================ item: $item ============================",
    // );
    print(
      "============================ item: $item ============================",
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the modal to grow with content
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // Important: makes modal only as tall as content
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Item Details",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Divider(),
              const SizedBox(height: 10),
              Text("Description:", style: TextStyle(color: Colors.grey[600])),
              Text(
                item.description,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text("QR Code Data:", style: TextStyle(color: Colors.grey[600])),
              SelectableText(
                item.qrCode,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pop(context), // This closes the modal
                  child: const Text("CLOSE"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryAsync = ref.watch(inventoryListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Inventory Records"), centerTitle: true),
      body: inventoryAsync.when(
        data: (items) => _buildList(items),
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
    );
  }

  Widget _buildList(List<InventoryModel> items) {
    if (items.isEmpty) return const Center(child: Text("No records found."));

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return InventoryCard(
          item: item,

          onTap: () => _showItemDetails(context, item),
        );
      },
    );
  }
}
