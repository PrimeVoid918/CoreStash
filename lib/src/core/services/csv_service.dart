import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';

/// can read docx

class CsvService {
  const CsvService();

  Future<File?> createTempCsvFile({
    required String fileName,
    required List<List<dynamic>> rows,
  }) async {
    try {
      final cleanName = fileName
          .replaceAll(RegExp(r'[^\w\s]+'), '')
          .replaceAll(' ', '_');

      final csvString = csv.encode(rows);

      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$cleanName.csv');

      return await tempFile.writeAsString(csvString);
    } catch (_) {
      return null;
    }
  }

  Future<bool> presentSaveDialog(File file) async {
    try {
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final String? finalPath = await FlutterFileDialog.saveFile(
        params: params,
      );
      return finalPath != null;
    } catch (_) {
      return false;
    }
  }

  Future<List<List<dynamic>>?> pickAndParseCsv() async {
    try {
      // strictly filter for CSV files using Extensions and MIME Types
      const params = OpenFileDialogParams(
        copyFileToCacheDir: true,
        fileExtensionsFilter: [
          'csv',
        ], // filters on iOS and some Android file managers
        mimeTypesFilter: [
          'text/comma-separated-values',
          'text/csv',
          'application/csv',
        ],
      );

      debugPrint("CSV_DEBUG: Launching file picker...");
      final String? filePath = await FlutterFileDialog.pickFile(params: params);

      if (filePath == null) {
        debugPrint("CSV_DEBUG: User cancelled file picking.");
        return null;
      }

      // guard against weird file managers that ignore the system filter
      if (!filePath.toLowerCase().endsWith('.csv')) {
        debugPrint("CSV_DEBUG_ERROR: User forced a non-CSV file: $filePath");
        throw Exception("Invalid file format. Please select a .csv file.");
      }

      debugPrint("CSV_DEBUG: File verified at path: $filePath");
      final file = File(filePath);

      final List<int> bytes = await file.readAsBytes();
      final String rawContent = String.fromCharCodes(bytes);

      debugPrint(
        "CSV_DEBUG: Raw file length: ${rawContent.length} characters.",
      );

      final List<List<dynamic>> decoded = csv.decode(rawContent);
      debugPrint("CSV_DEBUG: Successfully parsed ${decoded.length} rows.");

      return decoded;
    } catch (e, stack) {
      debugPrint("CSV_DEBUG_ERROR: Failed during import sequence: $e");
      debugPrint("CSV_DEBUG_STACK: $stack");
      rethrow; // rethrow so Red UI SnackBar can catch the "Invalid file format" message!
    }
  }
}
