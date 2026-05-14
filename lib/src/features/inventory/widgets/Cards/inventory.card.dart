import 'package:flutter/material.dart';
import 'package:prac1/src/features/inventory/domain/inventory_model.dart';

class InventoryCard extends StatelessWidget {
  final InventoryModel item;
  final VoidCallback onTap; // Add this!

  const InventoryCard({
    super.key,
    required this.item,
    required this.onTap, // Add this!
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12), // Space between cards
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.inventory_2, color: Colors.white),
        ),
        title: Text(
          item.description,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("QR: ${item.qrCode}"),
        trailing: const Icon(Icons.chevron_right), // Arrow icon at the end
        onTap: onTap,
      ),
    );
  }
}
