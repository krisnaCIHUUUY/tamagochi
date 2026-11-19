/// Satu-satunya sumber waktu di aplikasi (ADR-2). Hanya `PetBloc` yang memanggil [now].
abstract class Clock {
  DateTime now();
}
