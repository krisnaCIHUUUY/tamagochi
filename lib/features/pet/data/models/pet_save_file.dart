import '../../domain/entities/pet_state.dart';

const currentSchemaVersion = 1;

Map<String, dynamic> encodeSave(PetState pet) => {
  'schemaVersion': currentSchemaVersion,
  'pet': pet.toJson(),
};

/// D14: semua isi yang tidak bisa dibaca menjadi [FormatException].
PetState decodeSave(Map<String, dynamic> json) {
  final version = json['schemaVersion'];
  if (version is! int || version < 1 || version > currentSchemaVersion) {
    throw FormatException('Versi simpanan tidak dikenal: $version');
  }
  try {
    final migrated = migrate(json, version);
    return PetState.fromJson(migrated['pet'] as Map<String, dynamic>);
  } on TypeError catch (e) {
    // Field hilang atau salah tipe.
    throw FormatException('Isi simpanan rusak: $e');
  } on ArgumentError catch (e) {
    // Nilai enum tidak dikenal.
    throw FormatException('Isi simpanan rusak: $e');
  }
}

/// Menaikkan isi file (seluruh envelope) dari [fromVersion] ke
/// [currentSchemaVersion]. v1 adalah versi pertama, jadi belum ada perubahan.
Map<String, dynamic> migrate(Map<String, dynamic> json, int fromVersion) =>
    json;
