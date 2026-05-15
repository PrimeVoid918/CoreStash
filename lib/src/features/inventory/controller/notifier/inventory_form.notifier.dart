import 'package:flutter/foundation.dart' as debugger;
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

import 'package:prac1/src/features/inventory/data/inventory_providers.dart'
    as providers;
import 'package:prac1/src/features/inventory/data/inventory_repository.dart'
    as repo;

import 'package:prac1/src/core/database/app_database.dart' as db;

import 'package:prac1/src/features/inventory/controller/states/inventory_form.state.dart'
    as ui_form_data;

class InventoryFormNotifier
    extends riverpod.Notifier<ui_form_data.InventoryFormState> {
  @override
  ui_form_data.InventoryFormState build() {
    return ui_form_data.InventoryFormState();
  }

  void setQr(String value) {
    state = state.copyWith(qrCode: value);
  }

  Future<bool> submitForm({required int batchId}) async {
    final repo.InventoryRepository inventoryRepo = ref.read(
      providers.inventoryRepoProvider,
    );

    state = state.copyWith(isSaving: true);

    try {
      await inventoryRepo.saveScannedItem(
        qrCode: state.qrCode,
        batchId: batchId,
      );

      // ref.invalidate(providers.inventoryListProvider);

      state = ui_form_data.InventoryFormState();
      return true;
    } catch (e) {
      debugger.debugPrint("Drift Save Error: $e");
      return false;
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }
}

final inventoryFormControllerProvider =
    riverpod.NotifierProvider<
      InventoryFormNotifier,
      ui_form_data.InventoryFormState
    >(() {
      return InventoryFormNotifier();
    });
