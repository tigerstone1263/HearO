class SaveSlot {
  final String id;
  final String label;
  final String detail;
  final double completion;

  const SaveSlot({
    required this.id,
    required this.label,
    required this.detail,
    required this.completion,
  });
}

class HomeState {
  final bool isStarting;
  final String? selectedSaveId;
  final List<SaveSlot> saves;

  const HomeState({
    this.isStarting = false,
    this.selectedSaveId,
    this.saves = const [],
  });

  HomeState copyWith({
    bool? isStarting,
    String? selectedSaveId,
    List<SaveSlot>? saves,
  }) {
    return HomeState(
      isStarting: isStarting ?? this.isStarting,
      selectedSaveId: selectedSaveId ?? this.selectedSaveId,
      saves: saves ?? this.saves,
    );
  }
}
