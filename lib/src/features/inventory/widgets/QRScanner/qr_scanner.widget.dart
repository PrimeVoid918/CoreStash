import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // Import the package

class QRScannerWidget extends StatefulWidget {
  final Function(String code) onScan;
  final Color overlayColor;

  const QRScannerWidget({
    super.key,
    required this.onScan,
    this.overlayColor = Colors.black54,
  });

  @override
  State<QRScannerWidget> createState() => _QRScannerWidgetState();
}

class _QRScannerWidgetState extends State<QRScannerWidget> {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  @override
  void initState() {
    super.initState();
    // Start the camera session
    controller.start();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  widget.onScan(barcode.rawValue!);
                }
              }
            },
          ),
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
