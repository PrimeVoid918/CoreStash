import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BatchMainPage extends ConsumerStatefulWidget {
  const BatchMainPage({super.key});

  @override
  ConsumerState<BatchMainPage> createState() => _BatchMainPageState();
}

class _BatchMainPageState extends ConsumerState<BatchMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Batch Screen")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [const Text("sample area here to be occupoted")],
          ),
        ),
      ),
    );
  }
}
