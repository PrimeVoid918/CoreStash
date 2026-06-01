import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prac1/src/features/batch/data/batch_providers.dart'
    as batch_provider;
import 'package:prac1/src/features/inventory/data/inventory_providers.dart'
    as inventory_provider;
import 'package:prac1/src/features/inventory/presentation/inventory.route.dart'
    as inventory_route;
import 'package:prac1/src/core/services/csv_service.provider.dart' as csv_service;

final executeCsvExportActionProvider = Provider((ref) {
  final batchRepo = ref.watch(batch_provider.batchRepoProvider);
  final csvService = ref.watch(
    csv_service.csvServiceProvider,
  ); // 👈 Injected statelessly from core

  return (int batchId) async {
    // 1. Pull the data configurations safely from the features database layer
    final batchData = await batchRepo.fetchBatchInfo(batchId);
    final String exportName = batchData?.name ?? "$batchId";

    // 2. Pull down the raw matrix rows arrays
    final List<List<dynamic>> csvRows = await batchRepo.generateCsvRows(
      batchId,
    );

    // 3. Delegate the temporary filesystem construction to our Core tool
    final File? tempFile = await csvService.createTempCsvFile(
      fileName: exportName,
      rows: csvRows,
    );

    if (tempFile == null) return false;

    // 4. Fire the native OS download dialogue prompt frame
    return await csvService.presentSaveDialog(tempFile);
  };
});

class BatchListPage extends ConsumerWidget {
  final int batchId;

  const BatchListPage({super.key, required this.batchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryAsync = ref.watch(
      inventory_provider.inventoryListByBatchProvider(batchId),
    );
    final batchInfoAsync = ref.watch(batch_provider.batchInfoProvider(batchId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Batch Details",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined, color: Colors.blue),
            tooltip: "Export to CSV",
            onPressed: () => _handleCsvExport(context, ref),
          ),
          batchInfoAsync.maybeWhen(
            data: (batch) => batch == null
                ? const SizedBox.shrink()
                : IconButton(
                    icon: const Icon(
                      Icons.edit_note_rounded,
                      color: Colors.amber,
                      size: 26,
                    ),
                    tooltip: "Edit Name/Desc",
                    onPressed: () => _showEditBatchModal(
                      context,
                      ref,
                      batch.name,
                      batch.description,
                    ),
                  ),
            orElse: () => const SizedBox.shrink(),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
            tooltip: "Delete Batch",
            onPressed: () {
              showDeleteConfirmationDialog(
                context: context,
                title: "Delete Batch?",
                description: "This removes the whole batch.",
                onConfirm: () async {
                  final repo = ref.read(batch_provider.batchRepoProvider);
                  final success = await repo.deleteBatch(batchId);

                  if (success && context.mounted) {
                    ref.invalidate(batch_provider.batchListProvider);
                    Navigator.of(context).pop();
                  }
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: inventoryAsync.when(
          data: (items) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _BatchHeaderView(
                    batchInfoAsync: batchInfoAsync,
                    batchId: batchId,
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF2F2F2),
                ),
                Expanded(
                  child: items.isEmpty
                      ? const _EmptyScannedStateView()
                      : _InventoryListView(items: items, batchId: batchId),
                ),
                _StickyBottomActionBar(batchId: batchId),
              ],
            );
          },
          error: (err, _) => Center(
            child: Text(
              "Error: $err",
              style: const TextStyle(color: Colors.red),
            ),
          ),
          loading: () =>
              const Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
        ),
      ),
    );
  }

  Future<void> _handleCsvExport(BuildContext context, WidgetRef ref) async {
    try {
      final bool wasSaved = await ref.read(executeCsvExportActionProvider)(
        batchId,
      );
      if (wasSaved && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File successfully saved to directory!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export Failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showEditBatchModal(
    BuildContext context,
    WidgetRef ref,
    String currentName,
    String currentDesc,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss Edit Modal",
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: _EditBatchModalSheet(
              batchId: batchId,
              initialName: currentName,
              initialDesc: currentDesc,
            ),
          ),
        );
      },
    );
  }

  Future<void> showDeleteConfirmationDialog({
    required BuildContext context,
    required String title,
    required String description,
    required Future<void> Function() onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await onConfirm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text("Delete Permanently"),
            ),
          ],
        );
      },
    );
  }
}

