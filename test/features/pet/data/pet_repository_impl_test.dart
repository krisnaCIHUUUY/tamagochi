import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tamagochi/features/pet/data/models/pet_save_file.dart';
import 'package:tamagochi/features/pet/data/repositories/pet_repository_impl.dart';

import '../../../helpers/pet_state_fixtures.dart';

void main() {
  late Directory dir;
  late PetRepositoryImpl repository;

  final petA = awakePet(fullness: 40);
  final petB = awakePet(fullness: 70);

  File file(String name) => File('${dir.path}/$name');

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('pet_repository_test');
    repository = PetRepositoryImpl(dir);
  });

  tearDown(() => dir.delete(recursive: true));

  test('load returns null when no file', () async {
    expect(await repository.load(), isNull);
  });

  test('save then load returns equal state', () async {
    await repository.save(petA);

    expect(await PetRepositoryImpl(dir).load(), petA);
    expect(file('pet.json.tmp').existsSync(), false);
  });

  test('save replaces the previous save', () async {
    await repository.save(petA);
    await repository.save(petB);

    expect(await repository.load(), petB);
  });

  test('leftover pet.json.tmp is ignored', () async {
    await repository.save(petA);
    await file('pet.json.tmp').writeAsString('{"schemaVersion": 1, "pe');

    expect(await repository.load(), petA);

    await repository.save(petB);
    expect(await repository.load(), petB);
  });

  group('corrupt pet.json is renamed and load returns null', () {
    Future<void> expectMovedAside(List<int> bytes) async {
      await file('pet.json').writeAsBytes(bytes);

      expect(await repository.load(), isNull);
      expect(file('pet.json').existsSync(), false);
      expect(await file('pet.json.corrupt').readAsBytes(), bytes);
    }

    test('half-written JSON', () async {
      await expectMovedAside(utf8.encode('{"schemaVersion": 1, "pe'));
    });

    test('empty file', () async {
      await expectMovedAside([]);
    });

    test('valid JSON that is not an object', () async {
      await expectMovedAside(utf8.encode('[]'));
    });

    test('invalid UTF-8 bytes', () async {
      await expectMovedAside([0xff, 0xfe, 0x00]);
    });

    test('future schema version', () async {
      await expectMovedAside(
        utf8.encode(
          jsonEncode({
            ...encodeSave(petA),
            'schemaVersion': currentSchemaVersion + 1,
          }),
        ),
      );
    });

    test('D16: a newer corrupt file replaces the older one', () async {
      await file('pet.json.corrupt').writeAsString('lama');
      await expectMovedAside(utf8.encode('baru'));
    });

    test('saving afterwards keeps the corrupt file', () async {
      await expectMovedAside(utf8.encode('rusak'));
      await repository.save(petA);

      expect(await repository.load(), petA);
      expect(file('pet.json.corrupt').existsSync(), true);
    });
  });

  test('concurrent saves keep last state', () async {
    await Future.wait([repository.save(petA), repository.save(petB)]);

    expect(await repository.load(), petB);
  });

  test('a failed save reports its error and does not block the next', () async {
    // Folder di tempat file sementara membuat penulisan gagal.
    final blocker = Directory('${dir.path}/pet.json.tmp')..createSync();
    await expectLater(
      repository.save(petA),
      throwsA(isA<FileSystemException>()),
    );

    blocker.deleteSync();
    await repository.save(petB);
    expect(await repository.load(), petB);
  });
}
