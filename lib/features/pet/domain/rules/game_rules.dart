/// Semua angka aturan game di satu tempat. Nilai awal dari PRD "Aturan game"
/// dan usulan K1–K12 di rencana (D4); disetel ulang lewat playtest.
abstract final class GameRules {
  // Meter
  static const double maxMeter = 100;
  static const double minMeter = 0;
  static const double startFullness = 80; // K8
  static const double startHappiness = 80; // K8
  static const double fullnessDecayPerHour = 8;
  static const double happinessDecayPerHour = 6;
  static const double babyDecayMultiplier = 2;
  // K1: hanya berlaku saat simulate(offline: true).
  static const double offlineFloor = 10;

  // Berat (gram)
  static const int startWeight = 100; // K8
  static const int minWeight = 10; // K8

  // Aksi
  static const double feedFullness = 30;
  static const int feedWeight = 5;
  static const double snackHappiness = 15;
  static const double snackFullness = 10;
  static const int snackWeight = 10;
  static const double playHappiness = 20;
  static const int playWeight = -5;
  static const int maxSnacksPerHour = 5;
  static const int medicineDosesToCure = 2;

  // Kotoran (K9)
  static const Duration poopDelay = Duration(hours: 3);
  static const int maxPoop = 4;

  // Tidur dan lampu (K12)
  static const int sleepStartHour = 21;
  static const int sleepEndHour = 7;
  static const double lightsOnWakePenalty = 10;

  // Sakit
  static const Duration sickZeroNeedAfter = Duration(minutes: 60);
  static const int sickPoopThreshold = 3;
  static const Duration sickPoopAfter = Duration(hours: 2);

  // Murung, liburan, jemput
  static const double moodyThreshold = 20;
  static const Duration moodyAfter = Duration(hours: 6);
  static const Duration vacationAfter = Duration(hours: 48);
  static const double pickUpMeter = 50;

  // Tahap hidup
  static const Duration eggDuration = Duration(minutes: 5);
  static const Duration babyDuration = Duration(days: 1);
  static const Duration childDuration = Duration(days: 3);
  static const Duration teenDuration = Duration(days: 4);

  // Evolusi (K3–K6)
  static const double evolutionLeadRatio = 1.2;
  static const Duration timelyCleanWindow = Duration(hours: 1);
  static const double neglectThreshold = 20;
  static const int neglectMinutesPerPoint = 60;

  // Kedekatan (K7)
  static const double bondPerNeededAction = 1;
  static const double neededMeterThreshold = 50;

  // Mood dan panggilan (K11)
  static const double hungryMoodThreshold = 30;
  static const double happyMoodThreshold = 70;
  static const int maxAttention = 2;
}