class _EditBatchModalSheet extends ConsumerStatefulWidget {
  final int batchId;
  final String initialName;
  final String initialDesc;

  const _EditBatchModalSheet({
    required this.batchId,
    required this.initialName,
    required this.initialDesc,
  });

  @override
  ConsumerState<_EditBatchModalSheet> createState() =>
      _EditBatchModalSheetState();
}

class _EditBatchModalSheetState extends ConsumerState<_EditBatchModalSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _descController = TextEditingController(text: widget.initialDesc);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Update Batch Metadata",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Batch Name"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              keyboardType: TextInputType.multiline,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Description",
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isSaving
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    elevation: 0,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Save Changes"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() async {
    final updatedName = _nameController.text.trim();
    final updatedDesc = _descController.text.trim();

    if (updatedName.isEmpty) return;

    setState(() => _isSaving = true);

    final repo = ref.read(batch_provider.batchRepoProvider);
    final success = await repo.updateBatch(
      batchId: widget.batchId,
      name: updatedName,
      description: updatedDesc,
    );

    if (!mounted) return;

    if (success) {
      ref.invalidate(batch_provider.batchInfoProvider(widget.batchId));
      ref.invalidate(batch_provider.batchListProvider);
      Navigator.of(context).pop();
    } else {
      setState(() => _isSaving = false);
    }
  }
}

class _BatchHeaderView extends StatelessWidget {
  final AsyncValue batchInfoAsync;
  final int batchId;

  const _BatchHeaderView({required this.batchInfoAsync, required this.batchId});

  @override
  Widget build(BuildContext context) {
    return batchInfoAsync.when(
      data: (batch) {
        return Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.folder_open_rounded,
                color: Colors.blue,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    batch?.name ?? "Batch #$batchId",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    batch?.description == null || batch!.description.isEmpty
                        ? "No description summary logged."
                        : batch.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      error: (e, _) => Text("Title Error: $e"),
      loading: () => const SizedBox(
        height: 50,
        child: Center(child: LinearProgressIndicator()),
      ),
    );
  }
}

class _EmptyScannedStateView extends StatelessWidget {
  const _EmptyScannedStateView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code_scanner_rounded,
              size: 54,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              "No Stock Tracked Yet",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Initialize the local camera loop targeting inventory components to populate this stream batch matrix.",
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

class _InventoryListView extends ConsumerWidget {
  final List items;
  final int batchId;

  const _InventoryListView({
    super.key,
    required this.items,
    required this.batchId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return Dismissible(
          key: Key(item.id.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.red.shade50.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade200, width: 1),
            ),
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Remove Item",
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.delete_rounded,
                  color: Colors.red.shade700,
                  size: 20,
                ),
              ],
            ),
          ),

          confirmDismiss: (direction) async {
            return await _showConfirmBottomSheet(context, item.qrCode);
          },

          onDismissed: (direction) {
            final repo = ref.read(inventory_provider.inventoryRepoProvider);
            repo.deleteInventoryItem(item.id);

            if (context.mounted) {
              ScaffoldMessenger.of(context).clearSnackBars();
            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                ref.invalidate(
                  inventory_provider.inventoryListByBatchProvider(batchId),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("'${item.qrCode}' successfully removed."),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            });
          },

          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
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
              leading: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.pin_drop_outlined,
                  color: Colors.black54,
                  size: 20,
                ),
              ),
              title: Text(
                item.qrCode,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  letterSpacing: 0.1,
                ),
              ),
              subtitle: Text(
                "${item.scannedAt}",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              trailing: Icon(
                Icons.chevron_left_rounded,
                color: Colors.grey.shade400,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool?> _showConfirmBottomSheet(
    BuildContext context,
    String titleCode,
  ) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Remove Scanned Item?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Are you sure you want to completely drop '$titleCode' from this current list tracking layout index?",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Keep Item",
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text("Delete"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StickyBottomActionBar extends StatelessWidget {
  final int batchId;

  const _StickyBottomActionBar({required this.batchId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.center_focus_weak_rounded, size: 20),
        label: const Text(
          "Launch Live Scanner",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        onPressed: () =>
            inventory_route.InventoryScanScreen(id: batchId).push(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
