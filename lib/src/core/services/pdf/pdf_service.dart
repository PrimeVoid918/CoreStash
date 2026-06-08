import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {
  const PdfService();

  Future<bool> exportInventoryReport({
    required int batchId,
    required String batchName,
    required String batchDesc,
    required List<dynamic> records,
  }) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      batchName,
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      "Generated: ${DateTime.now().toString().substring(0, 16)}",
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 8),

              pw.Text(
                "Description:",
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey700,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                batchDesc.isEmpty ? "No description provided." : batchDesc,
                style: const pw.TextStyle(
                  fontSize: 11,
                  color: PdfColors.black,
                  lineSpacing: 3.0,
                ),
              ),

              pw.SizedBox(height: 24),

              pw.TableHelper.fromTextArray(
                headers: ['ID', 'QR Code', 'Scanned At'],
                data: records.map((item) {
                  String formattedDate = "${item.scannedAt}";
                  try {
                    final parsed = DateTime.parse(item.scannedAt);
                    formattedDate =
                        "${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')} ${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}";
                  } catch (_) {}

                  return [item.id.toString(), item.qrCode, formattedDate];
                }).toList(),

                columnWidths: const {
                  0: pw.FixedColumnWidth(40),
                  1: pw.FlexColumnWidth(), // QR Code Column: Takes up all remaining flexible space
                  2: pw.FixedColumnWidth(110),
                },

                cellFormat: (index, data) => data.toString(),
                cellDecoration: (index, data, rowNum) =>
                    const pw.BoxDecoration(),

                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.grey200,
                ),
                cellHeight: 25,
                cellAlignment: pw.Alignment.centerLeft,
              ),
            ];
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: '$batchName.pdf',
      );

      return true;
    } catch (e) {
      debugPrint("PDF_EXPORT_ERROR: $e");
      return false;
    }
  }
}
