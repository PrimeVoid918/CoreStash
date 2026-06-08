import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prac1/src/shared/widgets/modal_wapper.dart';
import 'package:prac1/src/features/batch/controller/notifier/batch_form.notifier.dart'
    as notifier;
import 'package:prac1/src/features/batch/data/batch_providers.dart' as provider;
import 'package:prac1/src/features/batch/presentation/batch.route.dart'
    as batch_router;
import 'package:prac1/src/core/services/csv/csv_service.provider.dart'
    as csv_service;

class BatchMainPage extends ConsumerWidget {
  const BatchMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final batchListAsync = ref.watch(provider.batchListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          "Inventory Batches",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: batchListAsync.when(
          data: (batches) {
            if (batches.isEmpty) {
              return const _EmptyBatchesView();
            }
            return _BatchListView(batches: batches);
          },
          loading: () =>
              const Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
          error: (err, _) => Center(
            child: Text(
              "Error loading batches: $err",
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: "btn_batch_actions",
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 4,
        onPressed: () => _showActionMenuBottomSheet(context, ref),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  void _showActionMenuBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 16.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    "Batch Actions",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.create_new_folder_outlined,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  title: const Text(
                    "Create New Empty Batch",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: const Text(
                    "Manually set up a brand new warehouse stream session",
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showCreateBatchModal(context, ref);
                  },
                ),
                const Divider(height: 16, thickness: 0.5),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.file_open_outlined,
                      color: Colors.green.shade700,
                    ),
                  ),
                  title: const Text(
                    "Import Batch List(.csv)",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: const Text(
                    "Parse internal storage table files straight into database tables",
                  ),

                  onTap: () => _handleCsvImportAction(context, ref),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCreateBatchModal(BuildContext context, WidgetRef ref) {
    ref.invalidate(notifier.batchFormControllerProvider);
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss Batch Modal",
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: _BatchCreationModalSheet(),
          ),
        );
      },
    );
  }

  Future<void> _handleCsvImportAction(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final csvService = ref.read(csv_service.csvServiceProvider);
      final List<List<dynamic>>? parsedMatrix = await csvService
          .pickAndParseCsv();

      if (parsedMatrix == null || parsedMatrix.isEmpty) {
        return;
      }

      if (context.mounted) {
        Navigator.of(context).pop();
      }

      final batchRepo = ref.read(provider.batchRepoProvider);
      await batchRepo.importBatchFromRows(parsedMatrix);
      ref.invalidate(provider.batchListProvider);

      messenger.showSnackBar(
        SnackBar(
          content: Text('Safely imported "${parsedMatrix.length - 1}" items!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('IMPORT_CRASH:$e\n$stackTrace');
      messenger.showSnackBar(
        SnackBar(
          content: const Text(
            'Error occurred: Duplicate QR Code or invalid layout data found.',
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }
}

class _BatchListView extends StatelessWidget {
  final List batches;

  const _BatchListView({required this.batches});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: batches.length,
      itemBuilder: (context, index) {
        final batch = batches[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.inventory_2_outlined, color: Colors.blue),
            ),
            title: Text(
              batch.name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            subtitle: Text(
              batch.description.isEmpty
                  ? "No description summary added."
                  : batch.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: Colors.black26,
            ),
            onTap: () {
              batch_router.BatchListRoute(id: batch.id).push(context);
            },
          ),
        );
      },
    );
  }
}

class _BatchCreationModalSheet extends ConsumerStatefulWidget {
  const _BatchCreationModalSheet();

  @override
  ConsumerState<_BatchCreationModalSheet> createState() =>
      _BatchCreationModalSheetState();
}

class _BatchCreationModalSheetState
    extends ConsumerState<_BatchCreationModalSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  bool _isNameDirty = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submitData() async {
    setState(() => _isNameDirty = true);

    final formData = ref.read(notifier.batchFormControllerProvider);
    if (formData.name.trim().isEmpty) return;

    final success = await ref
        .read(notifier.batchFormControllerProvider.notifier)
        .submitForm();

    if (!mounted) return;

    if (success) {
      ref.invalidate(provider.batchListProvider);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final formData = ref.watch(notifier.batchFormControllerProvider);

    return Material(
      type: MaterialType.transparency,
      child: ModalWrapper(
        title: "Create Batch",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              onChanged: (value) {
                if (!_isNameDirty) setState(() => _isNameDirty = true);
                ref
                    .read(notifier.batchFormControllerProvider.notifier)
                    .setBatchName(value);
              },
              decoration: InputDecoration(
                labelText: "Batch Name",
                hintText: "e.g., Morning Shift Sorting",
                alignLabelWithHint: true,
                errorText: (_isNameDirty && formData.name.trim().isEmpty)
                    ? "Name is required"
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _descController,
              onChanged: (value) => ref
                  .read(notifier.batchFormControllerProvider.notifier)
                  .setBatchDescription(value),
              keyboardType: TextInputType.multiline,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Description",
                hintText:
                    "Enter batch notes, location details, or operational instructions...",
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 28),

            ElevatedButton(
              onPressed: formData.isSaving || formData.name.trim().isEmpty
                  ? null
                  : _submitData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: formData.isSaving
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      "Create Batch",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyBatchesView extends StatelessWidget {
  const _EmptyBatchesView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 48,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            const Text(
              "No Batches Found",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              "Tap the floating add icon button right below to provision a new warehouse collection batch instance.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
