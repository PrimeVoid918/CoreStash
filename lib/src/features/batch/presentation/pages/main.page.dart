import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prac1/src/shared/widgets/modal_wapper.dart';
import 'package:prac1/src/features/batch/controller/notifier/batch_form.notifier.dart'
    as notifier;
import 'package:prac1/src/features/batch/data/batch_providers.dart' as provider;
import 'package:prac1/src/features/batch/presentation/batch.route.dart'
    as batch_router;

class BatchMainPage extends ConsumerWidget {
  const BatchMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final batchListAsync = ref.watch(provider.batchListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 2,
        onPressed: () => _showCreateBatchModal(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateBatchModal(BuildContext context) {
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
