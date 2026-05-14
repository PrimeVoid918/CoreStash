class InventoryModel {
  final int? id;
  final String qrCode;
  final String description;
  final DateTime scannedAt;

  InventoryModel({
    this.id,
    required this.qrCode,
    required this.description,
    required this.scannedAt,
  });

  // Convert Record to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'qrCode': qrCode,
      'description': description,
      // SQLite doesn't store DateTime, so we save it as a String
      'scannedAt': scannedAt.toIso8601String(),
    };
  }

  // Convert Map from SQLite back to Record object
  factory InventoryModel.fromMap(Map<String, dynamic> map) {
    return InventoryModel(
      id: map['id'],
      qrCode: map['qrCode'],
      description: map['description'],
      scannedAt: DateTime.parse(map['scannedAt']),
    );
  }
}
