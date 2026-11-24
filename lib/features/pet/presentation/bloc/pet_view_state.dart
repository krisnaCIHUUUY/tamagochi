import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/care_action.dart';
import '../../domain/entities/mood.dart';
import '../../domain/entities/pet_state.dart';

part 'pet_view_state.freezed.dart';

@freezed
abstract class PetViewState with _$PetViewState {
  const factory PetViewState({
    /// `null` selama simpanan belum dimuat.
    PetState? pet,
    @Default(Mood.neutral) Mood mood,
    @Default(<CareAction>[]) List<CareAction> needed,
    PetReaction? reaction,
  }) = _PetViewState;
}

/// Hasil aksi terakhir. `seq` naik tiap aksi agar animasi terpicu ulang
/// walau aksi dan hasilnya sama.
@freezed
abstract class PetReaction with _$PetReaction {
  const factory PetReaction({
    required CareAction action,
    required bool accepted,
    required int seq,
  }) = _PetReaction;
}
