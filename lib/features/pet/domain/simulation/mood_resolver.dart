import '../entities/care_action.dart';
import '../entities/life_stage.dart';
import '../entities/mood.dart';
import '../entities/pet_state.dart';
import '../rules/game_rules.dart';
import 'apply_action.dart';

/// Prioritas K11: tidur > sakit > murung > lapar > senang > biasa.
/// Telur selalu biasa.
Mood resolveMood(PetState state, DateTime now) {
  if (state.stage == LifeStage.egg) return Mood.neutral;
  if (state.isAsleepAt(now)) return Mood.asleep;
  if (state.isSick) return Mood.sick;
  if (state.isMoody) return Mood.moody;
  if (state.fullness <= GameRules.hungryMoodThreshold) return Mood.hungry;
  if (state.happiness >= GameRules.happyMoodThreshold) return Mood.happy;
  return Mood.neutral;
}

// D11: urutan prioritas titik panggilan. Camilan tidak pernah menambah kedekatan.
const _attentionOrder = [
  CareAction.medicine,
  CareAction.lights,
  CareAction.clean,
  CareAction.feed,
  CareAction.play,
];

/// D11: dibutuhkan = diterima `applyAction` dan menambah kedekatan (K7).
List<CareAction> neededActions(PetState state, DateTime now) => _attentionOrder
    .where((action) {
      final result = applyAction(state, action, now);
      return result.accepted && result.state.bond > state.bond;
    })
    .take(GameRules.maxAttention)
    .toList();
