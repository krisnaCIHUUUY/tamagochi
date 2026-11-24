import 'package:freezed_annotation/freezed_annotation.dart';

import '../rules/game_rules.dart';
import 'care_style.dart';
import 'life_stage.dart';
import 'pet_character.dart';
import 'sleep_schedule.dart';
import 'utc_date_time_converter.dart';

part 'pet_state.freezed.dart';
part 'pet_state.g.dart';

@freezed
abstract class PetState with _$PetState {
  // explicitToJson: objek bersarang (CareStyle, SleepSchedule) ikut jadi Map di toJson.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true, converters: [UtcDateTimeConverter()])
  const factory PetState({
    required DateTime bornAt,
    required DateTime lastUpdated,
    required DateTime lastCareAt,
    required DateTime stageStartedAt,
    @Default(LifeStage.egg) LifeStage stage,
    PetCharacter? character,
    @Default(GameRules.startFullness) double fullness,
    @Default(GameRules.startHappiness) double happiness,
    @Default(0) int poop,
    @Default(<DateTime>[]) List<DateTime> poopDueAt,
    DateTime? firstPoopAt,
    @Default(false) bool isSick,
    @Default(0) int medicineDoses,
    @Default(GameRules.startWeight) int weight,
    @Default(0) double bond,
    @Default(true) bool lightsOn,
    @Default(false) bool lightsOnAllSleep,
    @Default(false) bool isMoody,
    @Default(false) bool onVacation,
    // Durasi kumulatif untuk aturan berbasis waktu (sakit, murung).
    @Default(Duration.zero) Duration zeroNeedFor,
    @Default(Duration.zero) Duration heavyPoopFor,
    @Default(Duration.zero) Duration lowBothFor,
    @Default(<DateTime>[]) List<DateTime> recentSnacks,
    @Default(CareStyle()) CareStyle careStyle,
    @Default(SleepSchedule()) SleepSchedule sleepSchedule,
    @Default(false) bool pendingReveal,
  }) = _PetState;

  factory PetState.newEgg(DateTime now) => PetState(
    bornAt: now,
    lastUpdated: now,
    lastCareAt: now,
    stageStartedAt: now,
  );

  factory PetState.fromJson(Map<String, Object?> json) =>
      _$PetStateFromJson(json);
}

extension PetStateTime on PetState {
  /// 1 hari nyata = 1 tahun pet.
  int ageYears(DateTime now) => now.difference(bornAt).inDays;

  bool isAsleepAt(DateTime now) => sleepSchedule.isAsleepAt(now);
}
