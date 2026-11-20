import 'dart:math';

import '../entities/care_action.dart';
import '../entities/pet_state.dart';
import '../rules/game_rules.dart';

typedef ActionResult = ({PetState state, bool accepted});

ActionResult applyAction(PetState state, CareAction action, DateTime now) {
  ActionResult reject() => (state: state, accepted: false);

  ActionResult accept(PetState next) =>
      (state: next.copyWith(lastCareAt: now), accepted: true);

  switch (action) {
    case CareAction.feed:
      if (state.fullness >= GameRules.maxMeter || state.isSick) {
        return reject();
      }
      return accept(
        state.copyWith(
          fullness: min(
            state.fullness + GameRules.feedFullness,
            GameRules.maxMeter,
          ),
          weight: state.weight + GameRules.feedWeight,
          poopDueAt: [...state.poopDueAt, now.add(GameRules.poopDelay)],
          isMoody: false,
          lowBothFor: Duration.zero,
        ),
      );

    case CareAction.play:
      if (state.isAsleepAt(now) || state.isSick || state.isMoody) {
        return reject();
      }
      return accept(
        state.copyWith(
          happiness: min(
            state.happiness + GameRules.playHappiness,
            GameRules.maxMeter,
          ),

          weight: max(state.weight + GameRules.playWeight, GameRules.minWeight),
        ),
      );

    case CareAction.snack:
      List<DateTime> recent =
          [
            ...state.recentSnacks.where(
              (s) => now.difference(s) < GameRules.snackWindow,
            ),
          ] +
          [now];
      bool toMany = recent.length > GameRules.maxSnacksPerHour;

      PetState next = state.copyWith(
        happiness: min(
          state.happiness + GameRules.snackHappiness,
          GameRules.maxMeter,
        ),
        fullness: min(
          state.fullness + GameRules.snackFullness,
          GameRules.maxMeter,
        ),
        weight: state.weight + GameRules.snackWeight,
        recentSnacks: recent,
        isSick: state.isSick || toMany,
      );

      if (toMany) {
        next = next.copyWith(
          zeroNeedFor: Duration.zero,
          heavyPoopFor: Duration.zero,
        );
      }

      return accept(next);
    case CareAction.clean:
      return reject();
    case CareAction.medicine:
      return reject();
    case CareAction.lights:
      return reject();
  }
}
