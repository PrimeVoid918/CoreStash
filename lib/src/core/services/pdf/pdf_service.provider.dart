import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pdf_service.dart';

// Provides the singleton instance of your PDF Service throughout the application
final pdfServiceProvider = Provider<PdfService>((ref) {
  return const PdfService();
});
