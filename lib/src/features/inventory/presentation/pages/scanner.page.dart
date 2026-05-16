import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prac1/src/features/inventory/widgets/QRScanner/qr_scanner.widget.dart';
import 'package:prac1/src/features/inventory/controller/notifier/inventory_form.notifier.dart'
    as inventory_notifier;

class ScannerPage extends ConsumerStatefulWidget {
  final int batchId;

  const ScannerPage({super.key, required this.batchId});

  @override
  ConsumerState<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends ConsumerState<ScannerPage> {
  @override
  void dispose() {
    super.dispose();
  }

  void _handleSubmitScannerItem() async {
    final success = await ref
        .read(inventory_notifier.inventoryFormControllerProvider.notifier)
        .submitForm(batchId: widget.batchId);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Item Saved")));
    }
  }

  void _qrCodeValue(String qr) {
    ref
        .read(inventory_notifier.inventoryFormControllerProvider.notifier)
        .setQr(qr);
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(
      inventory_notifier.inventoryFormControllerProvider,
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("qr code: ${formState.qrCode}"),
              SizedBox(
                height: 300,
                child: QRScannerWidget(onScan: _qrCodeValue),
              ),
              ElevatedButton(
                onPressed: (formState.qrCode == "Nothing scanned yet")
                    ? null
                    : _handleSubmitScannerItem,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text("LOG TO CONSOLE"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
