import 'package:flutter/foundation.dart' as debugger;
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

import 'package:corestash/src/features/inventory/data/inventory_providers.dart'
    as providers;
import 'package:corestash/src/features/inventory/data/inventory_repository.dart'
    as repo;

import 'package:corestash/src/core/database/app_database.dart' as db;

import 'package:corestash/src/features/inventory/controller/states/inventory_form.state.dart'
    as ui_form_data;

enum ScanResult { success, duplicate, error }

class InventoryFormNotifier
    extends riverpod.AutoDisposeNotifier<ui_form_data.InventoryFormState> {
  @override
  ui_form_data.InventoryFormState build() {
    return ui_form_data.InventoryFormState();
  }

  void setQr(String value) {
    state = state.copyWith(qrCode: value);
  }

  Future<ScanResult> submitForm({required int batchId}) async {
    if (state.isSaving) return ScanResult.error;

    state = state.copyWith(isSaving: true);

    final repo.InventoryRepository inventoryRepo = ref.read(
      providers.inventoryRepoProvider,
    );

    try {
      // Ask the repository if this combination exists
      final bool isDuplicate = await inventoryRepo.checkDuplicate(
        qrCode: state.qrCode,
        batchId: batchId,
      );

      if (isDuplicate) {
        state =
            ui_form_data.InventoryFormState(); // Flush out stale cache data strings
        return ScanResult.duplicate; // Abort early, signal UI layer
      }

      // If unique, perform the insert
      await inventoryRepo.saveScannedItem(
        qrCode: state.qrCode,
        batchId: batchId,
      );

      state = ui_form_data.InventoryFormState();
      return ScanResult.success;
    } catch (e) {
      debugger.debugPrint("Drift Save Error: $e");
      return ScanResult.error;
    } finally {
      if (state.isSaving) {
        state = state.copyWith(isSaving: false);
      }
    }
  }
}

final inventoryFormControllerProvider =
    riverpod.AutoDisposeNotifierProvider<
      InventoryFormNotifier,
      ui_form_data.InventoryFormState
    >(() {
      return InventoryFormNotifier();
    });
