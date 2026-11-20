import 'dart:math';

import '../entities/care_action.dart';
import '../entities/life_stage.dart';
import '../entities/pet_state.dart';
import '../rules/game_rules.dart';

typedef ActionResult = ({PetState state, bool accepted});

ActionResult applyAction(PetState state, CareAction action, DateTime now) {
  ActionResult reject() => (state: state, accepted: false);

  // K7: kedekatan +1 hanya untuk aksi yang memang dibutuhkan pet.
  ActionResult accept(PetState next, {bool needed = false}) => (
    state: next.copyWith(
      lastCareAt: now,
      bond: needed ? next.bond + GameRules.bondPerNeededAction : next.bond,
    ),
    accepted: true,
  );

  // K10: pet sedang di rumah nenek; pemain harus Jemput dulu.
  if (state.onVacation) return reject();

  final counted = state.stage.index >= LifeStage.child.index;
  final style = state.careStyle;

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
          careStyle: counted
              ? style.copyWith(balancedActions: style.balancedActions + 1)
              : style,
        ),
        needed: state.fullness < GameRules.neededMeterThreshold,
      );

    case CareAction.play:
      if (state.isAsleepAt(now) || state.isSick || state.isMoody) {
        return reject();
      }
      return accept(
        state.copyWith(
          careStyle: counted ? style.copyWith(plays: style.plays + 1) : style,
          happiness: min(
            state.happiness + GameRules.playHappiness,
            GameRules.maxMeter,
          ),

          weight: max(state.weight + GameRules.playWeight, GameRules.minWeight),
        ),
        needed: state.happiness < GameRules.neededMeterThreshold,
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
        careStyle: counted ? style.copyWith(snacks: style.snacks + 1) : style,
      );

      if (toMany) {
        next = next.copyWith(
          zeroNeedFor: Duration.zero,
          heavyPoopFor: Duration.zero,
        );
      }

      return accept(next);

    case CareAction.clean:
      if (state.poop == 0) return reject();

      final timely =
          state.firstPoopAt != null &&
          now.difference(state.firstPoopAt!) <= GameRules.timelyCleanWindow;
      return accept(
        state.copyWith(
          poop: 0,
          firstPoopAt: null,
          careStyle: counted && timely
              ? style.copyWith(timelyCleans: style.timelyCleans + 1)
              : style,
        ),
        needed: true,
      );

    case CareAction.medicine:
      if (!state.isSick) return reject();
      final doses = state.medicineDoses + 1;
      final cured = doses >= GameRules.medicineDosesToCure;
      return accept(
        state.copyWith(isSick: !cured, medicineDoses: cured ? 0 : doses),
        needed: true,
      );

    case CareAction.lights:
      // K12: tidak pernah ditolak. Mematikan lampu saat tidur = dibutuhkan.
      final offAtNight = state.lightsOn && state.isAsleepAt(now);
      return accept(
        state.copyWith(
          lightsOn: !state.lightsOn,
          lightsOnAllSleep: state.lightsOnAllSleep && !offAtNight,
        ),
        needed: offAtNight,
      );
  }
}

/// "Jemput Tama": pulang dari liburan dalam keadaan segar.
PetState pickUp(PetState state, DateTime now) {
  if (!state.onVacation) return state;
  return state.copyWith(
    fullness: GameRules.pickUpMeter,
    happiness: GameRules.pickUpMeter,
    poop: 0,
    // Jadwal kotoran lama dibuang agar tidak muncul sekaligus setelah pulang.
    poopDueAt: const [],
    firstPoopAt: null,
    isSick: false,
    medicineDoses: 0,
    isMoody: false,
    onVacation: false,
    zeroNeedFor: Duration.zero,
    heavyPoopFor: Duration.zero,
    lowBothFor: Duration.zero,
    lastCareAt: now,
  );
}
