import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'csv_service.dart';

final csvServiceProvider = Provider<CsvService>((ref) {
  return const CsvService();
});
