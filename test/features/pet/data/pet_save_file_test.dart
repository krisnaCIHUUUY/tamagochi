import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tamagochi/features/pet/data/models/pet_save_file.dart';
import 'package:tamagochi/features/pet/domain/entities/care_style.dart';
import 'package:tamagochi/features/pet/domain/entities/pet_character.dart';

import '../../../helpers/pet_state_fixtures.dart';

void main() {
  final pet = awakePet().copyWith(
    character: PetCharacter.rapi,
    poopDueAt: [fixtureNow.add(const Duration(hours: 3))],
    firstPoopAt: fixtureNow,
    careStyle: const CareStyle(
      plays: 2,
      neglectedFor: Duration(minutes: 3, seconds: 30),
    ),
  );

  test('round-trip through JSON text', () {
    final json =
        jsonDecode(jsonEncode(encodeSave(pet))) as Map<String, dynamic>;

    expect(decodeSave(json), pet);
  });

  test('schemaVersion written as 1', () {
    expect(encodeSave(pet)['schemaVersion'], 1);
  });

  test('migrate v1 is identity', () {
    final json = encodeSave(pet);

    expect(migrate(json, 1), json);
  });

  group('FormatException (D14)', () {
    void expectRejected(Map<String, dynamic> json) =>
        expect(() => decodeSave(json), throwsFormatException);

    Map<String, dynamic> saveWithPet(Map<String, dynamic> changes) => {
      'schemaVersion': currentSchemaVersion,
      'pet': {...pet.toJson(), ...changes},
    };

    test('future version', () {
      expectRejected({
        ...encodeSave(pet),
        'schemaVersion': currentSchemaVersion + 1,
      });
    });

    test('version missing, not an int, or below 1', () {
      expectRejected({'pet': pet.toJson()});
      expectRejected({...encodeSave(pet), 'schemaVersion': '1'});
      expectRejected({...encodeSave(pet), 'schemaVersion': 0});
    });

    test('pet missing or not an object', () {
      expectRejected({'schemaVersion': currentSchemaVersion});
      expectRejected({'schemaVersion': currentSchemaVersion, 'pet': []});
    });

    test('required field missing', () {
      expectRejected(saveWithPet({'bornAt': null}));
    });

    test('field with wrong type', () {
      expectRejected(saveWithPet({'fullness': 'penuh'}));
    });

    test('unknown enum value', () {
      expectRejected(saveWithPet({'stage': 'dragon'}));
    });

    test('invalid date', () {
      expectRejected(saveWithPet({'lastUpdated': 'kemarin'}));
    });
  });
}
