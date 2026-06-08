import 'dart:async';
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
  // camera scan cooldown
  bool _isCooldownActive = false;

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(
      inventory_notifier.inventoryFormControllerProvider,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Scan Inventory Item",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        leading: const BackButton(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(child: QRScannerWidget(onScan: _qrCodeValue)),

          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.55),
                BlendMode.srcOut,
              ),
              child: Stack(
                children: [
                  Container(color: Colors.transparent),
                  Center(
                    child: Container(
                      height: 240,
                      width: 240,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Center(
            child: SizedBox(
              width: 242,
              height: 242,
              child: CustomPaint(
                painter: _ScannerReticlePainter(
                  borderColor: formState.isSaving || _isCooldownActive
                      ? Colors.amber
                      : Colors.blue.shade400,
                ),
              ),
            ),
          ),

          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 60.0, left: 24, right: 24),
                child: _ScanningStatusCard(formState: formState),
              ),
            ),
          ),

          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: formState.isSaving || _isCooldownActive
                            ? const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.amber,
                              )
                            : const Icon(
                                Icons.blur_on,
                                color: Colors.blue,
                                size: 16,
                              ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        formState.isSaving
                            ? "Saving to database..."
                            : _isCooldownActive
                            ? "Scanner cooling down..."
                            : "Align barcode within brackets",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmitScannerItem() async {
    final result = await ref
        .read(inventory_notifier.inventoryFormControllerProvider.notifier)
        .submitForm(batchId: widget.batchId);

    if (!mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();

    if (result == inventory_notifier.ScanResult.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle_rounded, color: Colors.white),
              SizedBox(width: 12),
              Text(
                "Item cataloged successfully!",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 1500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else if (result == inventory_notifier.ScanResult.duplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 12),
              Text(
                "This item is already on the database!",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          backgroundColor: Colors.amber.shade800,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 1500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else if (result == inventory_notifier.ScanResult.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.error_outline_rounded, color: Colors.white),
              SizedBox(width: 12),
              Text("An error occurred while saving item."),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 1500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _qrCodeValue(String qr) async {
    final currentState = ref.read(
      inventory_notifier.inventoryFormControllerProvider,
    );
    final notifier = ref.read(
      inventory_notifier.inventoryFormControllerProvider.notifier,
    );

    if (currentState.isSaving || _isCooldownActive) return;
    if (currentState.qrCode == qr) return;

    setState(() {
      _isCooldownActive = true;
    });

    notifier.setQr(qr.trim());

    // notifier.setQr(qr);
    _handleSubmitScannerItem();

    // set timor lock
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isCooldownActive = false;
        });
      }
    });
  }
}

class _ScanningStatusCard extends StatelessWidget {
  final dynamic formState;

  const _ScanningStatusCard({required this.formState});

  @override
  Widget build(BuildContext context) {
    final hasScanned =
        formState.qrCode.isNotEmpty &&
        formState.qrCode != "Nothing scanned yet";

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            hasScanned ? Icons.qr_code_2_rounded : Icons.camera_alt_outlined,
            color: hasScanned ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  hasScanned ? "Last Scanned Value" : "Scanner Status",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formState.qrCode.isEmpty
                      ? "Waiting for target..."
                      : formState.qrCode,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScannerReticlePainter extends CustomPainter {
  final Color borderColor;
  _ScannerReticlePainter({required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLength = 24.0;
    const radius = 16.0;

    canvas.drawPath(
      Path()
        ..moveTo(0, cornerLength)
        ..lineTo(0, radius)
        ..arcToPoint(
          const Offset(radius, 0),
          radius: const Radius.circular(radius),
        )
        ..lineTo(cornerLength, 0),
      paint,
    );

    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerLength, 0)
        ..lineTo(size.width - radius, 0)
        ..arcToPoint(
          Offset(size.width, radius),
          radius: const Radius.circular(radius),
        )
        ..lineTo(size.width, cornerLength),
      paint,
    );

    canvas.drawPath(
      Path()
        ..moveTo(0, size.height - cornerLength)
        ..lineTo(0, size.height - radius)
        ..arcToPoint(
          Offset(radius, size.height),
          radius: const Radius.circular(radius),
        )
        ..lineTo(cornerLength, size.height),
      paint,
    );

    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerLength, size.height)
        ..lineTo(size.width - radius, size.height)
        ..arcToPoint(
          Offset(size.width, size.height - radius),
          radius: const Radius.circular(radius),
        )
        ..lineTo(size.width, size.height - cornerLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(_ScannerReticlePainter oldDelegate) =>
      oldDelegate.borderColor != borderColor;
}
