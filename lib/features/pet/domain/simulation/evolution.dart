import '../entities/care_style.dart';
import '../entities/pet_character.dart';
import '../rules/game_rules.dart';

/// Gaya dengan skor tertinggi menang bila unggul > 20% atas skor kedua (K4, D10).
/// Selain itu, termasuk semua 0, hasilnya Si Seimbang (D9).
PetCharacter chooseCharacter(CareStyle style) {
  final scores = [
    (PetCharacter.atletis, style.plays),
    (PetCharacter.gembul, style.snacks),
    (PetCharacter.rapi, style.timelyCleans),
    (
      PetCharacter.mandiri,
      style.neglectedFor.inMinutes ~/ GameRules.neglectMinutesPerPoint,
    ),
  ]..sort((a, b) => b.$2.compareTo(a.$2));

  final (top, topScore) = scores[0];
  final secondScore = scores[1].$2;
  return topScore > secondScore * GameRules.evolutionLeadRatio
      ? top
      : PetCharacter.seimbang;
}
