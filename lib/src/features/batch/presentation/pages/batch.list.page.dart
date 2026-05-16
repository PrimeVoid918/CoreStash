import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
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

class BatchListPage extends ConsumerStatefulWidget {
  final int batchId;

  const BatchListPage({super.key, required this.batchId});

  @override
  ConsumerState<BatchListPage> createState() => _BatchListPageState();
}

class _BatchListPageState extends ConsumerState<BatchListPage> {
  @override
  Widget build(BuildContext context) {
    final inventory = ref.watch(
      inventory_provider.inventoryListByBatchProvider(widget.batchId),
    );

    final batchInfoAsync = ref.watch(
      batch_provider.batchInfoProvider(widget.batchId),
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.00),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              batchInfoAsync.when(
                data: (batch) {
                  final String currentName = batch?.name ?? "Unknown Batch";
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Batch: $currentName",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Description: ${batch?.description ?? ''}"),
                    ],
                  );
                },
                error: (e, _) => Text("Error loading batch title: $e"),
                loading: () => const LinearProgressIndicator(),
              ),

              const SizedBox(height: 20),

              inventory.when(
                data: (items) {
                  if (items.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text("Nothing is being scanned yet"),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        leading: const Icon(Icons.inventory),
                        title: Text(item.qrCode),
                        subtitle: Text(item.scannedAt),
                      );
                    },
                  );
                },
                error: (err, stack) => Text("Error loading batch items: $err"),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () => {
                  inventory_route.InventoryScanScreen(
                    id: widget.batchId,
                  ).push(context),
                },
                child: const Text("Start Scanning"),
              ),

              ElevatedButton(
                onPressed: () async {
                  try {
                    final batchData = await ref
                        .read(batch_provider.batchRepoProvider)
                        .fetchBatchInfo(widget.batchId);

                    final String safeName =
                        (batchData?.name ?? "${widget.batchId}")
                            .replaceAll(
                              RegExp(r'[^\w\s]+'),
                              '',
                            ) // Filter out illegal file path chars
                            .replaceAll(' ', '_');

                    final csvContent = await ref.read(
                      inventory_provider.exportCsvProvider,
                    )(widget.batchId);

                    final tempDir = await getTemporaryDirectory();

                    final tempFile = File('${tempDir.path}/$safeName.csv');
                    await tempFile.writeAsString(csvContent);

                    final params = SaveFileDialogParams(
                      sourceFilePath: tempFile.path,
                    );
                    await FlutterFileDialog.saveFile(params: params);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to save file: $e')),
                      );
                    }
                  }
                },
                child: const Text("Export to CSV"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
