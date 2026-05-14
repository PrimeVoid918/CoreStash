class BatchFormState {
  final String name;
  final String description;
  final bool isSaving;

  BatchFormState({
    this.name = '',
    this.description = '',
    this.isSaving = false,
  });

  BatchFormState copyWith({String? name, String? description, bool? isSaving}) {
    return BatchFormState(
      name: name ?? this.name,
      description: description ?? this.description,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
