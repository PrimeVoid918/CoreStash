import 'dart:io';
import 'dart:async';
import 'package:csv/csv.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

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
    if (kIsWeb) {
      debugPrint("CSV_DEBUG: Launching Native Web HTML File Input...");
      final completer = Completer<List<List<dynamic>>?>();

      final html.FileUploadInputElement uploadInput =
          html.FileUploadInputElement()..accept = '.csv';

      uploadInput.onChange.listen((event) {
        final files = uploadInput.files;
        if (files == null || files.isEmpty) {
          completer.complete(null);
          return;
        }

        final file = files.first;
        final reader = html.FileReader();

        reader.readAsArrayBuffer(file);

        reader.onLoadEnd.listen((loadEvent) {
          try {
            final Uint8List fileBytes = Uint8List.fromList(
              reader.result as List<int>,
            );
            debugPrint(
              "CSV_DEBUG: Native Web picked successfully: ${file.name}",
            );

            final rawContent = const Utf8Decoder(
              allowMalformed: true,
            ).convert(fileBytes);
            debugPrint(
              "CSV_DEBUG: Raw file length: ${rawContent.length} characters.",
            );

            final List<List<dynamic>> decoded = csv.decode(rawContent);
            debugPrint(
              "CSV_DEBUG: Successfully parsed ${decoded.length} rows.",
            );

            completer.complete(decoded);
          } catch (e) {
            debugPrint("CSV_DEBUG_ERROR: Native Web parsing failed: $e");
            completer.completeError(e);
          }
        });
      });

      uploadInput.click();

      return completer.future;
    } else {
      try {
        debugPrint("CSV_DEBUG: Launching Mobile File Picker...");
        final FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['csv'],
          withData: true,
        );

        if (result == null || result.files.isEmpty) return null;
        final file = result.files.first;
        final Uint8List fileBytes = file.bytes!;
        final rawContent = const Utf8Decoder(
          allowMalformed: true,
        ).convert(fileBytes);
        return csv.decode(rawContent);
      } catch (e) {
        debugPrint("CSV_DEBUG_ERROR: Mobile picker failed: $e");
        return null;
      }
    }
  }

  Future<bool> exportCsv({
    required String fileName,
    required List<List<dynamic>> rows,
  }) async {
    try {
      final cleanName = fileName
          .replaceAll(RegExp(r'[^\w\s]+'), '')
          .replaceAll(' ', '_');

      final csvString = csv.encode(rows);

      if (kIsWeb) {
        final bytes = utf8.encode(csvString);
        final blob = html.Blob([bytes], 'text/csv');
        final url = html.Url.createObjectUrlFromBlob(blob);

        html.AnchorElement(href: url)
          ..setAttribute("download", "$cleanName.csv")
          ..click();

        html.Url.revokeObjectUrl(url);
        return true;
      } else {
        debugPrint("CSV_EXPORT: Mobile path triggered. Data: $csvString");
        return true;
      }
    } catch (e) {
      debugPrint("CSV_EXPORT_ERROR: $e");
      return false;
    }
  }
}
