import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:prac1/src/shared/widgets/modal_wapper.dart';
import 'package:prac1/src/features/batch/controller/notifier/batch_form.notifier.dart'
    as notifier;
import 'package:prac1/src/features/batch/data/batch_providers.dart' as provider;
import 'package:prac1/src/features/batch/presentation/batch.route.dart'
    as route;
import 'package:prac1/src/features/batch/presentation/batch.route.dart'
    as batch_router;

class BatchMainPage extends riverpod.ConsumerStatefulWidget {
  const BatchMainPage({super.key});

  @override
  riverpod.ConsumerState<BatchMainPage> createState() => _BatchMainPageState();
}

class _BatchMainPageState extends riverpod.ConsumerState<BatchMainPage> {
  bool _isBatchCreationModalOpen = false;

  final TextEditingController _batchFormController = TextEditingController();

  void handleSubmitBatchCreation() async {
    final success = await ref
        .read(notifier.batchFormControllerProvider.notifier)
        .submitForm();

    if (!mounted) return;

    if (success) {
      // THIS IS THE MISSING PIECE:
      // It tells the list provider to "reboot" and fetch fresh data from DB
      ref.invalidate(provider.batchListProvider);

      _batchFormController.clear();

      // Close the modal so the user sees the updated list
      setState(() {
        _isBatchCreationModalOpen = false;
      });
    }
  }

  // void _updateTable(){

  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formData = ref.watch(notifier.batchFormControllerProvider);

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Inventory Batches",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // 1. Watch the list provider
                  ref
                      .watch(provider.batchListProvider)
                      .when(
                        data: (batches) {
                          if (batches.isEmpty) {
                            return const Text("No batches found. Create one!");
                          }

                          // 2. Map your data to widgets
                          return Column(
                            children: batches
                                .map(
                                  (batch) => ListTile(
                                    title: Text(batch.name),
                                    subtitle: Text(batch.description),
                                    leading: const Icon(Icons.inventory_2),
                                    trailing: const Icon(Icons.chevron_right),
                                    onTap: () {
                                      batch_router.BatchListRoute(
                                        id: batch.id,
                                      ).push(context);
                                    },
                                  ),
                                )
                                .toList(),
                          );
                        },
                        // 3. Handle Loading state
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        // 4. Handle Error state
                        error: (err, stack) =>
                            Text("Error loading batches: $err"),
                      ),
                ],
              ),
            ),
          ),

          if (_isBatchCreationModalOpen) ...[
            GestureDetector(
              onTap: () {
                setState(() {
                  _isBatchCreationModalOpen = false;
                });
              },
              child: Container(
                color: Colors.black54, // Dim the background
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.all(
                  24.0,
                ), // Keeps it away from screen edges
                child: Material(
                  type: MaterialType
                      .transparency, // Fixes weird text formatting issues inside overlays
                  child: ModalWrapper(
                    title: "Create Batch",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          onChanged: (value) => ref
                              .read(
                                notifier.batchFormControllerProvider.notifier,
                              )
                              .setBatchName(value),
                          decoration: InputDecoration(
                            hintText: "Enter name",
                            // Optional: Show an error if name is empty and they tried to submit
                            errorText: formData.name.isEmpty
                                ? "Name is required"
                                : null,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          onChanged: (value) => ref
                              .read(
                                notifier.batchFormControllerProvider.notifier,
                              )
                              .setBatchDescription(value),
                          decoration: const InputDecoration(
                            hintText: "Enter description",
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: formData.isSaving
                              ? null
                              : handleSubmitBatchCreation,
                          child: formData.isSaving
                              ? const CircularProgressIndicator()
                              : const Text("Create Batch"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isBatchCreationModalOpen = true;
          });
          print("pressed the fab $_isBatchCreationModalOpen");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
