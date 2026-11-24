import '../entities/pet_state.dart';

abstract class PetRepository {
  /// `null` bila belum ada simpanan yang bisa dibaca.
  Future<PetState?> load();

  Future<void> save(PetState state);
}
