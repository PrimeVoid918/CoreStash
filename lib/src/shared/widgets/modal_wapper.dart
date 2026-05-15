import 'package:flutter/material.dart';

class ModalWrapper extends StatelessWidget {
  final String title;
  final Widget child; // This allows you to pass in any widget

  const ModalWrapper({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Wrap content height
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const Divider(),
          const SizedBox(height: 10),
          child, // Injecting the passed-in content here
        ],
      ),
    );
  }
}