import 'package:flutter/foundation.dart' as debugger;
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:corestash/src/features/batch/controller/states/batch_form.state.dart'
    as ui_form_data;
import 'package:corestash/src/features/batch/data/batch_repository.dart' as repo;
import 'package:corestash/src/features/batch/data/batch_providers.dart'
    as providers;

class BatchFormNotifier extends riverpod.Notifier<ui_form_data.BatchFormState> {
  @override
  ui_form_data.BatchFormState build() {
    return ui_form_data.BatchFormState();
  }

  void setBatchName(String value) {
    state = state.copyWith(name: value);
  }

  void setBatchDescription(String value) {
    state = state.copyWith(description: value);
  }

  Future<bool> submitForm() async {
    final repo.BatchRepository batchRepo = ref.read(
      providers.batchRepoProvider,
    );
    state = state.copyWith(isSaving: true);

    try {
      await batchRepo.createBatch(
        name: state.name,
        description: state.description,
      );

      ref.invalidate(providers.batchListProvider);

      state = ui_form_data.BatchFormState();
      return true;
    } catch (e) {
      debugger.debugPrint("Drife Save Error: $e");
      return false;
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }
}

final batchFormControllerProvider =
    riverpod.NotifierProvider<BatchFormNotifier, ui_form_data.BatchFormState>(
      () {
        return BatchFormNotifier();
      },
    );
