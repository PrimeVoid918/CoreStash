import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prac1/src/features/inventory/widgets/QRScanner/qr_scanner.widget.dart';

class ScannerPage extends ConsumerStatefulWidget {
  const ScannerPage({super.key});

  @override
  ConsumerState<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends ConsumerState<ScannerPage> {
  bool _isCameraOpen = false;

  @override
  void dispose() {
    super.dispose();
  }

  void _updateResult(String code) {
    // Update the Notifier instead of local setState
    // ref.read(inventoryFormControllerProvider.notifier).setQr(code);

    setState(() {
      _isCameraOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final formState = ref.watch

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isCameraOpen)
                SizedBox(
                  height: 300,
                  child: QRScannerWidget(onScan: _updateResult),
                ),
              ElevatedButton.icon(
                onPressed: () => setState(() => _isCameraOpen = !_isCameraOpen),
                icon: Icon(_isCameraOpen ? Icons.close : Icons.camera_alt),
                label: Text("${_isCameraOpen ? "Close" : "Open"} Scanner"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
