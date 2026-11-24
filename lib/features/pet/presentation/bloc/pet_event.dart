import '../../domain/entities/care_action.dart';

sealed class PetEvent {
  const PetEvent();
}

final class PetStarted extends PetEvent {
  const PetStarted();
}

final class PetTicked extends PetEvent {
  const PetTicked();
}

final class PetResumed extends PetEvent {
  const PetResumed();
}

final class PetPaused extends PetEvent {
  const PetPaused();
}

final class CareActionPressed extends PetEvent {
  const CareActionPressed(this.action);

  final CareAction action;
}

final class PickUpPressed extends PetEvent {
  const PickUpPressed();
}

final class RevealSeen extends PetEvent {
  const RevealSeen();
}
