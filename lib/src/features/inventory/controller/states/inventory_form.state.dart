class InventoryFormState {
  final String qrCode;
  final String description;
  final bool isSaving;

  InventoryFormState({
    this.qrCode = '',
    this.description = '',
    this.isSaving = false,
  });

  InventoryFormState copyWith({
    String? qrCode,
    String? description,
    bool? isSaving,
  }) {
    return InventoryFormState(
      qrCode: qrCode ?? this.qrCode,
      description: description ?? this.description,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
