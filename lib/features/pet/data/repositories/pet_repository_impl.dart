import 'dart:convert';
import 'dart:io';

import '../../domain/entities/pet_state.dart';
import '../../domain/repositories/pet_repository.dart';
import '../models/pet_save_file.dart';

class PetRepositoryImpl implements PetRepository {
  PetRepositoryImpl(Directory dir) : _path = '${dir.path}/pet.json';

  final String _path;

  // Antrean save: yang baru menunggu yang sebelumnya selesai.
  Future<void> _lastSave = Future.value();

  @override
  Future<PetState?> load() async {
    final file = File(_path);
    if (!await file.exists()) return null;
    // Byte dulu: readAsString melempar FileSystemException untuk UTF-8 rusak.
    final bytes = await file.readAsBytes();
    try {
      final json = jsonDecode(utf8.decode(bytes));
      if (json is! Map<String, dynamic>) {
        throw const FormatException('Simpanan bukan objek JSON');
      }
      return decodeSave(json);
    } on FormatException {
      // D16: disisihkan, bukan dihapus; .corrupt yang lama ditimpa.
      await file.rename('$_path.corrupt');
      return null;
    }
  }

  @override
  Future<void> save(PetState state) {
    final result = _lastSave.then((_) => _write(state));
    // Error sampai ke pemanggil lewat result, tapi tidak memutus antrean.
    _lastSave = result.catchError((_) {});
    return result;
  }

  // Atomik: pet.json selalu utuh, versi lama atau versi baru.
  Future<void> _write(PetState state) async {
    final tmp = File('$_path.tmp');
    await tmp.writeAsString(jsonEncode(encodeSave(state)), flush: true);
    await tmp.rename(_path);
  }
}
