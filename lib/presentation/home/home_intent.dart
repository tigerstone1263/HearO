abstract class HomeIntent {}

class StartGameIntent extends HomeIntent {}

class SelectSaveIntent extends HomeIntent {
  SelectSaveIntent(this.slotId);

  final String slotId;
}
