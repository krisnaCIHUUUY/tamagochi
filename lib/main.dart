import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';

void main() {
  // Lisensi OFL wajib ikut saat font dibundel.
  LicenseRegistry.addLicense(() async* {
    for (final family in ['Fredoka', 'Lexend']) {
      final license = await rootBundle.loadString('assets/fonts/$family-OFL.txt');
      yield LicenseEntryWithLineBreaks([family], license);
    }
  });

  runApp(const TamaApp());
}
