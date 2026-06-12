import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:corestash/src/features/inventory/controller/notifier/inventory_form.notifier.dart'
    as inventory_notifier;
import 'package:corestash/src/features/inventory/presentation/inventory.route.dart'
    as route;
import 'package:corestash/src/features/inventory/widgets/QRScanner/qr_scanner.widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverod;

class InventoryMainScreen extends riverod.ConsumerStatefulWidget {
  const InventoryMainScreen({super.key});

  @override
  riverod.ConsumerState<InventoryMainScreen> createState() =>
      _InventoryMainScreenState();
}

class _InventoryMainScreenState
    extends riverod.ConsumerState<InventoryMainScreen> {
  bool _isCameraOpen = false;

  final TextEditingController _descriptionController = TextEditingController();

  void _handleSubmit() async {
    final result = await ref
        .read(inventory_notifier.inventoryFormControllerProvider.notifier)
        .submitForm(batchId: 1);

    if (!mounted) return;

    if (result == inventory_notifier.ScanResult.success) {
      _descriptionController.clear();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Logged to SQLite!")));
    }
  }

  void _updateResult(String code) {
    ref
        .read(inventory_notifier.inventoryFormControllerProvider.notifier)
        .setQr(code);

    setState(() {
      _isCameraOpen = false;
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(
      inventory_notifier.inventoryFormControllerProvider,
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Inventory")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () => context.push(route.InventoryRoute.records),
                child: const Text("Go to Records?"),
              ),
              const SizedBox(height: 10),
              Text(
                "Result: ${formState.qrCode}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              const SizedBox(height: 20),

              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Item Description",
                  hintText: "What is this item?",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (formState.qrCode == "Nothing scanned yet")
                      ? null
                      : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("LOG TO CONSOLE"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
